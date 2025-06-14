-- 예약 시스템 스키마 단순화
-- Phase 2.1 오류 해결을 위한 구조 개선

-- 1. reservations 테이블에 customer_id 추가 (단일 고객 관계)
ALTER TABLE reservations 
ADD COLUMN IF NOT EXISTS customer_id UUID REFERENCES customers(id);

-- 2. duration_minutes 컬럼 추가 (만약 없다면)
ALTER TABLE reservations 
ADD COLUMN IF NOT EXISTS duration_minutes INTEGER DEFAULT 180;

-- 3. 기존 상태값 데이터 마이그레이션 (제약조건 변경 전에 수행)
UPDATE reservations 
SET status = 'pending_assignment' 
WHERE status = 'pending';

-- 4. 모든 기존 제약조건 제거
ALTER TABLE reservations 
DROP CONSTRAINT IF EXISTS reservations_status_check;

ALTER TABLE reservations 
DROP CONSTRAINT IF EXISTS reservations_settlement_status_check;

-- 5. 새로운 상태값 제약조건 추가
ALTER TABLE reservations 
ADD CONSTRAINT reservations_status_check 
CHECK (status IN ('pending_assignment', 'assigned', 'in_progress', 'completed', 'cancelled'));

-- settlement_status 제약조건은 기존 그대로 유지
ALTER TABLE reservations 
ADD CONSTRAINT reservations_settlement_status_check 
CHECK (settlement_status IN ('pending', 'processed', 'paid'));

-- 6. 기존 데이터 마이그레이션 (reservation_customers 테이블의 첫 번째 고객을 메인 고객으로 설정)
UPDATE reservations 
SET customer_id = (
  SELECT rc.customer_id 
  FROM reservation_customers rc 
  WHERE rc.reservation_id = reservations.id 
  LIMIT 1
)
WHERE customer_id IS NULL;

-- 7. 가이드 관리를 위한 컬럼 추가
ALTER TABLE guides 
ADD COLUMN IF NOT EXISTS nickname TEXT,
ADD COLUMN IF NOT EXISTS profile_image_url TEXT,
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- 8. 가이드 휴무 관리 테이블 생성
CREATE TABLE IF NOT EXISTS guide_unavailability (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  guide_id UUID REFERENCES guides(id) ON DELETE CASCADE,
  unavailable_date DATE NOT NULL,
  reason TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(guide_id, unavailable_date)
);

-- 9. 인덱스 생성 (성능 향상)
CREATE INDEX IF NOT EXISTS idx_reservations_customer_id ON reservations(customer_id);
CREATE INDEX IF NOT EXISTS idx_reservations_status ON reservations(status);
CREATE INDEX IF NOT EXISTS idx_reservations_date ON reservations(reservation_date);
CREATE INDEX IF NOT EXISTS idx_guide_unavailability_guide_date ON guide_unavailability(guide_id, unavailable_date);

-- 10. 데이터 확인 쿼리 (실행 후 확인용)
-- SELECT status, COUNT(*) FROM reservations GROUP BY status;
-- SELECT settlement_status, COUNT(*) FROM reservations GROUP BY settlement_status; 