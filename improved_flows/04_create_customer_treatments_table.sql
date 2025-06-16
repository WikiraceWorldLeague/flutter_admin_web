-- 고객별 시술 정보 테이블 생성
-- 실행 순서: 4번째

-- 고객별 시술 테이블 (핵심 테이블)
CREATE TABLE IF NOT EXISTS customer_treatments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID REFERENCES customers(id) ON DELETE CASCADE NOT NULL, -- 고객 ID (핵심 외래키)
    procedure_id UUID REFERENCES treatment_procedures(id) ON DELETE RESTRICT, -- 시술 ID
    effect_id UUID REFERENCES treatment_effects(id) ON DELETE RESTRICT, -- 시술 효과 ID
    
    -- 병원에서 기입한 시술 정보
    hospital_procedure_name VARCHAR(500), -- 병원 기입 시술명 (원본 그대로)
    
    -- 시술 세부 정보 (고객마다 다름)
    volume VARCHAR(50), -- 시술 용량 (예: 1cc, 2cc, 0.5cc 등)
    body_part VARCHAR(200), -- 시술 부위 (예: 눈밑, 볼, 이마 등)
    
    -- 금액 정보
    price_with_tax NUMERIC(10,2) NOT NULL DEFAULT 0, -- 부가세 포함 가격
    price_without_tax NUMERIC(10,2) GENERATED ALWAYS AS (price_with_tax / 1.1) STORED, -- 부가세 제외 가격 (자동 계산)
    
    -- 메타 정보
    notes TEXT, -- 특이사항
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 트리거 함수: updated_at 자동 업데이트
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 트리거 생성
CREATE TRIGGER update_customer_treatments_updated_at 
    BEFORE UPDATE ON customer_treatments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 인덱스 생성 (검색 성능 향상)
CREATE INDEX IF NOT EXISTS idx_customer_treatments_customer_id ON customer_treatments(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_procedure_id ON customer_treatments(procedure_id);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_effect_id ON customer_treatments(effect_id);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_body_part ON customer_treatments(body_part);

-- 고객별 시술 개수 제한 (선택사항 - 너무 많은 시술 방지)
-- ALTER TABLE customer_treatments ADD CONSTRAINT max_treatments_per_customer 
-- CHECK ((SELECT COUNT(*) FROM customer_treatments ct WHERE ct.customer_id = customer_id) <= 20); 