-- =====================================================
-- Internal Users Schema (CS 담당자 및 개발자)
-- =====================================================

-- UUID extension 활성화
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CS 팀 및 개발팀 구성원 테이블
CREATE TABLE IF NOT EXISTS internal_users (
    id TEXT PRIMARY KEY DEFAULT uuid_generate_v4()::TEXT,
    email VARCHAR(255) UNIQUE NOT NULL,
    "firstName" VARCHAR(100) NOT NULL,
    "lastName" VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),

    -- 직무 정보
    department VARCHAR(50) NOT NULL, -- 'CS', 'DEVELOPMENT', 'PRODUCT', 'MANAGEMENT'
    position VARCHAR(100) NOT NULL, -- '주니어 상담원', '시니어 상담원', '팀장', '백엔드 개발자' 등
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL, -- 'agent', 'senior_agent', 'team_leader', 'developer', 'manager'

    -- 권한 및 레벨
    access_level INTEGER NOT NULL DEFAULT 1, -- 1: 일반, 2: 선임, 3: 팀장, 4: 매니저, 5: 관리자
    permissions JSONB DEFAULT '[]', -- ['view_complaints', 'handle_complaints', 'escalate', 'admin'] 등

    -- CS 전문성 (CS 팀원만 해당)
    specialties JSONB DEFAULT '[]', -- ['price_info', 'product_info', 'delivery', 'technical'] 등
    max_concurrent_tickets INTEGER DEFAULT 5, -- 동시 처리 가능 티켓 수

    -- 근무 정보
    work_schedule JSONB, -- { "monday": "09:00-18:00", "tuesday": "09:00-18:00", ... }
    is_available BOOLEAN DEFAULT true, -- 현재 업무 가능 여부
    current_workload INTEGER DEFAULT 0, -- 현재 담당 티켓 수

    -- 성과 지표
    total_tickets_handled INTEGER DEFAULT 0,
    avg_resolution_time INTEGER, -- 평균 해결 시간(분)
    satisfaction_rating DECIMAL(3,2), -- 고객 만족도 평점 (0.00-5.00)

    -- 상태 정보
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'on_leave', 'busy', 'offline', 'inactive'
    last_active_at TIMESTAMP,

    -- 메타데이터
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX idx_internal_users_department ON internal_users(department);
CREATE INDEX idx_internal_users_role ON internal_users(role);
CREATE INDEX idx_internal_users_status ON internal_users(status);
CREATE INDEX idx_internal_users_is_available ON internal_users(is_available);
CREATE INDEX idx_internal_users_access_level ON internal_users(access_level);

-- 팀 테이블
CREATE TABLE IF NOT EXISTS teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    department VARCHAR(50) NOT NULL,
    description TEXT,
    team_leader_id TEXT REFERENCES internal_users(id) ON DELETE SET NULL,
    member_count INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 팀 멤버십 테이블
CREATE TABLE IF NOT EXISTS team_members (
    id SERIAL PRIMARY KEY,
    team_id INTEGER REFERENCES teams(id) ON DELETE CASCADE,
    user_id TEXT REFERENCES internal_users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT NOW(),
    role_in_team VARCHAR(50), -- 'member', 'leader', 'deputy'
    UNIQUE(team_id, user_id)
);

-- 근무 일정 테이블
CREATE TABLE IF NOT EXISTS work_shifts (
    id SERIAL PRIMARY KEY,
    user_id TEXT REFERENCES internal_users(id) ON DELETE CASCADE,
    shift_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    shift_type VARCHAR(20) DEFAULT 'regular', -- 'regular', 'overtime', 'on_call'
    status VARCHAR(20) DEFAULT 'scheduled', -- 'scheduled', 'completed', 'cancelled'
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_work_shifts_user_date ON work_shifts(user_id, shift_date);
CREATE INDEX idx_work_shifts_date ON work_shifts(shift_date);

-- 휴가/부재 테이블
CREATE TABLE IF NOT EXISTS user_absences (
    id SERIAL PRIMARY KEY,
    user_id TEXT REFERENCES internal_users(id) ON DELETE CASCADE,
    absence_type VARCHAR(50) NOT NULL, -- 'vacation', 'sick_leave', 'personal', 'training'
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    approved_by TEXT REFERENCES internal_users(id) ON DELETE SET NULL,
    approved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_user_absences_user_date ON user_absences(user_id, start_date, end_date);

-- 성과 기록 테이블
CREATE TABLE IF NOT EXISTS performance_records (
    id SERIAL PRIMARY KEY,
    user_id TEXT REFERENCES internal_users(id) ON DELETE CASCADE,
    record_date DATE NOT NULL,
    tickets_handled INTEGER DEFAULT 0,
    avg_response_time INTEGER, -- 분
    avg_resolution_time INTEGER, -- 분
    customer_satisfaction DECIMAL(3,2),
    escalation_count INTEGER DEFAULT 0,
    quality_score DECIMAL(3,2), -- 품질 점수 (0.00-5.00)
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_performance_records_user_date ON performance_records(user_id, record_date);

-- 스킬/교육 테이블
CREATE TABLE IF NOT EXISTS user_skills (
    id SERIAL PRIMARY KEY,
    user_id TEXT REFERENCES internal_users(id) ON DELETE CASCADE,
    skill_name VARCHAR(100) NOT NULL,
    skill_category VARCHAR(50), -- 'technical', 'product', 'communication', 'language'
    proficiency_level INTEGER DEFAULT 1, -- 1-5
    certified BOOLEAN DEFAULT false,
    certification_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_user_skills_user ON user_skills(user_id);
CREATE INDEX idx_user_skills_category ON user_skills(skill_category);

-- 업데이트 타임스탬프 자동 갱신 트리거
CREATE OR REPLACE FUNCTION update_internal_users_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_internal_users_timestamp
BEFORE UPDATE ON internal_users
FOR EACH ROW
EXECUTE FUNCTION update_internal_users_timestamp();

CREATE TRIGGER trigger_update_teams_timestamp
BEFORE UPDATE ON teams
FOR EACH ROW
EXECUTE FUNCTION update_internal_users_timestamp();

-- 팀 멤버 수 자동 업데이트 트리거
CREATE OR REPLACE FUNCTION update_team_member_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE teams SET member_count = member_count + 1 WHERE id = NEW.team_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE teams SET member_count = member_count - 1 WHERE id = OLD.team_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_team_member_count
AFTER INSERT OR DELETE ON team_members
FOR EACH ROW
EXECUTE FUNCTION update_team_member_count();

-- 뷰: 현재 활성 CS 담당자 현황
CREATE OR REPLACE VIEW active_cs_agents AS
SELECT
    iu.id,
    iu."firstName" || ' ' || iu."lastName" AS full_name,
    iu.email,
    iu.department,
    iu.position,
    iu.role,
    iu.access_level,
    iu.specialties,
    iu.current_workload,
    iu.max_concurrent_tickets,
    iu.is_available,
    iu.status,
    iu.satisfaction_rating,
    t.name AS team_name
FROM internal_users iu
LEFT JOIN team_members tm ON iu.id = tm.user_id
LEFT JOIN teams t ON tm.team_id = t.id
WHERE iu.department = 'CS'
  AND iu.status = 'active'
  AND iu.is_available = true;

-- 뷰: 팀별 성과 요약
CREATE OR REPLACE VIEW team_performance_summary AS
SELECT
    t.id AS team_id,
    t.name AS team_name,
    t.department,
    COUNT(tm.user_id) AS team_size,
    AVG(iu.satisfaction_rating) AS avg_satisfaction,
    SUM(iu.total_tickets_handled) AS total_tickets,
    AVG(iu.avg_resolution_time) AS avg_resolution_time,
    SUM(iu.current_workload) AS current_total_workload
FROM teams t
LEFT JOIN team_members tm ON t.id = tm.team_id
LEFT JOIN internal_users iu ON tm.user_id = iu.id
WHERE iu.status = 'active'
GROUP BY t.id, t.name, t.department;

COMMENT ON TABLE internal_users IS 'CS 담당자 및 개발자 등 내부 직원 정보';
COMMENT ON TABLE teams IS '팀 정보';
COMMENT ON TABLE team_members IS '팀 멤버십 관계';
COMMENT ON TABLE work_shifts IS '근무 일정';
COMMENT ON TABLE user_absences IS '휴가 및 부재 기록';
COMMENT ON TABLE performance_records IS '일일 성과 기록';
COMMENT ON TABLE user_skills IS '직원 스킬 및 자격증';
