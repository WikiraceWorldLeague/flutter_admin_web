-- 현재 데이터베이스 상태 확인용 쿼리들

-- 1. 현재 제약조건 확인
SELECT conname, consrc 
FROM pg_constraint 
WHERE conrelid = 'reservations'::regclass 
AND contype = 'c';

-- 2. 현재 status 값들 확인
SELECT status, COUNT(*) 
FROM reservations 
GROUP BY status;

-- 3. 현재 settlement_status 값들 확인
SELECT settlement_status, COUNT(*) 
FROM reservations 
GROUP BY settlement_status;

-- 4. 테이블 구조 확인 (컬럼 정보)
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'reservations' 
ORDER BY ordinal_position;

-- 5. 문제가 되는 레코드 확인
SELECT id, status, settlement_status, created_at
FROM reservations 
WHERE status NOT IN ('pending_assignment', 'assigned', 'in_progress', 'completed', 'cancelled')
   OR settlement_status NOT IN ('pending', 'processed', 'paid')
ORDER BY created_at DESC
LIMIT 5; 