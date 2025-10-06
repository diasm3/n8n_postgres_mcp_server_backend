-- =====================================================
-- Customer Complaints Dummy Data (고객 컴플레인 샘플)
-- =====================================================

-- 1. 응답 템플릿 생성
INSERT INTO complaint_templates (category, sub_category, template_name, template_content, variables, is_active, usage_count) VALUES
-- 가격정보 템플릿
('가격정보', '가격 오류', '가격 오류 확인 및 조치', '안녕하세요, 중고나라 고객센터입니다.

문의하신 상품의 가격 오류 건에 대해 확인하였습니다.
현재 {{product_name}} 상품의 가격이 잘못 표시되어 있어 즉시 수정 조치하였습니다.

정확한 가격: {{correct_price}}원
불편을 끼쳐드려 죄송합니다.

감사합니다.', '["product_name", "correct_price"]'::JSONB, true, 45),

('가격정보', '배송비 문의', '배송비 안내', '안녕하세요, 중고나라 고객센터입니다.

배송비 관련 문의에 답변드립니다.
- 기본 배송비: {{base_shipping_fee}}원
- 지역별 추가 배송비: {{additional_fee}}원
- 무료배송 조건: {{free_shipping_condition}}

추가 문의사항이 있으시면 언제든지 연락 주시기 바랍니다.', '["base_shipping_fee", "additional_fee", "free_shipping_condition"]'::JSONB, true, 67),

-- 상품정보 템플릿
('상품정보', '상품 설명 불일치', '상품 정보 불일치 확인', '안녕하세요, 중고나라 고객센터입니다.

고객님께서 문의하신 상품 설명 불일치 건에 대해 확인하였습니다.
판매자에게 정확한 상품 정보를 요청하였으며, 24시간 내에 업데이트 예정입니다.

불편을 끼쳐드려 죄송하며, 빠른 시일 내에 해결하겠습니다.', '[]'::JSONB, true, 89),

('상품정보', '재고 문의', '재고 확인 안내', '안녕하세요, 중고나라 고객센터입니다.

문의하신 {{product_name}} 상품의 재고 현황입니다.
- 현재 재고: {{stock_quantity}}개
- 재입고 예정일: {{restock_date}}

주문을 원하시면 빠른 시일 내에 진행 부탁드립니다.', '["product_name", "stock_quantity", "restock_date"]'::JSONB, true, 123),

-- 배송구매 템플릿
('배송구매', '배송 지연', '배송 지연 안내 및 사과', '안녕하세요, 중고나라 고객센터입니다.

주문하신 상품의 배송이 지연되어 진심으로 사과드립니다.
- 주문번호: {{order_id}}
- 예상 도착일: {{expected_delivery_date}}
- 지연 사유: {{delay_reason}}

배송 완료 시 {{compensation_points}}P를 적립해드리겠습니다.
불편을 끼쳐드려 대단히 죄송합니다.', '["order_id", "expected_delivery_date", "delay_reason", "compensation_points"]'::JSONB, true, 234),

('배송구매', '주문 취소', '주문 취소 처리 안내', '안녕하세요, 중고나라 고객센터입니다.

주문 취소 요청을 정상적으로 처리하였습니다.
- 주문번호: {{order_id}}
- 환불 금액: {{refund_amount}}원
- 환불 예정일: {{refund_date}}

영업일 기준 3-5일 내에 환불 처리됩니다.', '["order_id", "refund_amount", "refund_date"]'::JSONB, true, 156),

-- 리뷰평점 템플릿
('리뷰평점', '악의적 리뷰', '부적절한 리뷰 검토', '안녕하세요, 중고나라 고객센터입니다.

신고하신 리뷰에 대해 검토하였습니다.
해당 리뷰가 커뮤니티 가이드라인에 위배되는 것을 확인하였으며,
삭제 조치하였습니다.

건전한 리뷰 문화 조성에 협조해주셔서 감사합니다.', '[]'::JSONB, true, 78),

-- 회원개인정보 템플릿
('회원개인정보', '비밀번호 재설정', '비밀번호 재설정 안내', '안녕하세요, 중고나라 고객센터입니다.

비밀번호 재설정 링크를 이메일로 발송하였습니다.
이메일: {{user_email}}

링크는 24시간 동안 유효하며, 보안을 위해 즉시 변경하시기 바랍니다.', '["user_email"]'::JSONB, true, 201),

('회원개인정보', '개인정보 수정', '개인정보 수정 완료', '안녕하세요, 중고나라 고객센터입니다.

요청하신 개인정보 수정이 완료되었습니다.
수정 내용: {{modified_fields}}

추가로 수정이 필요하시면 언제든지 문의해주세요.', '["modified_fields"]'::JSONB, true, 134),

-- 시스템기술 템플릿
('시스템기술', '결제 오류', '결제 오류 해결', '안녕하세요, 중고나라 고객센터입니다.

결제 오류 관련 문의에 대해 안내드립니다.
기술팀에서 확인한 결과, 일시적인 시스템 오류로 확인되었습니다.

현재는 정상 작동 중이며, 재시도 부탁드립니다.
불편을 끼쳐드려 죄송합니다.', '[]'::JSONB, true, 167),

('시스템기술', '로그인 불가', '로그인 문제 해결', '안녕하세요, 중고나라 고객센터입니다.

로그인 불가 문제에 대해 확인하였습니다.
다음 방법을 시도해주세요:
1. 캐시 및 쿠키 삭제
2. 브라우저 업데이트
3. 비밀번호 재설정

문제가 지속되면 기술팀에 에스컬레이션하겠습니다.', '[]'::JSONB, true, 145);

-- 2. 지식베이스 데이터
INSERT INTO complaint_knowledge_base (category, sub_category, question, answer, keywords, view_count, helpful_count, not_helpful_count, is_published) VALUES
('가격정보', '가격 오류', '상품 가격이 잘못 표시되었을 때 어떻게 하나요?',
'상품 가격 오류 발견 시 즉시 고객센터로 신고해주세요. 확인 후 24시간 내에 수정하며, 이미 구매하신 경우 차액을 환불해드립니다.',
'["가격", "오류", "수정", "환불"]'::JSONB, 1234, 987, 45, true),

('배송구매', '배송 지연', '배송이 지연되고 있어요',
'배송 지연 시 주문번호를 확인하여 고객센터로 문의해주세요. 배송업체 확인 후 예상 도착일을 안내드리며, 보상 포인트를 지급해드립니다.',
'["배송", "지연", "주문번호", "포인트"]'::JSONB, 2341, 1876, 123, true),

('회원개인정보', '계정 탈퇴', '회원 탈퇴는 어떻게 하나요?',
'마이페이지 > 설정 > 회원탈퇴에서 진행할 수 있습니다. 탈퇴 후 30일간 계정 복구가 가능하며, 이후 모든 데이터가 삭제됩니다.',
'["회원탈퇴", "계정", "삭제", "복구"]'::JSONB, 3456, 2987, 234, true),

('시스템기술', '앱 오류', '앱이 자꾸 종료돼요',
'앱 강제 종료 시 다음을 시도해보세요: 1) 앱 재시작 2) 캐시 삭제 3) 앱 업데이트 4) 기기 재부팅. 문제 지속 시 기기 정보와 함께 문의해주세요.',
'["앱", "종료", "오류", "업데이트"]'::JSONB, 4567, 3456, 345, true),

('상품정보', '품절', '품절된 상품 언제 재입고 되나요?',
'품절 상품의 재입고 알림을 설정하시면 입고 시 즉시 알려드립니다. 일부 상품은 재입고가 불가할 수 있으니 판매자에게 직접 문의하시는 것을 권장합니다.',
'["품절", "재입고", "알림", "입고"]'::JSONB, 5678, 4321, 456, true);

-- 3. 고객 컴플레인 데이터 (50건)
-- 가격정보 관련 (10건)
INSERT INTO customer_complaints (
    user_id, customer_name, customer_email, customer_phone,
    category, sub_category, priority, urgency,
    subject, description, attachments,
    status, assigned_to, assigned_team,
    first_response_at, resolved_at, response_time, resolution_time,
    related_product_id, compensation_type, compensation_amount,
    satisfaction_score, feedback_comment, tags
)
SELECT
    (SELECT id FROM users ORDER BY RANDOM() LIMIT 1),
    CASE (i % 10)
        WHEN 0 THEN '김민수' WHEN 1 THEN '이영희' WHEN 2 THEN '박철수' WHEN 3 THEN '정수진'
        WHEN 4 THEN '최지훈' WHEN 5 THEN '강민정' WHEN 6 THEN '조현우' WHEN 7 THEN '윤서연'
        WHEN 8 THEN '임동혁' WHEN 9 THEN '한예린'
    END,
    'customer' || i || '@example.com',
    '010-' || LPAD((1000 + i)::TEXT, 4, '0') || '-' || LPAD((i * 7 % 10000)::TEXT, 4, '0'),
    '가격정보',
    CASE (i % 3)
        WHEN 0 THEN '가격 오류'
        WHEN 1 THEN '배송비 문의'
        WHEN 2 THEN '할인율 오류'
    END,
    CASE
        WHEN i <= 2 THEN 'high'
        WHEN i <= 7 THEN 'medium'
        ELSE 'low'
    END,
    CASE
        WHEN i <= 3 THEN 'urgent'
        ELSE 'normal'
    END,
    CASE (i % 3)
        WHEN 0 THEN '상품 가격이 실제와 다릅니다'
        WHEN 1 THEN '배송비가 갑자기 올랐어요'
        WHEN 2 THEN '할인 적용이 안됩니다'
    END,
    CASE (i % 3)
        WHEN 0 THEN '상품 페이지에는 29,900원이라고 되어있는데 장바구니에 담으니 35,000원으로 표시됩니다. 확인 부탁드립니다.'
        WHEN 1 THEN '어제까지 무료배송이었는데 오늘 보니 3,000원으로 변경되었습니다. 왜 그런가요?'
        WHEN 2 THEN '20% 할인 쿠폰을 적용했는데 할인이 제대로 적용되지 않습니다.'
    END,
    CASE WHEN RANDOM() > 0.7 THEN '["screenshot1.png", "screenshot2.png"]'::JSONB ELSE '[]'::JSONB END,
    CASE
        WHEN i <= 3 THEN '해결완료'
        WHEN i <= 6 THEN '처리중'
        ELSE '접수'
    END,
    CASE WHEN i <= 6 THEN (SELECT id FROM internal_users WHERE department = 'CS' ORDER BY RANDOM() LIMIT 1) ELSE NULL END,
    CASE WHEN i <= 6 THEN 'CS 1팀' ELSE NULL END,
    CASE WHEN i <= 6 THEN NOW() - (RANDOM() * INTERVAL '3 hours') ELSE NULL END,
    CASE WHEN i <= 3 THEN NOW() - (RANDOM() * INTERVAL '1 hour') ELSE NULL END,
    CASE WHEN i <= 6 THEN FLOOR(RANDOM() * 120 + 30)::INTEGER ELSE NULL END,
    CASE WHEN i <= 3 THEN FLOOR(RANDOM() * 240 + 60)::INTEGER ELSE NULL END,
    'PROD-' || LPAD((1000 + i)::TEXT, 6, '0'),
    CASE WHEN i <= 3 THEN CASE (i % 2) WHEN 0 THEN '포인트지급' ELSE '없음' END ELSE NULL END,
    CASE WHEN i <= 3 AND (i % 2) = 0 THEN 5000 ELSE 0 END,
    CASE WHEN i <= 3 THEN FLOOR(RANDOM() * 2 + 4)::INTEGER ELSE NULL END,
    CASE WHEN i <= 3 THEN '빠른 처리 감사합니다!' ELSE NULL END,
    CASE (i % 2) WHEN 0 THEN '["urgent", "price"]'::JSONB ELSE '["price", "inquiry"]'::JSONB END
FROM generate_series(1, 10) AS i;

-- 상품정보 관련 (10건)
INSERT INTO customer_complaints (
    user_id, customer_name, customer_email, customer_phone,
    category, sub_category, priority, urgency,
    subject, description,
    status, assigned_to, assigned_team,
    first_response_at, resolved_at, response_time, resolution_time,
    related_product_id, related_seller_id,
    satisfaction_score, tags
)
SELECT
    (SELECT id FROM users ORDER BY RANDOM() LIMIT 1),
    CASE (i % 8)
        WHEN 0 THEN '배수진' WHEN 1 THEN '송민호' WHEN 2 THEN '황지영' WHEN 3 THEN '오세훈'
        WHEN 4 THEN '권나영' WHEN 5 THEN '신동엽' WHEN 6 THEN '문채원' WHEN 7 THEN '하정우'
    END,
    'product' || i || '@example.com',
    '010-' || LPAD((2000 + i)::TEXT, 4, '0') || '-' || LPAD((i * 11 % 10000)::TEXT, 4, '0'),
    '상품정보',
    CASE (i % 4)
        WHEN 0 THEN '상품 설명 불일치'
        WHEN 1 THEN '재고 문의'
        WHEN 2 THEN '품질 문제'
        WHEN 3 THEN '사이즈 오류'
    END,
    CASE
        WHEN i <= 3 THEN 'high'
        ELSE 'medium'
    END,
    'normal',
    CASE (i % 4)
        WHEN 0 THEN '상품 설명과 실제가 다릅니다'
        WHEN 1 THEN '재고가 있다고 했는데 품절이래요'
        WHEN 2 THEN '상품 품질이 너무 안좋아요'
        WHEN 3 THEN '사이즈 표기가 잘못되었습니다'
    END,
    '상품을 받아보니 설명과 전혀 다른 제품이 왔습니다. 환불 또는 교환 부탁드립니다.',
    CASE
        WHEN i <= 4 THEN '해결완료'
        WHEN i <= 7 THEN '처리중'
        ELSE '접수'
    END,
    CASE WHEN i <= 7 THEN (SELECT id FROM internal_users WHERE department = 'CS' ORDER BY RANDOM() LIMIT 1) ELSE NULL END,
    CASE WHEN i <= 7 THEN 'CS 2팀' ELSE NULL END,
    CASE WHEN i <= 7 THEN NOW() - (RANDOM() * INTERVAL '4 hours') ELSE NULL END,
    CASE WHEN i <= 4 THEN NOW() - (RANDOM() * INTERVAL '2 hours') ELSE NULL END,
    CASE WHEN i <= 7 THEN FLOOR(RANDOM() * 90 + 20)::INTEGER ELSE NULL END,
    CASE WHEN i <= 4 THEN FLOOR(RANDOM() * 180 + 90)::INTEGER ELSE NULL END,
    'PROD-' || LPAD((2000 + i)::TEXT, 6, '0'),
    'SELLER-' || LPAD((100 + i)::TEXT, 4, '0'),
    CASE WHEN i <= 4 THEN FLOOR(RANDOM() * 3 + 3)::INTEGER ELSE NULL END,
    '["product", "quality"]'::JSONB
FROM generate_series(1, 10) AS i;

-- 배송구매 관련 (15건) - 가장 많은 문의
INSERT INTO customer_complaints (
    user_id, customer_name, customer_email, customer_phone,
    category, sub_category, priority, urgency,
    subject, description,
    status, escalation_level, is_escalated,
    assigned_to, assigned_team,
    first_response_at, resolved_at, response_time, resolution_time,
    related_order_id, compensation_type, compensation_amount,
    satisfaction_score, feedback_comment, tags, jira_ticket_key
)
SELECT
    (SELECT id FROM users ORDER BY RANDOM() LIMIT 1),
    CASE (i % 12)
        WHEN 0 THEN '안재현' WHEN 1 THEN '구혜선' WHEN 2 THEN '이동욱' WHEN 3 THEN '유인나'
        WHEN 4 THEN '박보검' WHEN 5 THEN '아이유' WHEN 6 THEN '송중기' WHEN 7 THEN '송혜교'
        WHEN 8 THEN '현빈' WHEN 9 THEN '손예진' WHEN 10 THEN '강동원' WHEN 11 THEN '전지현'
    END,
    'delivery' || i || '@example.com',
    '010-' || LPAD((3000 + i)::TEXT, 4, '0') || '-' || LPAD((i * 13 % 10000)::TEXT, 4, '0'),
    '배송구매',
    CASE (i % 5)
        WHEN 0 THEN '배송 지연'
        WHEN 1 THEN '주문 취소'
        WHEN 2 THEN '배송 오류'
        WHEN 3 THEN '분실'
        WHEN 4 THEN '파손'
    END,
    CASE
        WHEN i <= 5 THEN 'high'
        WHEN i <= 12 THEN 'medium'
        ELSE 'low'
    END,
    CASE
        WHEN i <= 5 THEN 'urgent'
        ELSE 'normal'
    END,
    CASE (i % 5)
        WHEN 0 THEN '배송이 일주일째 안옵니다'
        WHEN 1 THEN '주문 취소 요청합니다'
        WHEN 2 THEN '다른 주소로 배송되었어요'
        WHEN 3 THEN '택배가 분실되었습니다'
        WHEN 4 THEN '상품이 파손되어 도착했습니다'
    END,
    '주문한지 일주일이 지났는데 아직도 배송 중이라고만 나옵니다. 언제 받을 수 있나요?',
    CASE
        WHEN i <= 6 THEN '해결완료'
        WHEN i <= 10 THEN '처리중'
        WHEN i <= 13 THEN '보류'
        ELSE '접수'
    END,
    CASE WHEN i <= 3 THEN 2 ELSE 1 END,
    CASE WHEN i <= 3 THEN true ELSE false END,
    CASE WHEN i <= 10 THEN (SELECT id FROM internal_users WHERE department = 'CS' ORDER BY RANDOM() LIMIT 1) ELSE NULL END,
    CASE
        WHEN i <= 5 THEN 'VIP 고객 지원팀'
        WHEN i <= 10 THEN 'CS 1팀'
        ELSE NULL
    END,
    CASE WHEN i <= 10 THEN NOW() - (RANDOM() * INTERVAL '2 hours') ELSE NULL END,
    CASE WHEN i <= 6 THEN NOW() - (RANDOM() * INTERVAL '30 minutes') ELSE NULL END,
    CASE WHEN i <= 10 THEN FLOOR(RANDOM() * 60 + 15)::INTEGER ELSE NULL END,
    CASE WHEN i <= 6 THEN FLOOR(RANDOM() * 120 + 30)::INTEGER ELSE NULL END,
    'ORD-2025-' || LPAD(i::TEXT, 6, '0'),
    CASE
        WHEN i <= 6 THEN CASE (i % 3) WHEN 0 THEN '포인트지급' WHEN 1 THEN '환불' ELSE '쿠폰' END
        ELSE NULL
    END,
    CASE
        WHEN i <= 6 THEN CASE (i % 3) WHEN 0 THEN 10000 WHEN 1 THEN 0 ELSE 5000 END
        ELSE 0
    END,
    CASE WHEN i <= 6 THEN FLOOR(RANDOM() * 2 + 3)::INTEGER ELSE NULL END,
    CASE
        WHEN i <= 6 THEN CASE (i % 3)
            WHEN 0 THEN '보상 감사합니다'
            WHEN 1 THEN '환불 처리가 늦었어요'
            ELSE '친절하게 응대해주셔서 좋았습니다'
        END
        ELSE NULL
    END,
    '["delivery", "urgent"]'::JSONB,
    CASE WHEN i <= 3 THEN 'JIRA-CS-' || LPAD((100 + i)::TEXT, 4, '0') ELSE NULL END
FROM generate_series(1, 15) AS i;

-- 리뷰평점 관련 (5건)
INSERT INTO customer_complaints (
    user_id, customer_name, customer_email, customer_phone,
    category, sub_category, priority, urgency,
    subject, description,
    status, assigned_to, assigned_team,
    first_response_at, related_product_id,
    tags
)
SELECT
    (SELECT id FROM users ORDER BY RANDOM() LIMIT 1),
    CASE (i % 5)
        WHEN 0 THEN '정유미' WHEN 1 THEN '공유' WHEN 2 THEN '김고은'
        WHEN 3 THEN '이민호' WHEN 4 THEN '수지'
    END,
    'review' || i || '@example.com',
    '010-' || LPAD((4000 + i)::TEXT, 4, '0') || '-5678',
    '리뷰평점',
    CASE (i % 3)
        WHEN 0 THEN '악의적 리뷰'
        WHEN 1 THEN '리뷰 삭제 요청'
        WHEN 2 THEN '평점 오류'
    END,
    CASE WHEN i <= 2 THEN 'medium' ELSE 'low' END,
    'normal',
    CASE (i % 3)
        WHEN 0 THEN '악의적인 리뷰 신고합니다'
        WHEN 1 THEN '작성한 리뷰 삭제 부탁드립니다'
        WHEN 2 THEN '평점이 제대로 반영 안돼요'
    END,
    '경쟁 판매자가 악의적으로 낮은 평점을 주고 있습니다. 확인 부탁드립니다.',
    CASE WHEN i <= 3 THEN '처리중' ELSE '접수' END,
    CASE WHEN i <= 3 THEN (SELECT id FROM internal_users WHERE department = 'CS' ORDER BY RANDOM() LIMIT 1) ELSE NULL END,
    CASE WHEN i <= 3 THEN 'CS 2팀' ELSE NULL END,
    CASE WHEN i <= 3 THEN NOW() - (RANDOM() * INTERVAL '1 hour') ELSE NULL END,
    'PROD-' || LPAD((4000 + i)::TEXT, 6, '0'),
    '["review", "report"]'::JSONB
FROM generate_series(1, 5) AS i;

-- 회원개인정보 관련 (5건)
INSERT INTO customer_complaints (
    user_id, customer_name, customer_email, customer_phone,
    category, sub_category, priority, urgency,
    subject, description,
    status, assigned_to, assigned_team,
    first_response_at, resolved_at, response_time, resolution_time,
    satisfaction_score, tags
)
SELECT
    (SELECT id FROM users ORDER BY RANDOM() LIMIT 1),
    CASE (i % 5)
        WHEN 0 THEN '이정재' WHEN 1 THEN '정호연' WHEN 2 THEN '박해수'
        WHEN 3 THEN '위하준' WHEN 4 THEN '김주령'
    END,
    'privacy' || i || '@example.com',
    '010-' || LPAD((5000 + i)::TEXT, 4, '0') || '-9876',
    '회원개인정보',
    CASE (i % 4)
        WHEN 0 THEN '비밀번호 재설정'
        WHEN 1 THEN '개인정보 수정'
        WHEN 2 THEN '계정 탈퇴'
        WHEN 3 THEN '정보 유출'
    END,
    CASE WHEN i = 4 THEN 'high' ELSE 'medium' END,
    CASE WHEN i = 4 THEN 'urgent' ELSE 'normal' END,
    CASE (i % 4)
        WHEN 0 THEN '비밀번호를 잊어버렸어요'
        WHEN 1 THEN '전화번호 변경 부탁드립니다'
        WHEN 2 THEN '회원 탈퇴하고 싶습니다'
        WHEN 3 THEN '개인정보가 유출된 것 같아요'
    END,
    '비밀번호를 잊어버려서 로그인을 할 수가 없습니다. 재설정 부탁드립니다.',
    CASE WHEN i <= 3 THEN '해결완료' ELSE '처리중' END,
    (SELECT id FROM internal_users WHERE department = 'CS' ORDER BY RANDOM() LIMIT 1),
    'CS 1팀',
    NOW() - (RANDOM() * INTERVAL '30 minutes'),
    CASE WHEN i <= 3 THEN NOW() - (RANDOM() * INTERVAL '10 minutes') ELSE NULL END,
    FLOOR(RANDOM() * 20 + 10)::INTEGER,
    CASE WHEN i <= 3 THEN FLOOR(RANDOM() * 30 + 20)::INTEGER ELSE NULL END,
    CASE WHEN i <= 3 THEN FLOOR(RANDOM() * 2 + 4)::INTEGER ELSE NULL END,
    '["privacy", "account"]'::JSONB
FROM generate_series(1, 5) AS i;

-- 시스템기술 관련 (5건)
INSERT INTO customer_complaints (
    user_id, customer_name, customer_email, customer_phone,
    category, sub_category, priority, urgency,
    subject, description,
    status, escalation_level, is_escalated,
    assigned_to, assigned_team,
    first_response_at, jira_ticket_key, tags
)
SELECT
    (SELECT id FROM users ORDER BY RANDOM() LIMIT 1),
    CASE (i % 5)
        WHEN 0 THEN '마동석' WHEN 1 THEN '윤계상' WHEN 2 THEN '한소희'
        WHEN 3 THEN '안보현' WHEN 4 THEN '김다미'
    END,
    'tech' || i || '@example.com',
    '010-' || LPAD((6000 + i)::TEXT, 4, '0') || '-1234',
    '시스템기술',
    CASE (i % 4)
        WHEN 0 THEN '결제 오류'
        WHEN 1 THEN '로그인 불가'
        WHEN 2 THEN '앱 오류'
        WHEN 3 THEN '서버 오류'
    END,
    'high',
    'urgent',
    CASE (i % 4)
        WHEN 0 THEN '결제가 계속 실패합니다'
        WHEN 1 THEN '로그인이 안됩니다'
        WHEN 2 THEN '앱이 계속 꺼져요'
        WHEN 3 THEN '서버 오류 메시지가 뜹니다'
    END,
    '결제를 하려고 하는데 계속 오류가 발생합니다. 카드는 정상인데 시스템 문제인 것 같습니다.',
    CASE WHEN i <= 2 THEN '해결완료' ELSE '처리중' END,
    CASE WHEN i >= 3 THEN 2 ELSE 1 END,
    CASE WHEN i >= 3 THEN true ELSE false END,
    (SELECT id FROM internal_users WHERE department = 'CS' ORDER BY RANDOM() LIMIT 1),
    '기술 지원팀',
    NOW() - (RANDOM() * INTERVAL '1 hour'),
    CASE WHEN i >= 3 THEN 'JIRA-TECH-' || LPAD((200 + i)::TEXT, 4, '0') ELSE NULL END,
    '["tech", "urgent", "bug"]'::JSONB
FROM generate_series(1, 5) AS i;

-- 4. 컴플레인 응답 데이터 (처리중 및 완료된 건들에 대해)
INSERT INTO complaint_responses (complaint_id, responder_id, responder_type, response_type, content, is_internal, is_auto_response)
SELECT
    c.id,
    c.assigned_to,
    'agent',
    'reply',
    CASE (RANDOM() * 5)::INTEGER
        WHEN 0 THEN '고객님 안녕하세요. 문의 주신 내용 확인하였습니다. 빠른 시일 내에 처리하겠습니다.'
        WHEN 1 THEN '불편을 끼쳐드려 죄송합니다. 담당 부서에 확인 중이며, 오늘 중으로 답변드리겠습니다.'
        WHEN 2 THEN '문의하신 건에 대해 확인 완료하였습니다. 추가로 필요하신 사항이 있으시면 말씀해주세요.'
        WHEN 3 THEN '고객님의 불편사항을 해결하기 위해 최선을 다하겠습니다. 조금만 기다려주세요.'
        ELSE '처리 완료하였습니다. 이용에 불편을 드려 죄송합니다.'
    END,
    false,
    false
FROM customer_complaints c
WHERE c.status IN ('처리중', '해결완료') AND c.assigned_to IS NOT NULL;

-- 일부 컴플레인에 고객 재문의 추가
INSERT INTO complaint_responses (complaint_id, responder_id, responder_type, response_type, content, is_internal)
SELECT
    c.id,
    c.user_id,
    'customer',
    'reply',
    '아직도 해결이 안됐는데 언제쯤 처리되나요?',
    false
FROM customer_complaints c
WHERE c.status = '처리중' AND RANDOM() > 0.6
LIMIT 5;

-- 5. 컴플레인 처리 이력 데이터
INSERT INTO complaint_history (complaint_id, actor_id, action, from_value, to_value, note)
SELECT
    c.id,
    c.assigned_to,
    'status_change',
    '접수',
    c.status,
    '담당자 배정 및 처리 시작'
FROM customer_complaints c
WHERE c.status != '접수' AND c.assigned_to IS NOT NULL;

INSERT INTO complaint_history (complaint_id, actor_id, action, from_value, to_value, note)
SELECT
    c.id,
    c.assigned_to,
    'assigned',
    NULL,
    c.assigned_to,
    '담당자 배정: ' || c.assigned_team
FROM customer_complaints c
WHERE c.assigned_to IS NOT NULL;

INSERT INTO complaint_history (complaint_id, actor_id, action, from_value, to_value, note)
SELECT
    c.id,
    c.assigned_to,
    'escalation',
    '1',
    c.escalation_level::TEXT,
    'Level ' || c.escalation_level || ' 에스컬레이션'
FROM customer_complaints c
WHERE c.is_escalated = true;

-- =====================================================
-- 완료 메시지
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '======================================';
    RAISE NOTICE 'Customer Complaints 시드 데이터 생성 완료!';
    RAISE NOTICE '======================================';
    RAISE NOTICE '생성된 데이터:';
    RAISE NOTICE '  - 응답 템플릿: 11개';
    RAISE NOTICE '  - 지식베이스: 5개';
    RAISE NOTICE '  - 컴플레인: 50건';
    RAISE NOTICE '    * 가격정보: 10건';
    RAISE NOTICE '    * 상품정보: 10건';
    RAISE NOTICE '    * 배송구매: 15건';
    RAISE NOTICE '    * 리뷰평점: 5건';
    RAISE NOTICE '    * 회원개인정보: 5건';
    RAISE NOTICE '    * 시스템기술: 5건';
    RAISE NOTICE '  - 응답 내역: 다수';
    RAISE NOTICE '  - 처리 이력: 다수';
    RAISE NOTICE '======================================';
END $$;
