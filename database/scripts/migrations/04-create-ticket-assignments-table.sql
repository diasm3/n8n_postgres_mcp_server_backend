-- =====================================================
-- Ticket Assignments Table (티켓 할당 이력)
-- customer_complaints와 internal_users 이후에 생성
-- =====================================================

-- 티켓 할당 이력 테이블
CREATE TABLE IF NOT EXISTS ticket_assignments (
    id SERIAL PRIMARY KEY,
    ticket_id UUID REFERENCES customer_complaints(id) ON DELETE CASCADE,
    assigned_to TEXT REFERENCES internal_users(id) ON DELETE SET NULL,
    assigned_by TEXT REFERENCES internal_users(id) ON DELETE SET NULL,
    assigned_at TIMESTAMP DEFAULT NOW(),
    unassigned_at TIMESTAMP,
    assignment_reason TEXT,
    priority_override INTEGER, -- 우선순위 오버라이드
    metadata JSONB DEFAULT '{}'
);

CREATE INDEX idx_ticket_assignments_ticket ON ticket_assignments(ticket_id);
CREATE INDEX idx_ticket_assignments_user ON ticket_assignments(assigned_to);
CREATE INDEX idx_ticket_assignments_date ON ticket_assignments(assigned_at);

-- 현재 워크로드 자동 업데이트 트리거
CREATE OR REPLACE FUNCTION update_user_workload()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.unassigned_at IS NULL THEN
        UPDATE internal_users SET current_workload = current_workload + 1 WHERE id = NEW.assigned_to;
    ELSIF TG_OP = 'UPDATE' AND OLD.unassigned_at IS NULL AND NEW.unassigned_at IS NOT NULL THEN
        UPDATE internal_users SET current_workload = current_workload - 1 WHERE id = NEW.assigned_to;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_user_workload
AFTER INSERT OR UPDATE ON ticket_assignments
FOR EACH ROW
EXECUTE FUNCTION update_user_workload();

COMMENT ON TABLE ticket_assignments IS '티켓 할당 이력';
