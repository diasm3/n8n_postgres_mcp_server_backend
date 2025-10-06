-- =====================================================
-- 중고나라 CS 시스템 데이터베이스 스키마
-- =====================================================

-- UUID 확장 활성화
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. 고객 컴플레인 메인 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS customer_complaints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    -- 티켓 정보
    ticket_number VARCHAR(50) UNIQUE NOT NULL,

    -- 고객 정보
    user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(20),

    -- 문의 분류
    category VARCHAR(50) NOT NULL CHECK (category IN (
        '가격정보', '상품정보', '배송구매', '리뷰평점', '회원개인정보', '시스템기술'
    )),
    sub_category VARCHAR(100),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('high', 'medium', 'low')),
    urgency VARCHAR(20) DEFAULT 'normal' CHECK (urgency IN ('urgent', 'normal', 'low')),

    -- 내용
    subject VARCHAR(500) NOT NULL,
    description TEXT NOT NULL,
    attachments JSONB DEFAULT '[]',

    -- 상태 관리
    status VARCHAR(50) DEFAULT '접수' CHECK (status IN (
        '접수', '처리중', '보류', '해결완료', '재문의', '종결'
    )),
    escalation_level INTEGER DEFAULT 1 CHECK (escalation_level BETWEEN 1 AND 4),
    is_escalated BOOLEAN DEFAULT false,

    -- 처리 정보
    assigned_to TEXT REFERENCES users(id) ON DELETE SET NULL,
    assigned_team VARCHAR(50),
    first_response_at TIMESTAMP,
    resolved_at TIMESTAMP,
    response_time INTEGER, -- 분 단위
    resolution_time INTEGER, -- 분 단위

    -- 관련 정보
    related_product_id VARCHAR(100),
    related_order_id VARCHAR(100),
    related_seller_id VARCHAR(100),
    jira_ticket_key VARCHAR(50),

    -- 보상/조치
    compensation_type VARCHAR(50) CHECK (compensation_type IN (
        '포인트지급', '환불', '교환', '쿠폰', '없음'
    )),
    compensation_amount INTEGER DEFAULT 0,
    compensation_note TEXT,

    -- 고객 만족도
    satisfaction_score INTEGER CHECK (satisfaction_score BETWEEN 1 AND 5),
    feedback_comment TEXT,

    -- 메타데이터
    tags JSONB DEFAULT '[]',
    metadata JSONB DEFAULT '{}',

    -- 타임스탬프
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- 2. 컴플레인 응답/댓글 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS complaint_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    complaint_id UUID NOT NULL REFERENCES customer_complaints(id) ON DELETE CASCADE,
    responder_id TEXT REFERENCES users(id) ON DELETE SET NULL,

    responder_type VARCHAR(20) DEFAULT 'agent' CHECK (responder_type IN (
        'agent', 'system', 'customer'
    )),
    response_type VARCHAR(50) DEFAULT 'reply' CHECK (response_type IN (
        'reply', 'inquiry', 'internal_note', 'system_notification'
    )),

    content TEXT NOT NULL,
    attachments JSONB DEFAULT '[]',

    is_internal BOOLEAN DEFAULT false,
    is_auto_response BOOLEAN DEFAULT false,

    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- 3. 컴플레인 처리 이력 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS complaint_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    complaint_id UUID NOT NULL REFERENCES customer_complaints(id) ON DELETE CASCADE,
    actor_id TEXT REFERENCES users(id) ON DELETE SET NULL,

    action VARCHAR(100) NOT NULL,
    from_value VARCHAR(255),
    to_value VARCHAR(255),
    note TEXT,
    metadata JSONB DEFAULT '{}',

    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- 4. 응답 템플릿 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS complaint_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    category VARCHAR(50),
    sub_category VARCHAR(100),
    template_name VARCHAR(200) NOT NULL,
    template_content TEXT NOT NULL,
    variables JSONB DEFAULT '[]',

    is_active BOOLEAN DEFAULT true,
    usage_count INTEGER DEFAULT 0,

    created_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- 5. SLA 규칙 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS complaint_sla_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    category VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL,

    first_response_time INTEGER NOT NULL, -- 분 단위
    resolution_time INTEGER NOT NULL, -- 분 단위
    escalation_time INTEGER, -- 분 단위

    is_active BOOLEAN DEFAULT true,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(category, priority)
);

-- =====================================================
-- 6. FAQ/지식베이스 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS complaint_knowledge_base (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    category VARCHAR(50) NOT NULL,
    sub_category VARCHAR(100),

    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    keywords JSONB DEFAULT '[]',
    related_articles JSONB DEFAULT '[]',

    view_count INTEGER DEFAULT 0,
    helpful_count INTEGER DEFAULT 0,
    not_helpful_count INTEGER DEFAULT 0,

    is_published BOOLEAN DEFAULT true,

    created_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- 인덱스 생성
-- =====================================================

-- customer_complaints 인덱스
CREATE INDEX idx_complaints_ticket_number ON customer_complaints(ticket_number);
CREATE INDEX idx_complaints_user_id ON customer_complaints(user_id);
CREATE INDEX idx_complaints_category ON customer_complaints(category);
CREATE INDEX idx_complaints_status ON customer_complaints(status);
CREATE INDEX idx_complaints_priority ON customer_complaints(priority);
CREATE INDEX idx_complaints_assigned_to ON customer_complaints(assigned_to);
CREATE INDEX idx_complaints_created_at ON customer_complaints(created_at DESC);
CREATE INDEX idx_complaints_status_priority ON customer_complaints(status, priority);
CREATE INDEX idx_complaints_category_status ON customer_complaints(category, status);

-- complaint_responses 인덱스
CREATE INDEX idx_responses_complaint_id ON complaint_responses(complaint_id);
CREATE INDEX idx_responses_responder_id ON complaint_responses(responder_id);
CREATE INDEX idx_responses_created_at ON complaint_responses(created_at DESC);
CREATE INDEX idx_responses_complaint_created ON complaint_responses(complaint_id, created_at);

-- complaint_history 인덱스
CREATE INDEX idx_history_complaint_id ON complaint_history(complaint_id);
CREATE INDEX idx_history_actor_id ON complaint_history(actor_id);
CREATE INDEX idx_history_created_at ON complaint_history(created_at DESC);
CREATE INDEX idx_history_action ON complaint_history(action);

-- complaint_templates 인덱스
CREATE INDEX idx_templates_category ON complaint_templates(category);
CREATE INDEX idx_templates_is_active ON complaint_templates(is_active);
CREATE INDEX idx_templates_usage_count ON complaint_templates(usage_count DESC);

-- complaint_sla_rules 인덱스
CREATE INDEX idx_sla_category_priority ON complaint_sla_rules(category, priority);
CREATE INDEX idx_sla_is_active ON complaint_sla_rules(is_active);

-- complaint_knowledge_base 인덱스
CREATE INDEX idx_kb_category ON complaint_knowledge_base(category);
CREATE INDEX idx_kb_is_published ON complaint_knowledge_base(is_published);
CREATE INDEX idx_kb_view_count ON complaint_knowledge_base(view_count DESC);
CREATE INDEX idx_kb_helpful_count ON complaint_knowledge_base(helpful_count DESC);

-- JSONB 인덱스 (GIN)
CREATE INDEX idx_complaints_tags ON customer_complaints USING GIN(tags);
CREATE INDEX idx_complaints_metadata ON customer_complaints USING GIN(metadata);
CREATE INDEX idx_kb_keywords ON complaint_knowledge_base USING GIN(keywords);

-- =====================================================
-- 트리거: updated_at 자동 업데이트
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_customer_complaints_updated_at BEFORE UPDATE ON customer_complaints
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_complaint_templates_updated_at BEFORE UPDATE ON complaint_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_complaint_sla_rules_updated_at BEFORE UPDATE ON complaint_sla_rules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_complaint_knowledge_base_updated_at BEFORE UPDATE ON complaint_knowledge_base
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 시퀀스: 티켓 번호 생성
-- =====================================================

CREATE SEQUENCE IF NOT EXISTS complaint_ticket_seq START 1;

-- =====================================================
-- 함수: 티켓 번호 자동 생성
-- =====================================================

CREATE OR REPLACE FUNCTION generate_ticket_number()
RETURNS TRIGGER AS $$
DECLARE
    year_month TEXT;
    seq_num TEXT;
BEGIN
    year_month := TO_CHAR(NOW(), 'YYYY-MM');
    seq_num := LPAD(nextval('complaint_ticket_seq')::TEXT, 5, '0');
    NEW.ticket_number := 'CS-' || year_month || '-' || seq_num;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_complaint_ticket_number
    BEFORE INSERT ON customer_complaints
    FOR EACH ROW
    WHEN (NEW.ticket_number IS NULL)
    EXECUTE FUNCTION generate_ticket_number();

-- =====================================================
-- 기본 SLA 규칙 데이터 삽입
-- =====================================================

INSERT INTO complaint_sla_rules (category, priority, first_response_time, resolution_time, escalation_time) VALUES
    ('가격정보', 'high', 60, 240, 120),
    ('가격정보', 'medium', 240, 1440, 480),
    ('가격정보', 'low', 1440, 4320, 2880),

    ('상품정보', 'high', 60, 240, 120),
    ('상품정보', 'medium', 240, 1440, 480),
    ('상품정보', 'low', 1440, 4320, 2880),

    ('배송구매', 'high', 30, 120, 60),
    ('배송구매', 'medium', 120, 720, 240),
    ('배송구매', 'low', 720, 2880, 1440),

    ('리뷰평점', 'high', 120, 480, 240),
    ('리뷰평점', 'medium', 480, 1440, 720),
    ('리뷰평점', 'low', 1440, 4320, 2880),

    ('회원개인정보', 'high', 30, 120, 60),
    ('회원개인정보', 'medium', 120, 480, 240),
    ('회원개인정보', 'low', 480, 1440, 720),

    ('시스템기술', 'high', 30, 180, 60),
    ('시스템기술', 'medium', 180, 720, 360),
    ('시스템기술', 'low', 720, 2880, 1440)
ON CONFLICT (category, priority) DO NOTHING;

-- =====================================================
-- 뷰: 미처리 컴플레인 대시보드
-- =====================================================

CREATE OR REPLACE VIEW v_pending_complaints AS
SELECT
    c.id,
    c.ticket_number,
    c.category,
    c.sub_category,
    c.priority,
    c.status,
    c.customer_name,
    c.customer_email,
    c.subject,
    c.assigned_to,
    u."firstName" || ' ' || u."lastName" AS assigned_agent_name,
    c.created_at,
    c.first_response_at,
    EXTRACT(EPOCH FROM (NOW() - c.created_at))/60 AS minutes_since_created,
    sla.first_response_time,
    sla.resolution_time,
    CASE
        WHEN c.first_response_at IS NULL AND EXTRACT(EPOCH FROM (NOW() - c.created_at))/60 > sla.first_response_time
        THEN true
        ELSE false
    END AS is_sla_breached
FROM customer_complaints c
LEFT JOIN users u ON c.assigned_to = u.id
LEFT JOIN complaint_sla_rules sla ON c.category = sla.category AND c.priority = sla.priority
WHERE c.status NOT IN ('해결완료', '종결')
ORDER BY c.priority DESC, c.created_at ASC;

-- =====================================================
-- 완료 메시지
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '======================================';
    RAISE NOTICE 'CS 시스템 테이블 생성 완료!';
    RAISE NOTICE '======================================';
    RAISE NOTICE '생성된 테이블:';
    RAISE NOTICE '  - customer_complaints (고객 컴플레인)';
    RAISE NOTICE '  - complaint_responses (응답/댓글)';
    RAISE NOTICE '  - complaint_history (처리 이력)';
    RAISE NOTICE '  - complaint_templates (응답 템플릿)';
    RAISE NOTICE '  - complaint_sla_rules (SLA 규칙)';
    RAISE NOTICE '  - complaint_knowledge_base (지식베이스)';
    RAISE NOTICE '';
    RAISE NOTICE '생성된 뷰:';
    RAISE NOTICE '  - v_pending_complaints (미처리 컴플레인 대시보드)';
    RAISE NOTICE '======================================';
END $$;
