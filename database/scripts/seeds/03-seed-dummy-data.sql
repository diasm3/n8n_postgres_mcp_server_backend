-- =====================================================
-- 더미 데이터 생성 스크립트
-- =====================================================

-- 이 파일은 개발/테스트 환경을 위한 더미 데이터를 생성합니다.
-- 운영 환경에서는 실행하지 마세요!

-- =====================================================
-- 1. Users 테이블 더미 데이터 (10,000명)
-- =====================================================

INSERT INTO users (
    id,
    email,
    password,
    "firstName",
    "lastName",
    "phoneNumber",
    "birthDate",
    role,
    "isActive",
    "profileImageUrl",
    preferences,
    address,
    "loginCount",
    "lastLoginAt",
    "lastLoginIp",
    metadata,
    "createdAt",
    "updatedAt"
)
SELECT
    uuid_generate_v4(),
    'user' || i || '@example.com',
    '$2b$10$' || md5(random()::text),
    CASE (random() * 9)::int
        WHEN 0 THEN '민수' WHEN 1 THEN '지훈' WHEN 2 THEN '서연'
        WHEN 3 THEN '예은' WHEN 4 THEN '도윤' WHEN 5 THEN '하준'
        WHEN 6 THEN '지우' WHEN 7 THEN '수빈' WHEN 8 THEN '시우' ELSE '윤서'
    END,
    CASE (random() * 9)::int
        WHEN 0 THEN '김' WHEN 1 THEN '이' WHEN 2 THEN '박'
        WHEN 3 THEN '최' WHEN 4 THEN '정' WHEN 5 THEN '강'
        WHEN 6 THEN '조' WHEN 7 THEN '윤' WHEN 8 THEN '장' ELSE '임'
    END,
    '010-' || lpad((random() * 9999)::int::text, 4, '0') || '-' || lpad((random() * 9999)::int::text, 4, '0'),
    (DATE '1970-01-01' + (random() * 18250)::int),
    CASE (random() * 2)::int WHEN 0 THEN 'customer' WHEN 1 THEN 'seller' ELSE 'admin' END,
    random() > 0.1,
    CASE WHEN random() > 0.5 THEN 'https://i.pravatar.cc/150?img=' || (random() * 70)::int ELSE NULL END,
    jsonb_build_object(
        'notifications', random() > 0.5,
        'newsletter', random() > 0.3,
        'language', CASE WHEN random() > 0.5 THEN 'ko' ELSE 'en' END
    ),
    jsonb_build_object(
        'city', CASE (random() * 4)::int WHEN 0 THEN '서울' WHEN 1 THEN '부산' WHEN 2 THEN '대구' WHEN 3 THEN '인천' ELSE '광주' END,
        'street', '테스트로 ' || (random() * 999)::int || '번길',
        'zipCode', lpad((random() * 99999)::int::text, 5, '0')
    ),
    (random() * 100)::int,
    NOW() - (random() * interval '365 days'),
    (random() * 255)::int || '.' || (random() * 255)::int || '.' || (random() * 255)::int || '.' || (random() * 255)::int,
    jsonb_build_object(
        'source', CASE (random() * 2)::int WHEN 0 THEN 'web' WHEN 1 THEN 'mobile' ELSE 'api' END,
        'version', '1.0.' || (random() * 100)::int
    ),
    NOW() - (random() * interval '730 days'),
    NOW() - (random() * interval '365 days')
FROM generate_series(1, 10000) AS i;

-- =====================================================
-- 2. User Logs 테이블 더미 데이터 (약 500,000개)
-- =====================================================

INSERT INTO user_logs (
    id,
    "userId",
    "eventType",
    "eventCategory",
    "eventData",
    "ipAddress",
    "userAgent",
    "deviceInfo",
    location,
    "sessionId",
    referrer,
    "currentUrl",
    "responseTime",
    "httpMethod",
    "statusCode",
    tags,
    level,
    "createdAt"
)
SELECT
    uuid_generate_v4(),
    u.id,
    CASE (random() * 9)::int
        WHEN 0 THEN 'login' WHEN 1 THEN 'logout' WHEN 2 THEN 'page_view'
        WHEN 3 THEN 'purchase' WHEN 4 THEN 'search' WHEN 5 THEN 'add_to_cart'
        WHEN 6 THEN 'remove_from_cart' WHEN 7 THEN 'product_view'
        WHEN 8 THEN 'checkout' ELSE 'click'
    END,
    CASE (random() * 5)::int
        WHEN 0 THEN 'authentication' WHEN 1 THEN 'transaction'
        WHEN 2 THEN 'navigation' WHEN 3 THEN 'interaction'
        WHEN 4 THEN 'shopping' ELSE 'system'
    END,
    jsonb_build_object(
        'action', 'user_action_' || (random() * 100)::int,
        'value', (random() * 1000)::int,
        'productId', CASE WHEN random() > 0.5 THEN 'prod_' || (random() * 1000)::int ELSE NULL END,
        'amount', (random() * 500000)::int,
        'timestamp', NOW() - (random() * interval '90 days')
    ),
    (random() * 255)::int || '.' || (random() * 255)::int || '.' || (random() * 255)::int || '.' || (random() * 255)::int,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        WHEN 1 THEN 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)'
        WHEN 2 THEN 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)'
        WHEN 3 THEN 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0)'
        WHEN 4 THEN 'Mozilla/5.0 (Linux; Android 13) Chrome/120.0.6099.144'
        ELSE 'Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X)'
    END,
    jsonb_build_object(
        'device', CASE (random() * 3)::int WHEN 0 THEN 'mobile' WHEN 1 THEN 'desktop' WHEN 2 THEN 'tablet' ELSE 'unknown' END,
        'os', CASE (random() * 4)::int WHEN 0 THEN 'iOS' WHEN 1 THEN 'Android' WHEN 2 THEN 'Windows' WHEN 3 THEN 'macOS' ELSE 'Linux' END,
        'browser', CASE (random() * 3)::int WHEN 0 THEN 'Chrome' WHEN 1 THEN 'Safari' WHEN 2 THEN 'Firefox' ELSE 'Edge' END
    ),
    jsonb_build_object(
        'country', CASE (random() * 5)::int WHEN 0 THEN 'KR' WHEN 1 THEN 'US' WHEN 2 THEN 'JP' WHEN 3 THEN 'CN' ELSE 'GB' END,
        'city', CASE (random() * 8)::int WHEN 0 THEN 'Seoul' WHEN 1 THEN 'Busan' WHEN 2 THEN 'Tokyo' ELSE 'New York' END,
        'lat', (random() * 90 - 45)::numeric(10,6),
        'lng', (random() * 180 - 90)::numeric(10,6)
    ),
    md5(random()::text || i::text),
    CASE (random() * 4)::int WHEN 0 THEN 'https://www.google.com' WHEN 1 THEN 'https://www.naver.com' ELSE 'https://m.facebook.com' END,
    'https://example.com/' || CASE (random() * 5)::int WHEN 0 THEN 'products' WHEN 1 THEN 'cart' ELSE 'home' END,
    (50 + random() * 2000)::int,
    CASE (random() * 4)::int WHEN 0 THEN 'GET' WHEN 1 THEN 'POST' WHEN 2 THEN 'PUT' ELSE 'DELETE' END,
    CASE (random() * 8)::int WHEN 0 THEN 200 WHEN 1 THEN 201 WHEN 2 THEN 204 ELSE 500 END,
    jsonb_build_array(
        CASE (random() * 5)::int WHEN 0 THEN 'important' WHEN 1 THEN 'analytics' ELSE 'marketing' END,
        CASE (random() * 3)::int WHEN 0 THEN 'tracked' WHEN 1 THEN 'processed' ELSE 'verified' END
    ),
    CASE (random() * 4)::int WHEN 0 THEN 'info' WHEN 1 THEN 'warning' WHEN 2 THEN 'error' ELSE 'debug' END,
    u."createdAt" + (random() * (NOW() - u."createdAt"))
FROM users u
CROSS JOIN generate_series(1, 50) AS i
WHERE random() > 0.05;

-- =====================================================
-- 3. CS 시스템 더미 데이터
-- =====================================================

-- 3-1. 응답 템플릿
INSERT INTO complaint_templates (category, sub_category, template_name, template_content, variables, created_by)
SELECT
    CASE (random() * 5)::int
        WHEN 0 THEN '가격정보' WHEN 1 THEN '상품정보' WHEN 2 THEN '배송구매'
        WHEN 3 THEN '리뷰평점' WHEN 4 THEN '회원개인정보' ELSE '시스템기술'
    END,
    '서브카테고리-' || i,
    '템플릿-' || i,
    '고객님, 안녕하세요. [변수1]에 대한 문의 주셔서 감사합니다. [변수2]',
    jsonb_build_array('변수1', '변수2'),
    (SELECT id FROM users ORDER BY random() LIMIT 1)
FROM generate_series(1, 20) AS i;

-- 3-2. 지식베이스
INSERT INTO complaint_knowledge_base (category, sub_category, question, answer, keywords, view_count, helpful_count, not_helpful_count, created_by)
SELECT
    CASE (random() * 5)::int
        WHEN 0 THEN '가격정보' WHEN 1 THEN '상품정보' WHEN 2 THEN '배송구매'
        WHEN 3 THEN '리뷰평점' WHEN 4 THEN '회원개인정보' ELSE '시스템기술'
    END,
    '서브-' || i,
    '자주 묻는 질문 ' || i || ': 어떻게 하나요?',
    '답변 ' || i || ': 다음 절차를 따라주세요.',
    jsonb_build_array('가격', '배송', '환불'),
    (random() * 1000)::int,
    (random() * 100)::int,
    (random() * 20)::int,
    (SELECT id FROM users ORDER BY random() LIMIT 1)
FROM generate_series(1, 50) AS i;

-- 3-3. 고객 컴플레인 (1,000개)
INSERT INTO customer_complaints (
    user_id, customer_name, customer_email, customer_phone,
    category, sub_category, priority, urgency,
    subject, description, status, assigned_to, created_at
)
SELECT
    (SELECT id FROM users ORDER BY random() LIMIT 1),
    u."firstName" || ' ' || u."lastName",
    u.email,
    u."phoneNumber",
    CASE (random() * 5)::int
        WHEN 0 THEN '가격정보' WHEN 1 THEN '상품정보' WHEN 2 THEN '배송구매'
        WHEN 3 THEN '리뷰평점' WHEN 4 THEN '회원개인정보' ELSE '시스템기술'
    END,
    '서브카테고리',
    CASE (random() * 2)::int WHEN 0 THEN 'high' WHEN 1 THEN 'medium' ELSE 'low' END,
    CASE (random() * 2)::int WHEN 0 THEN 'urgent' WHEN 1 THEN 'normal' ELSE 'low' END,
    '문의 제목 ' || i,
    '문의 상세 내용입니다.',
    CASE (random() * 5)::int WHEN 0 THEN '접수' WHEN 1 THEN '처리중' ELSE '해결완료' END,
    CASE WHEN random() > 0.3 THEN (SELECT id FROM users WHERE role = 'admin' ORDER BY random() LIMIT 1) ELSE NULL END,
    NOW() - (random() * interval '60 days')
FROM users u
ORDER BY random()
LIMIT 1000;

-- =====================================================
-- 완료 메시지
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '======================================';
    RAISE NOTICE '더미 데이터 생성 완료!';
    RAISE NOTICE '======================================';
    RAISE NOTICE 'Users: ~10,000명';
    RAISE NOTICE 'User Logs: ~500,000개';
    RAISE NOTICE 'CS Complaints: 1,000개';
    RAISE NOTICE 'Templates: 20개';
    RAISE NOTICE 'Knowledge Base: 50개';
    RAISE NOTICE '======================================';
END $$;
