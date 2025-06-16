-- 금액 계산 및 매출 분석을 위한 뷰 생성
-- 실행 순서: 6번째

-- 1. 고객별 총 결제금액 계산 뷰
CREATE OR REPLACE VIEW customer_payment_summary AS
SELECT 
    c.id as customer_id,
    c.name as customer_name,
    c.customer_code,
    c.nationality,
    r.reservation_code,
    cl.clinic_name,
    cl.commission_rate as clinic_commission_rate,
    
    -- 고객별 총 시술 금액
    COALESCE(SUM(ct.price_with_tax), 0) as total_payment_amount,
    COALESCE(SUM(ct.price_without_tax), 0) as total_payment_without_tax,
    
    -- 회사 매출 계산 (병원 수수료)
    COALESCE(SUM(ct.price_with_tax) * cl.commission_rate / 100, 0) as company_revenue_with_tax,
    COALESCE(SUM(ct.price_without_tax) * cl.commission_rate / 100, 0) as company_revenue_without_tax,
    
    -- 가이드 정산 계산 (4.5%)
    COALESCE(SUM(ct.price_with_tax) * 4.5 / 100, 0) as guide_commission,
    
    -- 회사 순매출 계산
    COALESCE(SUM(ct.price_with_tax) * cl.commission_rate / 100, 0) - COALESCE(SUM(ct.price_with_tax) * 4.5 / 100, 0) as net_revenue_with_tax,
    COALESCE(SUM(ct.price_without_tax) * cl.commission_rate / 100, 0) - COALESCE(SUM(ct.price_with_tax) * 4.5 / 100, 0) as net_revenue_without_tax,
    
    -- 시술 개수
    COUNT(ct.id) as treatment_count,
    
    -- 메타 정보
    r.hospital_visit_date,
    r.visit_month
FROM customers c
LEFT JOIN reservations r ON c.reservation_id = r.id
LEFT JOIN clinics cl ON r.clinic_id = cl.id
LEFT JOIN customer_treatments ct ON c.id = ct.customer_id
GROUP BY c.id, c.name, c.customer_code, c.nationality, r.reservation_code, 
         cl.clinic_name, cl.commission_rate, r.hospital_visit_date, r.visit_month;

-- 2. 월별 매출 분석 뷰
CREATE OR REPLACE VIEW monthly_revenue_analysis AS
SELECT 
    r.visit_month,
    cl.clinic_name,
    cl.commission_rate,
    
    -- 매출 집계
    COUNT(DISTINCT c.id) as customer_count,
    COUNT(ct.id) as total_treatments,
    SUM(ct.price_with_tax) as total_sales_with_tax,
    SUM(ct.price_without_tax) as total_sales_without_tax,
    
    -- 회사 매출
    SUM(ct.price_with_tax * cl.commission_rate / 100) as company_revenue_with_tax,
    SUM(ct.price_without_tax * cl.commission_rate / 100) as company_revenue_without_tax,
    
    -- 가이드 정산 총액
    SUM(ct.price_with_tax * 4.5 / 100) as total_guide_commission,
    
    -- 순매출
    SUM(ct.price_with_tax * cl.commission_rate / 100) - SUM(ct.price_with_tax * 4.5 / 100) as net_revenue_with_tax,
    SUM(ct.price_without_tax * cl.commission_rate / 100) - SUM(ct.price_with_tax * 4.5 / 100) as net_revenue_without_tax
FROM customers c
JOIN reservations r ON c.reservation_id = r.id
JOIN clinics cl ON r.clinic_id = cl.id
JOIN customer_treatments ct ON c.id = ct.customer_id
WHERE r.visit_month IS NOT NULL
GROUP BY r.visit_month, cl.clinic_name, cl.commission_rate
ORDER BY r.visit_month DESC;

-- 3. 시술별 인기도 분석 뷰
CREATE OR REPLACE VIEW treatment_popularity_analysis AS
SELECT 
    tp.name as procedure_name,
    tc.name as category_name,
    ts.name as subcategory_name,
    te.name as effect_name,
    
    -- 시술 통계
    COUNT(ct.id) as usage_count,
    AVG(ct.price_with_tax) as avg_price_with_tax,
    SUM(ct.price_with_tax) as total_revenue,
    
    -- 부위별 통계
    STRING_AGG(DISTINCT ct.body_part, ', ') as common_body_parts,
    STRING_AGG(DISTINCT ct.volume, ', ') as common_volumes
FROM customer_treatments ct
JOIN treatment_procedures tp ON ct.procedure_id = tp.id
JOIN treatment_subcategories ts ON tp.subcategory_id = ts.id
JOIN treatment_categories tc ON ts.category_id = tc.id
LEFT JOIN treatment_effects te ON ct.effect_id = te.id
GROUP BY tp.id, tp.name, tc.name, ts.name, te.name
ORDER BY usage_count DESC;

-- 4. 고객 유입경로 분석 뷰
CREATE OR REPLACE VIEW customer_acquisition_analysis AS
SELECT 
    c.acquisition_channel,
    c.communication_channel,
    COUNT(DISTINCT c.id) as customer_count,
    SUM(ct.price_with_tax) as total_revenue,
    AVG(ct.price_with_tax) as avg_revenue_per_customer,
    
    -- 월별 분포
    COUNT(CASE WHEN r.visit_month = TO_CHAR(CURRENT_DATE, 'YYYY년 MM월') THEN 1 END) as current_month_customers,
    COUNT(CASE WHEN r.visit_month = TO_CHAR(CURRENT_DATE - INTERVAL '1 month', 'YYYY년 MM월') THEN 1 END) as last_month_customers
FROM customers c
LEFT JOIN reservations r ON c.reservation_id = r.id
LEFT JOIN customer_treatments ct ON c.id = ct.customer_id
WHERE c.acquisition_channel IS NOT NULL
GROUP BY c.acquisition_channel, c.communication_channel
ORDER BY customer_count DESC;

-- 5. 정산 현황 뷰
CREATE OR REPLACE VIEW settlement_status_view AS
SELECT 
    s.settlement_month,
    g.name as guide_name,
    s.settlement_status,
    COUNT(s.id) as settlement_count,
    SUM(s.base_amount) as total_base_amount,
    SUM(s.commission_amount) as total_commission_amount,
    MIN(s.service_date) as earliest_service_date,
    MAX(s.service_date) as latest_service_date
FROM settlements s
JOIN guides g ON s.guide_id = g.id
GROUP BY s.settlement_month, g.name, s.settlement_status
ORDER BY s.settlement_month DESC, g.name; 