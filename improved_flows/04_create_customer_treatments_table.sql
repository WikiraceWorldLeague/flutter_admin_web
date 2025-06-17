-- 고객별 시술 정보 테이블 생성 + 패키지 분해 시스템 연동
-- 실행 순서: 4번째

-- ========================================
-- 1. 고객별 시술 테이블 생성
-- ========================================

-- 고객별 시술 테이블 (핵심 테이블)
CREATE TABLE IF NOT EXISTS customer_treatments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID REFERENCES customers(id) ON DELETE CASCADE NOT NULL, -- 고객 ID (핵심 외래키)
    procedure_id UUID REFERENCES treatment_procedures(id) ON DELETE RESTRICT, -- 시술 ID (선택사항)
    effect_id UUID REFERENCES treatment_effects(id) ON DELETE RESTRICT, -- 시술 효과 ID (선택사항)
    
    -- 🆕 병원에서 기입한 시술 정보 (패키지 지원)
    hospital_procedure_name VARCHAR(500) NOT NULL, -- 병원 기입 시술명 (원본 그대로 - 패키지명 포함)
    is_package BOOLEAN DEFAULT false, -- 패키지 여부 (자동 감지)
    
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

-- ========================================
-- 🆕 2. 패키지 분해 시스템 연동
-- ========================================

-- treatment_analytics 테이블에 외래키 제약조건 추가
ALTER TABLE treatment_analytics 
ADD CONSTRAINT fk_treatment_analytics_customer_treatment 
FOREIGN KEY (customer_treatment_id) REFERENCES customer_treatments(id) ON DELETE CASCADE;

-- 패키지 여부 자동 업데이트 트리거
CREATE OR REPLACE FUNCTION update_package_status()
RETURNS TRIGGER AS $$
BEGIN
    -- 패키지 여부 자동 감지
    NEW.is_package = EXISTS (
        SELECT 1 FROM treatment_packages 
        WHERE package_name = NEW.hospital_procedure_name
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 3. 트리거 시스템 적용
-- ========================================

-- 트리거 1: 패키지 여부 자동 업데이트
CREATE TRIGGER trigger_update_package_status
    BEFORE INSERT OR UPDATE ON customer_treatments
    FOR EACH ROW EXECUTE FUNCTION update_package_status();

-- 트리거 2: 시술 자동 분해 (03번에서 정의한 함수 사용)
CREATE TRIGGER trigger_auto_decompose_treatment
    AFTER INSERT OR UPDATE ON customer_treatments
    FOR EACH ROW EXECUTE FUNCTION auto_decompose_treatment();

-- 트리거 3: updated_at 자동 업데이트
CREATE TRIGGER update_customer_treatments_updated_at 
    BEFORE UPDATE ON customer_treatments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 트리거 4: 분석 데이터 삭제 (고객 시술 삭제 시)
CREATE OR REPLACE FUNCTION cleanup_treatment_analytics()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM treatment_analytics WHERE customer_treatment_id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cleanup_treatment_analytics
    AFTER DELETE ON customer_treatments
    FOR EACH ROW EXECUTE FUNCTION cleanup_treatment_analytics();

-- ========================================
-- 4. 인덱스 생성 (검색 성능 향상)
-- ========================================

CREATE INDEX IF NOT EXISTS idx_customer_treatments_customer_id ON customer_treatments(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_procedure_id ON customer_treatments(procedure_id);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_effect_id ON customer_treatments(effect_id);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_hospital_procedure_name ON customer_treatments(hospital_procedure_name);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_is_package ON customer_treatments(is_package);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_body_part ON customer_treatments(body_part);
CREATE INDEX IF NOT EXISTS idx_customer_treatments_price ON customer_treatments(price_with_tax);

-- ========================================
-- 🆕 5. 패키지 분석을 위한 뷰 함수
-- ========================================

-- 고객별 시술 상세 분석 뷰
CREATE OR REPLACE VIEW customer_treatment_details AS
SELECT 
    ct.id,
    ct.customer_id,
    c.name as customer_name,
    ct.hospital_procedure_name,
    ct.is_package,
    ct.price_with_tax,
    ct.price_without_tax,
    
    -- 분석 데이터 조인
    ta.component_treatment_name,
    ta.weight_percentage,
    ta.is_package as analytics_is_package,
    
    -- 가중치 적용 금액
    ROUND(ct.price_with_tax * ta.weight_percentage / 100, 2) as weighted_price_with_tax,
    ROUND(ct.price_without_tax * ta.weight_percentage / 100, 2) as weighted_price_without_tax,
    
    ct.body_part,
    ct.volume,
    ct.notes,
    ct.created_at
FROM customer_treatments ct
LEFT JOIN customers c ON ct.customer_id = c.id
LEFT JOIN treatment_analytics ta ON ct.id = ta.customer_treatment_id;

-- 패키지 사용 통계 뷰
CREATE OR REPLACE VIEW package_usage_stats AS
SELECT 
    tp.package_name,
    tp.is_separable,
    tp.description,
    COUNT(ct.id) as usage_count,
    AVG(ct.price_with_tax) as avg_price,
    SUM(ct.price_with_tax) as total_revenue,
    MIN(ct.created_at) as first_used,
    MAX(ct.created_at) as last_used
FROM treatment_packages tp
LEFT JOIN customer_treatments ct ON tp.package_name = ct.hospital_procedure_name
GROUP BY tp.id, tp.package_name, tp.is_separable, tp.description
ORDER BY usage_count DESC;

-- ========================================
-- 6. 데이터 검증 함수
-- ========================================

-- 패키지 분해 검증 함수
CREATE OR REPLACE FUNCTION validate_package_decomposition(treatment_id UUID)
RETURNS TABLE (
    original_treatment VARCHAR,
    component_count INTEGER,
    total_weight NUMERIC,
    is_valid BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ct.hospital_procedure_name,
        COUNT(ta.id)::INTEGER,
        SUM(ta.weight_percentage),
        CASE 
            WHEN ct.is_package THEN SUM(ta.weight_percentage) = 100
            ELSE SUM(ta.weight_percentage) = 100
        END
    FROM customer_treatments ct
    LEFT JOIN treatment_analytics ta ON ct.id = ta.customer_treatment_id
    WHERE ct.id = treatment_id
    GROUP BY ct.hospital_procedure_name, ct.is_package;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 7. 제약조건 추가
-- ========================================

-- 가격 유효성 검사
ALTER TABLE customer_treatments 
ADD CONSTRAINT check_price_positive 
CHECK (price_with_tax >= 0);

-- 고객별 시술 개수 제한 (선택사항 - 너무 많은 시술 방지)
-- ALTER TABLE customer_treatments ADD CONSTRAINT max_treatments_per_customer 
-- CHECK ((SELECT COUNT(*) FROM customer_treatments ct WHERE ct.customer_id = customer_id) <= 50);

-- ========================================
-- 완료 메시지
-- ========================================

DO $$
BEGIN
    RAISE NOTICE '✅ 고객 시술 테이블 + 패키지 분해 시스템 생성 완료!';
    RAISE NOTICE '🤖 자동 트리거: 패키지 감지, 자동 분해, 데이터 정리';
    RAISE NOTICE '📊 분석 뷰: customer_treatment_details, package_usage_stats';
    RAISE NOTICE '🔍 검증 함수: validate_package_decomposition()';
    RAISE NOTICE '🎯 다음 단계: 05_create_settlements_table.sql 실행';
END $$; 