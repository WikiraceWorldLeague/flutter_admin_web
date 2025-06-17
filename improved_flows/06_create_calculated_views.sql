-- 금액 계산 및 매출 분석을 위한 뷰 생성 + 🆕 패키지 분석 뷰
-- 실행 순서: 6번째

-- ========================================
-- 1. 고객별 총 결제금액 계산 뷰 (패키지 분해 지원)
-- ========================================

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
    
    -- 🆕 패키지 vs 단일 시술 구분
    COUNT(CASE WHEN ct.is_package THEN 1 END) as package_treatment_count,
    COUNT(CASE WHEN NOT ct.is_package THEN 1 END) as single_treatment_count,
    COALESCE(SUM(CASE WHEN ct.is_package THEN ct.price_with_tax ELSE 0 END), 0) as package_amount,
    COALESCE(SUM(CASE WHEN NOT ct.is_package THEN ct.price_with_tax ELSE 0 END), 0) as single_amount,
    
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

-- ========================================
-- 2. 월별 매출 분석 뷰 (패키지 지원)
-- ========================================

CREATE OR REPLACE VIEW monthly_revenue_analysis AS
SELECT 
    r.visit_month,
    cl.clinic_name,
    cl.commission_rate,
    
    -- 매출 집계
    COUNT(DISTINCT c.id) as customer_count,
    COUNT(ct.id) as total_treatments,
    
    -- 🆕 패키지/단일 시술 구분 집계
    COUNT(CASE WHEN ct.is_package THEN 1 END) as package_treatments,
    COUNT(CASE WHEN NOT ct.is_package THEN 1 END) as single_treatments,
    
    SUM(ct.price_with_tax) as total_sales_with_tax,
    SUM(ct.price_without_tax) as total_sales_without_tax,
    
    -- 🆕 패키지/단일 매출 구분
    SUM(CASE WHEN ct.is_package THEN ct.price_with_tax ELSE 0 END) as package_sales,
    SUM(CASE WHEN NOT ct.is_package THEN ct.price_with_tax ELSE 0 END) as single_sales,
    
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

-- ========================================
-- 🆕 3. 시술별 인기도 분석 뷰 (패키지 분해 기반)
-- ========================================

CREATE OR REPLACE VIEW treatment_popularity_analysis AS
SELECT 
    ta.component_treatment_name as treatment_name,
    ta.component_category,
    
    -- 📊 사용 통계 (가중치 적용)
    COUNT(ta.id) as total_usage_count,
    COUNT(CASE WHEN ta.is_package THEN 1 END) as package_usage_count,
    COUNT(CASE WHEN NOT ta.is_package THEN 1 END) as single_usage_count,
    
    -- 💰 금액 통계 (가중치 적용)
    ROUND(SUM(ct.price_with_tax * ta.weight_percentage / 100), 2) as weighted_total_revenue,
    ROUND(AVG(ct.price_with_tax * ta.weight_percentage / 100), 2) as weighted_avg_price,
    
    -- 📈 트렌드 분석
    COUNT(CASE WHEN ct.created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as recent_30_days,
    COUNT(CASE WHEN ct.created_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as recent_7_days,
    
    -- 🔄 패키지 연관성
    STRING_AGG(ta.original_treatment_name, ' | ') FILTER (WHERE ta.is_package) as associated_packages,
    
    -- 📅 최근 사용일
    MAX(ct.created_at) as last_used_date,
    MIN(ct.created_at) as first_used_date
FROM treatment_analytics ta
JOIN customer_treatments ct ON ta.customer_treatment_id = ct.id
GROUP BY ta.component_treatment_name, ta.component_category
ORDER BY total_usage_count DESC, weighted_total_revenue DESC;

-- ========================================
-- 🆕 4. 패키지 분석 특화 뷰
-- ========================================

-- 패키지 성과 분석 뷰
CREATE OR REPLACE VIEW package_performance_analysis AS
SELECT 
    tp.package_name,
    tp.is_separable,
    tp.description,
    
    -- 사용 통계
    COUNT(ct.id) as usage_count,
    COUNT(DISTINCT ct.customer_id) as unique_customers,
    
    -- 매출 통계
    SUM(ct.price_with_tax) as total_revenue,
    AVG(ct.price_with_tax) as avg_price_per_usage,
    MIN(ct.price_with_tax) as min_price,
    MAX(ct.price_with_tax) as max_price,
    
    -- 시기별 분석
    COUNT(CASE WHEN ct.created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as usage_last_30_days,
    COUNT(CASE WHEN ct.created_at >= CURRENT_DATE - INTERVAL '90 days' THEN 1 END) as usage_last_90_days,
    
    -- 구성 요소 정보
    STRING_AGG(pc.component_name, ' + ' ORDER BY pc.is_primary DESC, pc.weight_percentage DESC) as component_list,
    
    -- 날짜 정보
    MIN(ct.created_at) as first_used,
    MAX(ct.created_at) as last_used
FROM treatment_packages tp
LEFT JOIN customer_treatments ct ON tp.package_name = ct.hospital_procedure_name
LEFT JOIN package_components pc ON tp.id = pc.package_id
GROUP BY tp.id, tp.package_name, tp.is_separable, tp.description
ORDER BY usage_count DESC, total_revenue DESC;

-- 패키지 vs 단일 시술 비교 뷰
CREATE OR REPLACE VIEW package_vs_single_analysis AS
SELECT 
    -- 시간 기준
    DATE_TRUNC('month', ct.created_at) as month,
    
    -- 패키지 통계
    COUNT(CASE WHEN ct.is_package THEN 1 END) as package_count,
    SUM(CASE WHEN ct.is_package THEN ct.price_with_tax ELSE 0 END) as package_revenue,
    AVG(CASE WHEN ct.is_package THEN ct.price_with_tax END) as package_avg_price,
    
    -- 단일 시술 통계
    COUNT(CASE WHEN NOT ct.is_package THEN 1 END) as single_count,
    SUM(CASE WHEN NOT ct.is_package THEN ct.price_with_tax ELSE 0 END) as single_revenue,
    AVG(CASE WHEN NOT ct.is_package THEN ct.price_with_tax END) as single_avg_price,
    
    -- 비율 계산
    ROUND(
        COUNT(CASE WHEN ct.is_package THEN 1 END)::NUMERIC / 
        NULLIF(COUNT(*), 0) * 100, 2
    ) as package_ratio_percent,
    
    ROUND(
        SUM(CASE WHEN ct.is_package THEN ct.price_with_tax ELSE 0 END)::NUMERIC / 
        NULLIF(SUM(ct.price_with_tax), 0) * 100, 2
    ) as package_revenue_ratio_percent
FROM customer_treatments ct
GROUP BY DATE_TRUNC('month', ct.created_at)
ORDER BY month DESC;

-- ========================================
-- 5. 고객 유입경로 분석 뷰 (기존 유지 + 패키지 정보 추가)
-- ========================================

CREATE OR REPLACE VIEW customer_acquisition_analysis AS
SELECT 
    c.acquisition_channel,
    c.communication_channel,
    COUNT(DISTINCT c.id) as customer_count,
    SUM(ct.price_with_tax) as total_revenue,
    AVG(ct.price_with_tax) as avg_revenue_per_customer,
    
    -- 🆕 패키지 선호도 분석
    COUNT(CASE WHEN ct.is_package THEN 1 END) as package_purchases,
    COUNT(CASE WHEN NOT ct.is_package THEN 1 END) as single_purchases,
    ROUND(
        COUNT(CASE WHEN ct.is_package THEN 1 END)::NUMERIC / 
        NULLIF(COUNT(ct.id), 0) * 100, 2
    ) as package_preference_percent,
    
    -- 월별 분포
    COUNT(CASE WHEN r.visit_month = TO_CHAR(CURRENT_DATE, 'YYYY년 MM월') THEN 1 END) as current_month_customers,
    COUNT(CASE WHEN r.visit_month = TO_CHAR(CURRENT_DATE - INTERVAL '1 month', 'YYYY년 MM월') THEN 1 END) as last_month_customers
FROM customers c
LEFT JOIN reservations r ON c.reservation_id = r.id
LEFT JOIN customer_treatments ct ON c.id = ct.customer_id
WHERE c.acquisition_channel IS NOT NULL
GROUP BY c.acquisition_channel, c.communication_channel
ORDER BY customer_count DESC;

-- ========================================
-- 6. 정산 현황 뷰 (기존 유지)
-- ========================================

CREATE OR REPLACE VIEW settlement_status_view AS
SELECT 
    s.settlement_month,
    g.passport_first_name || ' ' || g.passport_last_name as guide_name,
    s.settlement_status,
    COUNT(s.id) as settlement_count,
    SUM(s.base_amount) as total_base_amount,
    SUM(s.commission_amount) as total_commission_amount,
    MIN(s.service_date) as earliest_service_date,
    MAX(s.service_date) as latest_service_date
FROM settlements s
JOIN guides g ON s.guide_id = g.id
GROUP BY s.settlement_month, g.passport_first_name, g.passport_last_name, s.settlement_status
ORDER BY s.settlement_month DESC, guide_name;

-- ========================================
-- 🆕 7. 종합 대시보드 뷰
-- ========================================

-- 실시간 대시보드 메트릭스
CREATE OR REPLACE VIEW dashboard_metrics AS
SELECT 
    -- 기본 통계
    (SELECT COUNT(*) FROM customers) as total_customers,
    (SELECT COUNT(*) FROM customer_treatments) as total_treatments,
    (SELECT COUNT(*) FROM treatment_packages) as total_packages,
    
    -- 이번 달 통계
    (SELECT COUNT(*) FROM customers c 
     JOIN reservations r ON c.reservation_id = r.id 
     WHERE r.visit_month = TO_CHAR(CURRENT_DATE, 'YYYY년 MM월')) as this_month_customers,
    
    -- 매출 통계
    (SELECT COALESCE(SUM(price_with_tax), 0) FROM customer_treatments) as total_revenue,
    (SELECT COALESCE(SUM(price_with_tax), 0) FROM customer_treatments ct
     JOIN customers c ON ct.customer_id = c.id
     JOIN reservations r ON c.reservation_id = r.id
     WHERE r.visit_month = TO_CHAR(CURRENT_DATE, 'YYYY년 MM월')) as this_month_revenue,
    
    -- 패키지 통계
    (SELECT COUNT(*) FROM customer_treatments WHERE is_package = true) as total_package_treatments,
    (SELECT COUNT(*) FROM customer_treatments WHERE is_package = false) as total_single_treatments,
    (SELECT ROUND(
        COUNT(CASE WHEN is_package THEN 1 END)::NUMERIC / 
        NULLIF(COUNT(*), 0) * 100, 2
    ) FROM customer_treatments) as package_usage_percentage;

-- ========================================
-- 완료 메시지
-- ========================================

DO $$
BEGIN
    RAISE NOTICE '✅ 매출 분석 뷰 + 패키지 분석 시스템 생성 완료!';
    RAISE NOTICE '📊 기본 뷰: customer_payment_summary, monthly_revenue_analysis';
    RAISE NOTICE '📦 패키지 뷰: treatment_popularity_analysis, package_performance_analysis';
    RAISE NOTICE '📈 비교 뷰: package_vs_single_analysis, customer_acquisition_analysis';
    RAISE NOTICE '🎯 대시보드: dashboard_metrics';
    RAISE NOTICE '🎯 다음 단계: 07_sample_data_and_usage.sql 실행';
END $$; 