-- 가이드 정산 관리 테이블 수정/보완
-- 실행 순서: 5번째

-- ⚠️ 주의: settlements 테이블이 이미 존재하므로 누락된 컬럼만 추가합니다

-- ========================================
-- 1. 기존 settlements 테이블 확인 및 보완
-- ========================================

-- 기존 settlements 테이블에 누락된 컬럼이 있다면 추가
-- (현재 테이블 구조 확인 후 필요시 컬럼 추가)

DO $$
BEGIN
    -- customer_id 컬럼이 없다면 추가 (중요!)
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'settlements' AND column_name = 'customer_id'
    ) THEN
        ALTER TABLE settlements ADD COLUMN customer_id UUID REFERENCES customers(id);
        RAISE NOTICE '✅ customer_id 컬럼 추가됨';
    END IF;
    
    -- reservation_id 컬럼이 없다면 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'settlements' AND column_name = 'reservation_id'
    ) THEN
        ALTER TABLE settlements ADD COLUMN reservation_id UUID REFERENCES reservations(id);
        RAISE NOTICE '✅ reservation_id 컬럼 추가됨';
    END IF;
    
    -- service_date 컬럼이 없다면 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'settlements' AND column_name = 'service_date'
    ) THEN
        ALTER TABLE settlements ADD COLUMN service_date DATE;
        RAISE NOTICE '✅ service_date 컬럼 추가됨';
    END IF;
    
    -- settlement_month 컬럼이 없다면 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'settlements' AND column_name = 'settlement_month'
    ) THEN
        ALTER TABLE settlements ADD COLUMN settlement_month VARCHAR(10);
        RAISE NOTICE '✅ settlement_month 컬럼 추가됨';
    END IF;
    
    -- base_amount 컬럼이 없다면 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'settlements' AND column_name = 'base_amount'
    ) THEN
        ALTER TABLE settlements ADD COLUMN base_amount NUMERIC(10,2);
        RAISE NOTICE '✅ base_amount 컬럼 추가됨';
    END IF;
    
    -- commission_rate 컬럼이 없다면 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'settlements' AND column_name = 'commission_rate'
    ) THEN
        ALTER TABLE settlements ADD COLUMN commission_rate NUMERIC(5,2) DEFAULT 4.5;
        RAISE NOTICE '✅ commission_rate 컬럼 추가됨';
    END IF;
    
    -- settlement_status 컬럼이 없다면 추가 (기존 status와 다름)
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'settlements' AND column_name = 'settlement_status'
    ) THEN
        ALTER TABLE settlements ADD COLUMN settlement_status VARCHAR(20) DEFAULT 'pending';
        RAISE NOTICE '✅ settlement_status 컬럼 추가됨';
    END IF;
    
    -- 기존 테이블이 완전하다면 메시지 출력
    RAISE NOTICE '📊 settlements 테이블 구조 확인 완료';
END $$;

-- ========================================
-- 🆕 2. 패키지 관련 정산 지원 기능 추가
-- ========================================

-- 정산 계산 함수 (패키지 지원)
CREATE OR REPLACE FUNCTION calculate_settlement_amount(p_customer_id UUID, p_guide_id UUID, p_commission_rate NUMERIC DEFAULT 4.5)
RETURNS NUMERIC AS $$
DECLARE
    total_amount NUMERIC := 0;
BEGIN
    -- 고객의 총 시술 금액 계산 (패키지 분해 고려)
    SELECT COALESCE(SUM(ct.price_with_tax), 0)
    INTO total_amount
    FROM customer_treatments ct
    WHERE ct.customer_id = p_customer_id;
    
    -- 정산 금액 = 총 금액 × 수수료율
    RETURN total_amount * p_commission_rate / 100;
END;
$$ LANGUAGE plpgsql;

-- 고객별 정산 자동 생성 함수
CREATE OR REPLACE FUNCTION create_settlement_for_customer(
    p_customer_id UUID,
    p_guide_id UUID,
    p_service_date DATE DEFAULT CURRENT_DATE,
    p_commission_rate NUMERIC DEFAULT 4.5
)
RETURNS UUID AS $$
DECLARE
    settlement_id UUID;
    total_customer_amount NUMERIC;
    reservation_info RECORD;
BEGIN
    -- 고객의 예약 정보 조회
    SELECT r.id as reservation_id
    INTO reservation_info
    FROM customers c
    JOIN reservations r ON c.reservation_id = r.id
    WHERE c.id = p_customer_id;
    
    -- 고객의 총 시술 금액 계산
    SELECT COALESCE(SUM(price_with_tax), 0)
    INTO total_customer_amount
    FROM customer_treatments
    WHERE customer_id = p_customer_id;
    
    -- 정산 레코드 생성
    INSERT INTO settlements (
        guide_id,
        customer_id,
        reservation_id,
        base_amount,
        commission_rate,
        service_date,
        settlement_month,
        settlement_status
    ) VALUES (
        p_guide_id,
        p_customer_id,
        reservation_info.reservation_id,
        total_customer_amount,
        p_commission_rate,
        p_service_date,
        TO_CHAR(p_service_date, 'YYYY-MM'),
        'pending'
    )
    RETURNING id INTO settlement_id;
    
    RETURN settlement_id;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 3. 정산 관련 뷰 추가
-- ========================================

-- 정산 상세 분석 뷰 (패키지 분해 포함)
CREATE OR REPLACE VIEW settlement_analysis AS
SELECT 
    s.id as settlement_id,
    s.guide_id,
    g.passport_first_name || ' ' || g.passport_last_name as guide_name,
    s.customer_id,
    c.name as customer_name,
    s.settlement_month,
    s.service_date,
    s.base_amount,
    s.commission_rate,
    s.commission_amount,
    s.settlement_status,
    
    -- 고객의 시술 분석
    COUNT(ct.id) as treatment_count,
    COUNT(CASE WHEN ct.is_package THEN 1 END) as package_count,
    COUNT(CASE WHEN NOT ct.is_package THEN 1 END) as single_treatment_count,
    
    -- 분해된 시술 분석
    STRING_AGG(DISTINCT ta.component_treatment_name, ', ') as component_treatments,
    
    s.created_at,
    s.updated_at
FROM settlements s
LEFT JOIN guides g ON s.guide_id = g.id
LEFT JOIN customers c ON s.customer_id = c.id
LEFT JOIN customer_treatments ct ON s.customer_id = ct.customer_id
LEFT JOIN treatment_analytics ta ON ct.id = ta.customer_treatment_id
GROUP BY s.id, g.passport_first_name, g.passport_last_name, c.name;

-- 월별 정산 요약 뷰
CREATE OR REPLACE VIEW monthly_settlement_summary AS
SELECT 
    settlement_month,
    COUNT(DISTINCT guide_id) as guide_count,
    COUNT(DISTINCT customer_id) as customer_count,
    COUNT(*) as settlement_count,
    SUM(base_amount) as total_base_amount,
    SUM(commission_amount) as total_commission_amount,
    AVG(commission_rate) as avg_commission_rate,
    COUNT(CASE WHEN settlement_status = 'pending' THEN 1 END) as pending_count,
    COUNT(CASE WHEN settlement_status = 'paid' THEN 1 END) as paid_count
FROM settlements
GROUP BY settlement_month
ORDER BY settlement_month DESC;

-- ========================================
-- 4. 추가 인덱스 생성
-- ========================================

-- 정산 조회 성능 향상을 위한 추가 인덱스
CREATE INDEX IF NOT EXISTS idx_settlements_service_date ON settlements(service_date);
CREATE INDEX IF NOT EXISTS idx_settlements_settlement_month_status ON settlements(settlement_month, settlement_status);
CREATE INDEX IF NOT EXISTS idx_settlements_base_amount ON settlements(base_amount);

-- ========================================
-- 5. 제약조건 추가
-- ========================================

-- 정산 금액 유효성 검사
DO $$
BEGIN
    -- base_amount 양수 체크
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_base_amount_positive'
    ) THEN
        ALTER TABLE settlements 
        ADD CONSTRAINT check_base_amount_positive 
        CHECK (base_amount >= 0);
        RAISE NOTICE '✅ base_amount 유효성 제약조건 추가됨';
    END IF;
    
    -- commission_rate 유효성 체크
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'check_commission_rate_valid'
    ) THEN
        ALTER TABLE settlements 
        ADD CONSTRAINT check_commission_rate_valid 
        CHECK (commission_rate >= 0 AND commission_rate <= 100);
        RAISE NOTICE '✅ commission_rate 유효성 제약조건 추가됨';
    END IF;
END $$;

-- ========================================
-- 6. RLS 정책 업데이트 (선택사항)
-- ========================================

-- 기존 RLS 정책이 있다면 업데이트, 없다면 새로 생성
DROP POLICY IF EXISTS settlements_guide_policy ON settlements;
DROP POLICY IF EXISTS settlements_admin_policy ON settlements;

-- 새로운 RLS 정책 생성 (더 세밀한 제어)
CREATE POLICY settlements_guide_read_own ON settlements
    FOR SELECT
    USING (guide_id = auth.uid());

CREATE POLICY settlements_admin_all ON settlements
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- ========================================
-- 완료 메시지
-- ========================================

DO $$
BEGIN
    RAISE NOTICE '✅ settlements 테이블 업데이트 완료!';
    RAISE NOTICE '📦 패키지 지원: 정산 계산 함수, 자동 생성 함수';
    RAISE NOTICE '📊 분석 뷰: settlement_analysis, monthly_settlement_summary';
    RAISE NOTICE '🔒 RLS 정책 업데이트 완료';
    RAISE NOTICE '🎯 다음 단계: 06_create_calculated_views.sql 실행';
END $$; 