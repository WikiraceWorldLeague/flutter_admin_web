-- 샘플 데이터 및 사용 예시 + 🆕 패키지 시스템 예시
-- 실행 순서: 7번째 (선택사항)

-- 이 파일은 테스트용 샘플 데이터를 삽입하고 사용법을 보여줍니다.
-- 운영 환경에서는 신중하게 사용하세요.

-- ========================================
-- 1. 기본 샘플 데이터 삽입
-- ========================================

-- 샘플 예약 데이터
INSERT INTO reservations (
    id, reservation_number, reservation_date, start_time, status,
    reservation_code, group_size, hospital_booking_date, 
    hospital_visit_date, visit_day_of_week, visit_month
) VALUES 
(
    '33333333-3333-3333-3333-333333333333',
    'RES-20240115-001',
    '2024-01-15',
    '09:00:00',
    'completed',
    'G2-20240115-A', 
    2, 
    '2024-01-10', 
    '2024-01-15', 
    '월요일', 
    '2024년 01월'
),
(
    '44444444-4444-4444-4444-444444444444',
    'RES-20240120-002', 
    '2024-01-20',
    '10:30:00',
    'completed',
    'G3-20240120-B', 
    3, 
    '2024-01-18', 
    '2024-01-20', 
    '토요일', 
    '2024년 01월'
) ON CONFLICT (id) DO NOTHING;

-- 샘플 고객 데이터
INSERT INTO customers (
    id, name, gender, birth_date, nationality, customer_code, passport_name,
    acquisition_channel, communication_channel, is_booker, reservation_id
) VALUES 
(
    '55555555-5555-5555-5555-555555555555',
    '김민지', 'female', '1995-03-15', 'KR', 'Kim-KR-950315', 'KIM MINJI',
    'Threads', 'Instagram', true, 
    '33333333-3333-3333-3333-333333333333'
),
(
    '66666666-6666-6666-6666-666666666666',
    '박서연', 'female', '1992-07-22', 'KR', 'Park-KR-920722', 'PARK SEOYEON', 
    'Threads', 'Instagram', false,
    '33333333-3333-3333-3333-333333333333'
),
(
    '77777777-7777-7777-7777-777777777777',
    '이지은', 'female', '1988-05-16', 'KR', 'Lee-KR-880516', 'LEE JIEUN',
    'YouTube', 'KakaoTalk', true,
    '44444444-4444-4444-4444-444444444444'
) ON CONFLICT (customer_code) DO NOTHING;

-- ========================================
-- 🆕 2. 패키지 시술 샘플 데이터
-- ========================================

-- 패키지 시술 예시 (자동 분해됨)
INSERT INTO customer_treatments (
    customer_id, hospital_procedure_name, volume, body_part, price_with_tax, notes
) VALUES 
-- 분리 가능 패키지 (울쎄라+써마지)
(
    '55555555-5555-5555-5555-555555555555',
    '울쎄라300+써마지300',
    '300+300샷',
    '풀페이스',
    2200000,
    '분리 가능한 레이저 콤보 패키지'
),
-- 분리 불가능 패키지 (포텐자+쥬베룩)
(
    '66666666-6666-6666-6666-666666666666',
    '포텐자+쥬베룩스킨2cc',
    '1회+2cc',
    '전면부',
    1800000,
    '함께 시행하는 안티에이징 패키지'
),
-- 단일 시술
(
    '77777777-7777-7777-7777-777777777777',
    '필러(쥬비덤) 눈밑1cc',
    '1cc',
    '눈밑',
    605000,
    '단일 시술 예시'
),
-- 추가 단일 시술
(
    '77777777-7777-7777-7777-777777777777',
    '보톡스(보툴리눔) 눈가',
    '25단위',
    '눈가',
    450000,
    '보톡스 단일 시술'
) ON CONFLICT (id) DO NOTHING;

-- ========================================
-- 3. 패키지 분해 검증 및 테스트
-- ========================================

-- 패키지 분해가 제대로 되었는지 확인
/*
SELECT 
    ct.hospital_procedure_name,
    ct.is_package,
    ta.component_treatment_name,
    ta.weight_percentage,
    ta.is_package as analytics_is_package
FROM customer_treatments ct
LEFT JOIN treatment_analytics ta ON ct.id = ta.customer_treatment_id
ORDER BY ct.hospital_procedure_name, ta.weight_percentage DESC;
*/

-- ========================================
-- 🆕 4. 패키지 관련 유용한 쿼리 예시
-- ========================================

-- 예시 1: 패키지 vs 단일 시술 매출 비교
/*
SELECT 
    CASE WHEN is_package THEN '패키지' ELSE '단일시술' END as treatment_type,
    COUNT(*) as count,
    SUM(price_with_tax) as total_revenue,
    AVG(price_with_tax) as avg_price,
    ROUND(AVG(price_with_tax) / 1000) || '만원' as avg_price_display
FROM customer_treatments
GROUP BY is_package
ORDER BY total_revenue DESC;
*/

-- 예시 2: 가장 인기 있는 시술 TOP 10 (패키지 분해 기반)
/*
SELECT 
    component_treatment_name,
    total_usage_count,
    package_usage_count,
    single_usage_count,
    weighted_total_revenue,
    ROUND(weighted_avg_price / 1000) || '만원' as avg_weighted_price
FROM treatment_popularity_analysis
ORDER BY total_usage_count DESC
LIMIT 10;
*/

-- 예시 3: 패키지 성과 분석
/*
SELECT 
    package_name,
    CASE WHEN is_separable THEN '분리가능' ELSE '분리불가' END as separable_type,
    usage_count,
    unique_customers,
    ROUND(total_revenue / 1000000, 1) || '백만원' as revenue_display,
    ROUND(avg_price_per_usage / 1000) || '만원' as avg_price_display,
    component_list
FROM package_performance_analysis
ORDER BY usage_count DESC;
*/

-- 예시 4: 월별 패키지 vs 단일 시술 트렌드
/*
SELECT 
    TO_CHAR(month, 'YYYY년 MM월') as month_display,
    package_count,
    single_count,
    package_ratio_percent || '%' as package_ratio,
    ROUND(package_revenue / 1000000, 1) || '백만원' as package_revenue_display,
    ROUND(single_revenue / 1000000, 1) || '백만원' as single_revenue_display
FROM package_vs_single_analysis
WHERE month >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY month DESC;
*/

-- 예시 5: 고객별 시술 상세 (패키지 분해 포함)
/*
SELECT 
    customer_name,
    hospital_procedure_name,
    CASE WHEN is_package THEN '패키지' ELSE '단일' END as type,
    component_treatment_name,
    weight_percentage || '%' as weight,
    ROUND(weighted_price_with_tax / 1000) || '만원' as weighted_price,
    body_part,
    volume
FROM customer_treatment_details
WHERE customer_name LIKE '%김%'
ORDER BY customer_name, hospital_procedure_name, weight_percentage DESC;
*/

-- 예시 6: 유입경로별 패키지 선호도
/*
SELECT 
    acquisition_channel,
    customer_count,
    package_purchases,
    single_purchases,
    package_preference_percent || '%' as package_preference,
    ROUND(total_revenue / 1000000, 1) || '백만원' as total_revenue_display
FROM customer_acquisition_analysis
ORDER BY package_preference_percent DESC;
*/

-- ========================================
-- 5. 패키지 시스템 관리 쿼리
-- ========================================

-- 패키지 등록 예시 (관리자용)
/*
-- 새 패키지 등록
INSERT INTO treatment_packages (package_name, is_separable, description) 
VALUES ('울쎄라600+리프테라', true, '고강도 HIFU 콤보');

-- 구성 요소 등록
INSERT INTO package_components (package_id, component_name, weight_percentage, is_primary)
VALUES 
  ((SELECT id FROM treatment_packages WHERE package_name = '울쎄라600+리프테라'), '울쎄라600샷', 60.0, true),
  ((SELECT id FROM treatment_packages WHERE package_name = '울쎄라600+리프테라'), '리프테라300샷', 40.0, false);
*/

-- 패키지 수정 예시
/*
-- 패키지 설명 수정
UPDATE treatment_packages 
SET description = '수정된 패키지 설명'
WHERE package_name = '울쎄라300+써마지300';

-- 구성 요소 가중치 수정
UPDATE package_components 
SET weight_percentage = 55.0
WHERE package_id = (SELECT id FROM treatment_packages WHERE package_name = '울쎄라300+써마지300')
  AND component_name = '울쎄라300샷';
*/

-- ========================================
-- 6. 데이터 검증 및 정합성 검사
-- ========================================

-- 패키지 분해 검증
/*
SELECT 
    vr.original_treatment,
    vr.component_count,
    vr.total_weight,
    CASE WHEN vr.is_valid THEN '✅ 정상' ELSE '❌ 오류' END as validation_status
FROM validate_package_decomposition('treatment_id_here') vr;
*/

-- 패키지 구성 요소 가중치 검증
/*
SELECT 
    tp.package_name,
    SUM(pc.weight_percentage) as total_weight,
    CASE 
        WHEN SUM(pc.weight_percentage) = 100 THEN '✅ 정상'
        ELSE '❌ 가중치 합계 오류: ' || SUM(pc.weight_percentage) || '%'
    END as weight_check
FROM treatment_packages tp
LEFT JOIN package_components pc ON tp.id = pc.package_id
GROUP BY tp.id, tp.package_name
ORDER BY tp.package_name;
*/

-- 분석 데이터 정합성 검사
/*
SELECT 
    'customer_treatments' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN is_package THEN 1 END) as package_records,
    COUNT(CASE WHEN NOT is_package THEN 1 END) as single_records
UNION ALL
SELECT 
    'treatment_analytics' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN is_package THEN 1 END) as package_records,
    COUNT(CASE WHEN NOT is_package THEN 1 END) as single_records
FROM treatment_analytics;
*/

-- ========================================
-- 7. 실시간 대시보드 쿼리
-- ========================================

-- 종합 대시보드 메트릭스
/*
SELECT 
    '총 고객 수: ' || total_customers || '명' as metric1,
    '총 시술 건수: ' || total_treatments || '건' as metric2,
    '등록된 패키지: ' || total_packages || '개' as metric3,
    '이번 달 고객: ' || this_month_customers || '명' as metric4,
    '전체 매출: ' || ROUND(total_revenue / 1000000, 1) || '백만원' as metric5,
    '이번 달 매출: ' || ROUND(this_month_revenue / 1000000, 1) || '백만원' as metric6,
    '패키지 사용률: ' || package_usage_percentage || '%' as metric7
FROM dashboard_metrics;
*/

-- ========================================
-- 8. 고급 분석 쿼리
-- ========================================

-- 시술 조합 패턴 분석
/*
WITH package_combinations AS (
    SELECT 
        ta.original_treatment_name,
        STRING_AGG(ta.component_treatment_name, ' + ' ORDER BY ta.weight_percentage DESC) as combination,
        COUNT(*) as frequency
    FROM treatment_analytics ta
    WHERE ta.is_package = true
    GROUP BY ta.original_treatment_name
)
SELECT 
    combination,
    frequency,
    ROUND(frequency * 100.0 / SUM(frequency) OVER(), 1) || '%' as percentage
FROM package_combinations
ORDER BY frequency DESC;
*/

-- 고객 세그먼트 분석 (패키지 선호도 기준)
/*
WITH customer_preferences AS (
    SELECT 
        c.id,
        c.name,
        c.acquisition_channel,
        COUNT(ct.id) as total_treatments,
        COUNT(CASE WHEN ct.is_package THEN 1 END) as package_treatments,
        ROUND(
            COUNT(CASE WHEN ct.is_package THEN 1 END) * 100.0 / 
            NULLIF(COUNT(ct.id), 0), 1
        ) as package_preference_rate
    FROM customers c
    LEFT JOIN customer_treatments ct ON c.id = ct.customer_id
    GROUP BY c.id, c.name, c.acquisition_channel
)
SELECT 
    CASE 
        WHEN package_preference_rate >= 80 THEN '패키지 선호'
        WHEN package_preference_rate >= 50 THEN '패키지 중간'
        WHEN package_preference_rate > 0 THEN '단일+패키지 혼합'
        ELSE '단일 시술만'
    END as customer_segment,
    COUNT(*) as customer_count,
    AVG(total_treatments) as avg_treatments_per_customer,
    AVG(package_preference_rate) as avg_package_preference
FROM customer_preferences
WHERE total_treatments > 0
GROUP BY 
    CASE 
        WHEN package_preference_rate >= 80 THEN '패키지 선호'
        WHEN package_preference_rate >= 50 THEN '패키지 중간'
        WHEN package_preference_rate > 0 THEN '단일+패키지 혼합'
        ELSE '단일 시술만'
    END
ORDER BY customer_count DESC;
*/

-- ========================================
-- 완료 메시지
-- ========================================

DO $$
BEGIN
    RAISE NOTICE '✅ 샘플 데이터 + 패키지 시스템 예시 생성 완료!';
    RAISE NOTICE '📦 패키지 샘플: 울쎄라+써마지, 포텐자+쥬베룩';
    RAISE NOTICE '📊 분석 쿼리: 패키지 성과, 트렌드, 고객 세그먼트';
    RAISE NOTICE '🔍 검증 쿼리: 데이터 정합성, 가중치 검사';
    RAISE NOTICE '🎯 시스템 구축 완료! 프론트엔드 개발 준비 완료';
END $$; 