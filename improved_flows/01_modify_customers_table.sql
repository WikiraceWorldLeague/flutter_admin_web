-- customers 테이블 수정: 고객 정보 및 금액 관련 컬럼 추가
-- 실행 순서: 1번째

-- 고객 기본 정보 컬럼 추가
ALTER TABLE customers ADD COLUMN IF NOT EXISTS customer_code VARCHAR(50) UNIQUE; -- 고객ID (기존 규칙 유지: 여권이름-국적-생년월일)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS passport_name VARCHAR(100); -- 여권 이름
ALTER TABLE customers ADD COLUMN IF NOT EXISTS phone VARCHAR(20); -- 연락처
ALTER TABLE customers ADD COLUMN IF NOT EXISTS acquisition_channel VARCHAR(50); -- 유입 경로 (Threads, 지인소개, 재구매, 샤오홍슈 등)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS communication_channel VARCHAR(50); -- 소통 채널 (소셜미디어 채널)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS channel_account VARCHAR(100); -- 채널 계정명
ALTER TABLE customers ADD COLUMN IF NOT EXISTS is_booker BOOLEAN DEFAULT false; -- 예약자 여부
ALTER TABLE customers ADD COLUMN IF NOT EXISTS purchase_code VARCHAR(100); -- 구매고유코드 (고객ID-병원방문일고유값)

-- 금액 관련 컬럼 추가
ALTER TABLE customers ADD COLUMN IF NOT EXISTS total_payment_amount NUMERIC(10,2) DEFAULT 0; -- 총 결제금액 (고객이 병원에 지불한 총액)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS company_revenue_with_tax NUMERIC(10,2) DEFAULT 0; -- 회사 매출 (부가세 포함)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS company_revenue_without_tax NUMERIC(10,2) DEFAULT 0; -- 회사 매출 (부가세 불포함)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS guide_commission NUMERIC(10,2) DEFAULT 0; -- 가이드 정산 금액 (4.5%)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS net_revenue_with_tax NUMERIC(10,2) DEFAULT 0; -- 순매출 (부가세 포함)
ALTER TABLE customers ADD COLUMN IF NOT EXISTS net_revenue_without_tax NUMERIC(10,2) DEFAULT 0; -- 순매출 (부가세 불포함)

-- 복합 유니크 제약조건 추가 (고객 중복 방지)
ALTER TABLE customers ADD CONSTRAINT IF NOT EXISTS unique_customer_info 
UNIQUE (name, birth_date, nationality);

-- 인덱스 생성 (검색 성능 향상)
CREATE INDEX IF NOT EXISTS idx_customers_customer_code ON customers(customer_code);
CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(name);
CREATE INDEX IF NOT EXISTS idx_customers_acquisition_channel ON customers(acquisition_channel); 