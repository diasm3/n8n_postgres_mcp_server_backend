-- =====================================================
-- Internal Users Dummy Data (CS 담당자 및 개발자)
-- =====================================================

-- 1. 팀 생성
INSERT INTO teams (name, department, description) VALUES
('CS 1팀', 'CS', '고객 문의 1차 대응팀'),
('CS 2팀', 'CS', '고객 문의 2차 대응팀'),
('VIP 고객 지원팀', 'CS', 'VIP 및 고액 거래 고객 전담팀'),
('기술 지원팀', 'CS', '기술 문의 전담팀'),
('백엔드 개발팀', 'DEVELOPMENT', '서버 및 API 개발'),
('프론트엔드 개발팀', 'DEVELOPMENT', '웹/앱 UI 개발'),
('인프라팀', 'DEVELOPMENT', 'DevOps 및 인프라 관리'),
('QA팀', 'DEVELOPMENT', '품질 보증 및 테스트'),
('프로덕트팀', 'PRODUCT', '제품 기획 및 관리'),
('경영지원팀', 'MANAGEMENT', '경영 및 관리');

-- 2. Internal Users 생성

-- CS 팀 (총 40명)
INSERT INTO internal_users (
    email, "firstName", "lastName", password, phone_number,
    department, position, employee_id, role, access_level,
    permissions, specialties, max_concurrent_tickets,
    work_schedule, is_available, status, satisfaction_rating
)
SELECT
    'cs' || i || '@junggo.com',
    CASE (i % 20)
        WHEN 0 THEN '민지' WHEN 1 THEN '서연' WHEN 2 THEN '지우' WHEN 3 THEN '하은' WHEN 4 THEN '수아'
        WHEN 5 THEN '지민' WHEN 6 THEN '윤서' WHEN 7 THEN '채원' WHEN 8 THEN '다은' WHEN 9 THEN '예은'
        WHEN 10 THEN '준서' WHEN 11 THEN '시우' WHEN 12 THEN '도윤' WHEN 13 THEN '예준' WHEN 14 THEN '하준'
        WHEN 15 THEN '서준' WHEN 16 THEN '민준' WHEN 17 THEN '지호' WHEN 18 THEN '우진' WHEN 19 THEN '현우'
    END,
    CASE (i % 10)
        WHEN 0 THEN '김' WHEN 1 THEN '이' WHEN 2 THEN '박' WHEN 3 THEN '최' WHEN 4 THEN '정'
        WHEN 5 THEN '강' WHEN 6 THEN '조' WHEN 7 THEN '윤' WHEN 8 THEN '장' WHEN 9 THEN '임'
    END,
    '$2b$10$abcdefghijklmnopqrstuv',
    '010-' || LPAD((1000 + i)::TEXT, 4, '0') || '-' || LPAD((i * 13 % 10000)::TEXT, 4, '0'),
    'CS',
    CASE
        WHEN i <= 5 THEN '팀장'
        WHEN i <= 15 THEN '시니어 상담원'
        ELSE '주니어 상담원'
    END,
    'CS-' || LPAD(i::TEXT, 4, '0'),
    CASE
        WHEN i <= 5 THEN 'team_leader'
        WHEN i <= 15 THEN 'senior_agent'
        ELSE 'agent'
    END,
    CASE
        WHEN i <= 5 THEN 3
        WHEN i <= 15 THEN 2
        ELSE 1
    END,
    CASE
        WHEN i <= 5 THEN '["view_complaints", "handle_complaints", "escalate", "manage_team", "view_reports"]'::JSONB
        WHEN i <= 15 THEN '["view_complaints", "handle_complaints", "escalate"]'::JSONB
        ELSE '["view_complaints", "handle_complaints"]'::JSONB
    END,
    CASE (i % 4)
        WHEN 0 THEN '["price_info", "product_info"]'::JSONB
        WHEN 1 THEN '["delivery", "purchase"]'::JSONB
        WHEN 2 THEN '["technical", "account"]'::JSONB
        WHEN 3 THEN '["review", "product_info"]'::JSONB
    END,
    CASE
        WHEN i <= 5 THEN 10
        WHEN i <= 15 THEN 7
        ELSE 5
    END,
    '{"monday": "09:00-18:00", "tuesday": "09:00-18:00", "wednesday": "09:00-18:00", "thursday": "09:00-18:00", "friday": "09:00-18:00"}'::JSONB,
    (i % 10) < 8, -- 80%가 available
    CASE (i % 10)
        WHEN 9 THEN 'on_leave'
        ELSE 'active'
    END,
    3.5 + (RANDOM() * 1.5) -- 3.5 ~ 5.0
FROM generate_series(1, 40) AS i;

-- 개발팀 (총 30명)
INSERT INTO internal_users (
    email, "firstName", "lastName", password, phone_number,
    department, position, employee_id, role, access_level,
    permissions, specialties, max_concurrent_tickets,
    work_schedule, is_available, status
)
SELECT
    'dev' || i || '@junggo.com',
    CASE (i % 15)
        WHEN 0 THEN '지훈' WHEN 1 THEN '태양' WHEN 2 THEN '민혁' WHEN 3 THEN '승현' WHEN 4 THEN '재현'
        WHEN 5 THEN '동욱' WHEN 6 THEN '성민' WHEN 7 THEN '진우' WHEN 8 THEN '상훈' WHEN 9 THEN '은우'
        WHEN 10 THEN '수빈' WHEN 11 THEN '예린' WHEN 12 THEN '서현' WHEN 13 THEN '유진' WHEN 14 THEN '하린'
    END,
    CASE (i % 8)
        WHEN 0 THEN '김' WHEN 1 THEN '이' WHEN 2 THEN '박' WHEN 3 THEN '최'
        WHEN 4 THEN '정' WHEN 5 THEN '강' WHEN 6 THEN '조' WHEN 7 THEN '윤'
    END,
    '$2b$10$abcdefghijklmnopqrstuv',
    '010-' || LPAD((2000 + i)::TEXT, 4, '0') || '-' || LPAD((i * 17 % 10000)::TEXT, 4, '0'),
    'DEVELOPMENT',
    CASE
        WHEN i <= 3 THEN '개발 팀장'
        WHEN i <= 10 THEN '시니어 개발자'
        ELSE '주니어 개발자'
    END,
    'DEV-' || LPAD(i::TEXT, 4, '0'),
    CASE
        WHEN i <= 3 THEN 'manager'
        ELSE 'developer'
    END,
    CASE
        WHEN i <= 3 THEN 4
        WHEN i <= 10 THEN 3
        ELSE 2
    END,
    CASE
        WHEN i <= 3 THEN '["view_complaints", "handle_complaints", "escalate", "manage_team", "system_admin", "view_reports"]'::JSONB
        ELSE '["view_complaints", "handle_technical", "system_access"]'::JSONB
    END,
    CASE (i % 4)
        WHEN 0 THEN '["backend", "api", "database"]'::JSONB
        WHEN 1 THEN '["frontend", "ui", "mobile"]'::JSONB
        WHEN 2 THEN '["devops", "infrastructure", "monitoring"]'::JSONB
        WHEN 3 THEN '["qa", "testing", "automation"]'::JSONB
    END,
    3,
    '{"monday": "10:00-19:00", "tuesday": "10:00-19:00", "wednesday": "10:00-19:00", "thursday": "10:00-19:00", "friday": "10:00-19:00"}'::JSONB,
    (i % 10) < 9, -- 90%가 available
    'active'
FROM generate_series(1, 30) AS i;

-- 프로덕트팀 (총 10명)
INSERT INTO internal_users (
    email, "firstName", "lastName", password, phone_number,
    department, position, employee_id, role, access_level,
    permissions, work_schedule, is_available, status
)
SELECT
    'pm' || i || '@junggo.com',
    CASE (i % 5)
        WHEN 0 THEN '현아' WHEN 1 THEN '지원' WHEN 2 THEN '민경' WHEN 3 THEN '소연' WHEN 4 THEN '유리'
    END,
    CASE (i % 5)
        WHEN 0 THEN '김' WHEN 1 THEN '이' WHEN 2 THEN '박' WHEN 3 THEN '최' WHEN 4 THEN '정'
    END,
    '$2b$10$abcdefghijklmnopqrstuv',
    '010-' || LPAD((3000 + i)::TEXT, 4, '0') || '-' || LPAD((i * 19 % 10000)::TEXT, 4, '0'),
    'PRODUCT',
    CASE
        WHEN i <= 2 THEN '프로덕트 매니저'
        ELSE '프로덕트 오너'
    END,
    'PM-' || LPAD(i::TEXT, 4, '0'),
    CASE
        WHEN i <= 2 THEN 'manager'
        ELSE 'product_owner'
    END,
    CASE
        WHEN i <= 2 THEN 4
        ELSE 3
    END,
    '["view_complaints", "view_reports", "product_planning", "feature_request"]'::JSONB,
    '{"monday": "09:00-18:00", "tuesday": "09:00-18:00", "wednesday": "09:00-18:00", "thursday": "09:00-18:00", "friday": "09:00-18:00"}'::JSONB,
    true,
    'active'
FROM generate_series(1, 10) AS i;

-- 경영지원팀 (총 5명)
INSERT INTO internal_users (
    email, "firstName", "lastName", password, phone_number,
    department, position, employee_id, role, access_level,
    permissions, work_schedule, is_available, status
)
VALUES
('ceo@junggo.com', '영호', '김', '$2b$10$abcdefghijklmnopqrstuv', '010-1000-0001', 'MANAGEMENT', 'CEO', 'MGT-0001', 'ceo', 5, '["view_all", "manage_all", "admin"]'::JSONB, '{"monday": "09:00-18:00", "tuesday": "09:00-18:00", "wednesday": "09:00-18:00", "thursday": "09:00-18:00", "friday": "09:00-18:00"}'::JSONB, true, 'active'),
('cto@junggo.com', '성민', '이', '$2b$10$abcdefghijklmnopqrstuv', '010-1000-0002', 'MANAGEMENT', 'CTO', 'MGT-0002', 'cto', 5, '["view_all", "manage_tech", "admin"]'::JSONB, '{"monday": "09:00-18:00", "tuesday": "09:00-18:00", "wednesday": "09:00-18:00", "thursday": "09:00-18:00", "friday": "09:00-18:00"}'::JSONB, true, 'active'),
('coo@junggo.com', '지혜', '박', '$2b$10$abcdefghijklmnopqrstuv', '010-1000-0003', 'MANAGEMENT', 'COO', 'MGT-0003', 'coo', 5, '["view_all", "manage_operations", "admin"]'::JSONB, '{"monday": "09:00-18:00", "tuesday": "09:00-18:00", "wednesday": "09:00-18:00", "thursday": "09:00-18:00", "friday": "09:00-18:00"}'::JSONB, true, 'active'),
('hr@junggo.com', '수진', '최', '$2b$10$abcdefghijklmnopqrstuv', '010-1000-0004', 'MANAGEMENT', '인사팀장', 'MGT-0004', 'manager', 4, '["view_reports", "manage_hr", "admin"]'::JSONB, '{"monday": "09:00-18:00", "tuesday": "09:00-18:00", "wednesday": "09:00-18:00", "thursday": "09:00-18:00", "friday": "09:00-18:00"}'::JSONB, true, 'active'),
('finance@junggo.com', '동현', '정', '$2b$10$abcdefghijklmnopqrstuv', '010-1000-0005', 'MANAGEMENT', '재무팀장', 'MGT-0005', 'manager', 4, '["view_reports", "manage_finance", "admin"]'::JSONB, '{"monday": "09:00-18:00", "tuesday": "09:00-18:00", "wednesday": "09:00-18:00", "thursday": "09:00-18:00", "friday": "09:00-18:00"}'::JSONB, true, 'active');

-- 3. 팀 리더 배정
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'CS-0001') WHERE name = 'CS 1팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'CS-0002') WHERE name = 'CS 2팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'CS-0003') WHERE name = 'VIP 고객 지원팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'CS-0004') WHERE name = '기술 지원팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'DEV-0001') WHERE name = '백엔드 개발팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'DEV-0002') WHERE name = '프론트엔드 개발팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'DEV-0003') WHERE name = '인프라팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'PM-0001') WHERE name = '프로덕트팀';
UPDATE teams SET team_leader_id = (SELECT id FROM internal_users WHERE employee_id = 'MGT-0004') WHERE name = '경영지원팀';

-- 4. 팀 멤버 할당

-- CS 1팀 (10명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = 'CS 1팀'),
    id,
    CASE WHEN employee_id = 'CS-0001' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE employee_id IN ('CS-0001', 'CS-0006', 'CS-0016', 'CS-0026', 'CS-0036', 'CS-0007', 'CS-0017', 'CS-0027', 'CS-0037', 'CS-0008');

-- CS 2팀 (10명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = 'CS 2팀'),
    id,
    CASE WHEN employee_id = 'CS-0002' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE employee_id IN ('CS-0002', 'CS-0009', 'CS-0018', 'CS-0028', 'CS-0038', 'CS-0010', 'CS-0019', 'CS-0029', 'CS-0039', 'CS-0011');

-- VIP 고객 지원팀 (8명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = 'VIP 고객 지원팀'),
    id,
    CASE WHEN employee_id = 'CS-0003' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE employee_id IN ('CS-0003', 'CS-0012', 'CS-0013', 'CS-0014', 'CS-0015', 'CS-0020', 'CS-0021', 'CS-0022');

-- 기술 지원팀 (12명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = '기술 지원팀'),
    id,
    CASE WHEN employee_id = 'CS-0004' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE employee_id IN ('CS-0004', 'CS-0005', 'CS-0023', 'CS-0024', 'CS-0025', 'CS-0030', 'CS-0031', 'CS-0032', 'CS-0033', 'CS-0034', 'CS-0035', 'CS-0040');

-- 백엔드 개발팀 (10명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = '백엔드 개발팀'),
    id,
    CASE WHEN employee_id = 'DEV-0001' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE employee_id IN ('DEV-0001', 'DEV-0004', 'DEV-0008', 'DEV-0012', 'DEV-0016', 'DEV-0020', 'DEV-0024', 'DEV-0028', 'DEV-0005', 'DEV-0009');

-- 프론트엔드 개발팀 (10명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = '프론트엔드 개발팀'),
    id,
    CASE WHEN employee_id = 'DEV-0002' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE employee_id IN ('DEV-0002', 'DEV-0006', 'DEV-0010', 'DEV-0013', 'DEV-0017', 'DEV-0021', 'DEV-0025', 'DEV-0029', 'DEV-0007', 'DEV-0011');

-- 인프라팀 (7명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = '인프라팀'),
    id,
    CASE WHEN employee_id = 'DEV-0003' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE employee_id IN ('DEV-0003', 'DEV-0014', 'DEV-0018', 'DEV-0022', 'DEV-0026', 'DEV-0030', 'DEV-0015');

-- QA팀 (3명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = 'QA팀'),
    id,
    'member'
FROM internal_users
WHERE employee_id IN ('DEV-0019', 'DEV-0023', 'DEV-0027');

-- 프로덕트팀 (10명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = '프로덕트팀'),
    id,
    CASE WHEN employee_id = 'PM-0001' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE department = 'PRODUCT';

-- 경영지원팀 (5명)
INSERT INTO team_members (team_id, user_id, role_in_team)
SELECT
    (SELECT id FROM teams WHERE name = '경영지원팀'),
    id,
    CASE WHEN employee_id = 'MGT-0004' THEN 'leader' ELSE 'member' END
FROM internal_users
WHERE department = 'MANAGEMENT';

-- 5. 스킬 데이터 추가 (CS 및 개발자)
INSERT INTO user_skills (user_id, skill_name, skill_category, proficiency_level, certified)
SELECT
    iu.id,
    skills.skill_name,
    skills.skill_category,
    3 + (RANDOM() * 2)::INTEGER, -- 3-5
    RANDOM() > 0.7 -- 30% 확률로 자격증 보유
FROM internal_users iu
CROSS JOIN (
    SELECT 'JavaScript' AS skill_name, 'technical' AS skill_category UNION ALL
    SELECT 'TypeScript', 'technical' UNION ALL
    SELECT 'Python', 'technical' UNION ALL
    SELECT 'Java', 'technical' UNION ALL
    SELECT 'SQL', 'technical' UNION ALL
    SELECT 'React', 'technical' UNION ALL
    SELECT 'Node.js', 'technical' UNION ALL
    SELECT '고객 응대', 'communication' UNION ALL
    SELECT '문제 해결', 'communication' UNION ALL
    SELECT '영어', 'language' UNION ALL
    SELECT '중국어', 'language' UNION ALL
    SELECT '일본어', 'language' UNION ALL
    SELECT '제품 지식', 'product' UNION ALL
    SELECT '정책 이해', 'product'
) AS skills
WHERE
    (iu.department = 'DEVELOPMENT' AND skills.skill_category = 'technical') OR
    (iu.department = 'CS' AND skills.skill_category IN ('communication', 'product', 'language'))
LIMIT 500;

-- 6. 성과 기록 추가 (최근 30일)
INSERT INTO performance_records (
    user_id, record_date, tickets_handled, avg_response_time,
    avg_resolution_time, customer_satisfaction, escalation_count, quality_score
)
SELECT
    iu.id,
    CURRENT_DATE - (i || ' days')::INTERVAL,
    FLOOR(RANDOM() * 20 + 5)::INTEGER, -- 5-25 티켓
    FLOOR(RANDOM() * 30 + 10)::INTEGER, -- 10-40분
    FLOOR(RANDOM() * 120 + 60)::INTEGER, -- 60-180분
    3.5 + (RANDOM() * 1.5), -- 3.5-5.0
    FLOOR(RANDOM() * 3)::INTEGER, -- 0-2 에스컬레이션
    3.5 + (RANDOM() * 1.5) -- 3.5-5.0
FROM internal_users iu
CROSS JOIN generate_series(0, 29) AS i
WHERE iu.department = 'CS' AND iu.status = 'active';

-- 7. 휴가 데이터 추가
INSERT INTO user_absences (user_id, absence_type, start_date, end_date, reason, status, approved_by)
SELECT
    iu.id,
    CASE (RANDOM() * 3)::INTEGER
        WHEN 0 THEN 'vacation'
        WHEN 1 THEN 'sick_leave'
        ELSE 'personal'
    END,
    CURRENT_DATE + (FLOOR(RANDOM() * 30)::INTEGER || ' days')::INTERVAL,
    CURRENT_DATE + (FLOOR(RANDOM() * 30 + 3)::INTEGER || ' days')::INTERVAL,
    '개인 사유',
    CASE (RANDOM() * 2)::INTEGER
        WHEN 0 THEN 'approved'
        ELSE 'pending'
    END,
    (SELECT id FROM internal_users WHERE role IN ('team_leader', 'manager') ORDER BY RANDOM() LIMIT 1)
FROM internal_users iu
WHERE RANDOM() > 0.7 -- 30%만 휴가 신청
LIMIT 20;

-- 8. 근무 일정 추가 (다음 7일)
INSERT INTO work_shifts (user_id, shift_date, start_time, end_time, shift_type, status)
SELECT
    iu.id,
    CURRENT_DATE + (i || ' days')::INTERVAL,
    CASE iu.department
        WHEN 'CS' THEN '09:00'::TIME
        WHEN 'DEVELOPMENT' THEN '10:00'::TIME
        ELSE '09:00'::TIME
    END,
    CASE iu.department
        WHEN 'CS' THEN '18:00'::TIME
        WHEN 'DEVELOPMENT' THEN '19:00'::TIME
        ELSE '18:00'::TIME
    END,
    'regular',
    'scheduled'
FROM internal_users iu
CROSS JOIN generate_series(0, 6) AS i
WHERE iu.status = 'active';

-- 9. 총 처리 티켓 수 업데이트
UPDATE internal_users iu
SET total_tickets_handled = (
    SELECT COALESCE(SUM(pr.tickets_handled), 0)
    FROM performance_records pr
    WHERE pr.user_id = iu.id
)
WHERE department = 'CS';

-- 10. 평균 해결 시간 및 만족도 업데이트
UPDATE internal_users iu
SET
    avg_resolution_time = (
        SELECT AVG(pr.avg_resolution_time)::INTEGER
        FROM performance_records pr
        WHERE pr.user_id = iu.id
    ),
    satisfaction_rating = (
        SELECT AVG(pr.customer_satisfaction)
        FROM performance_records pr
        WHERE pr.user_id = iu.id
    )
WHERE department = 'CS';

-- 11. 현재 워크로드 랜덤 설정 (CS 담당자만)
UPDATE internal_users
SET current_workload = FLOOR(RANDOM() * max_concurrent_tickets)::INTEGER
WHERE department = 'CS' AND is_available = true;
