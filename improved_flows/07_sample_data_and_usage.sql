-- 샘플 데이터 및 사용 예시
-- 실행 순서: 7번째 (선택사항)

-- 이 파일은 테스트용 샘플 데이터를 삽입하고 사용법을 보여줍니다.
-- 운영 환경에서는 신중하게 사용하세요.

-- ========================================
-- 1. 샘플 데이터 삽입 (예시)
-- ========================================

-- 샘플 예약 데이터
INSERT INTO reservations (
    id, reservation_code, group_size, hospital_booking_date, 
    hospital_visit_date, visit_day_of_week, visit_month
) VALUES 
(
    uuid_generate_v4(), 
    'G2-20240115-A', 
    2, 
    '2024-01-10', 
    '2024-01-15', 
    '월요일', 
    '2024년 01월'
) ON CONFLICT DO NOTHING;

-- 샘플 고객 데이터
INSERT INTO customers (
    name, gender, birth_date, nationality, customer_code, passport_name,
    acquisition_channel, communication_channel, is_booker, reservation_id
) VALUES 
(
    '김민지', '여', '1995-03-15', 'KR', 'Kim-KR-950315', 'KIM MINJI',
    'Threads', 'Instagram', true, 
    (SELECT id FROM reservations WHERE reservation_code = 'G2-20240115-A')
),
(
    '박서연', '여', '1992-07-22', 'KR', 'Park-KR-920722', 'PARK SEOYEON', 
    'Threads', 'Instagram', false,
    (SELECT id FROM reservations WHERE reservation_code = 'G2-20240115-A')
) ON CONFLICT (customer_code) DO NOTHING;

-- 샘플 고객 시술 데이터
INSERT INTO customer_treatments (
    customer_id, procedure_id, effect_id, hospital_procedure_name,
    volume, body_part, price_with_tax
) VALUES 
(
    (SELECT id FROM customers WHERE customer_code = 'Kim-KR-950315'),
    (SELECT id FROM treatment_procedures WHERE name = '필러(쥬비덤)'),
    (SELECT id FROM treatment_effects WHERE name = '볼륨 개선'),
    '필러(쥬비덤) 눈밑1cc',
    '1cc',
    '눈밑',
    605000
),
(
    (SELECT id FROM customers WHERE customer_code = 'Park-KR-920722'),
    (SELECT id FROM treatment_procedures WHERE name = '필러(쥬비덤)'),
    (SELECT id FROM treatment_effects WHERE name = '꺼짐 부위 채움'),
    '필러(쥬비덤) 볼2cc',
    '2cc', 
    '볼',
    1100000
) ON CONFLICT DO NOTHING;

-- ========================================
-- 2. 금액 자동 계산 및 업데이트 함수
-- ========================================

-- 고객별 금액 자동 계산 함수
CREATE OR REPLACE FUNCTION calculate_customer_financials()
RETURNS TRIGGER AS $$
DECLARE
    customer_rec customers%ROWTYPE;
    clinic_commission_rate NUMERIC;
    total_payment NUMERIC;
BEGIN
    -- 해당 고객 정보 조회
    SELECT * INTO customer_rec FROM customers WHERE id = NEW.customer_id;
    
    -- 병원 수수료율 조회
    SELECT cl.commission_rate INTO clinic_commission_rate
    FROM customers c
    JOIN reservations r ON c.reservation_id = r.id
    JOIN clinics cl ON r.clinic_id = cl.id
    WHERE c.id = NEW.customer_id;
    
    -- 고객 총 결제금액 계산
    SELECT COALESCE(SUM(price_with_tax), 0) INTO total_payment
    FROM customer_treatments 
    WHERE customer_id = NEW.customer_id;
    
    -- customers 테이블 금액 필드 업데이트
    UPDATE customers SET
        total_payment_amount = total_payment,
        company_revenue_with_tax = total_payment * clinic_commission_rate / 100,
        company_revenue_without_tax = (total_payment / 1.1) * clinic_commission_rate / 100,
        guide_commission = total_payment * 4.5 / 100,
        net_revenue_with_tax = (total_payment * clinic_commission_rate / 100) - (total_payment * 4.5 / 100),
        net_revenue_without_tax = ((total_payment / 1.1) * clinic_commission_rate / 100) - (total_payment * 4.5 / 100)
    WHERE id = NEW.customer_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성: 시술 추가/수정/삭제시 금액 자동 계산
CREATE TRIGGER trigger_calculate_customer_financials
    AFTER INSERT OR UPDATE OR DELETE ON customer_treatments
    FOR EACH ROW EXECUTE FUNCTION calculate_customer_financials();

-- ========================================
-- 3. 유용한 쿼리 예시
-- ========================================

-- 예시 1: 특정 월의 매출 현황 조회
/*
SELECT * FROM monthly_revenue_analysis 
WHERE visit_month = '2024년 01월'
ORDER BY total_sales_with_tax DESC;
*/

-- 예시 2: 고객별 상세 결제 정보 조회
/*
SELECT 
    cps.customer_name,
    cps.customer_code,
    cps.nationality,
    cps.clinic_name,
    cps.total_payment_amount,
    cps.company_revenue_with_tax,
    cps.guide_commission,
    cps.net_revenue_with_tax,
    cps.treatment_count
FROM customer_payment_summary cps
WHERE cps.hospital_visit_date >= '2024-01-01'
ORDER BY cps.total_payment_amount DESC;
*/

-- 예시 3: 가장 인기 있는 시술 TOP 10
/*
SELECT 
    procedure_name,
    category_name,
    usage_count,
    avg_price_with_tax,
    total_revenue
FROM treatment_popularity_analysis
LIMIT 10;
*/

-- 예시 4: 유입경로별 고객 수 및 매출
/*
SELECT 
    acquisition_channel,
    customer_count,
    total_revenue,
    avg_revenue_per_customer
FROM customer_acquisition_analysis
ORDER BY total_revenue DESC;
*/

-- 예시 5: 고객 검색 (이름으로)
/*
SELECT 
    c.name,
    c.customer_code,
    c.nationality,
    c.birth_date,
    c.total_payment_amount,
    r.reservation_code,
    r.hospital_visit_date
FROM customers c
LEFT JOIN reservations r ON c.reservation_id = r.id
WHERE c.name ILIKE '%김%'
ORDER BY c.created_at DESC;
*/

-- 예시 6: 정산 현황 조회
/*
SELECT 
    guide_name,
    settlement_month,
    settlement_count,
    total_commission_amount,
    settlement_status
FROM settlement_status_view
WHERE settlement_month = '2024-01'
ORDER BY total_commission_amount DESC;
*/

-- ========================================
-- 4. 데이터 정합성 검사 쿼리
-- ========================================

-- 금액 계산 검증
/*
SELECT 
    c.name,
    c.total_payment_amount as stored_total,
    COALESCE(SUM(ct.price_with_tax), 0) as calculated_total,
    c.total_payment_amount - COALESCE(SUM(ct.price_with_tax), 0) as difference
FROM customers c
LEFT JOIN customer_treatments ct ON c.id = ct.customer_id
GROUP BY c.id, c.name, c.total_payment_amount
HAVING c.total_payment_amount != COALESCE(SUM(ct.price_with_tax), 0);
*/ 