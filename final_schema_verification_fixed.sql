-- =====================================================
-- Phase 2.4 최종 검증: 전체 스키마 적용 완료 확인
-- =====================================================

-- 🎯 1. 모든 테이블 존재 확인
SELECT 
    '📋 테이블 존재 확인' as check_type,
    expected_tables.table_name,
    CASE WHEN t.table_name IS NOT NULL THEN '✅ 존재' ELSE '❌ 없음' END as status
FROM (
    VALUES 
    ('guides'),
    ('languages'), 
    ('specialties'),
    ('guide_languages'),
    ('guide_specialties')
) AS expected_tables(table_name)
LEFT JOIN information_schema.tables t 
    ON t.table_name = expected_tables.table_name 
    AND t.table_schema = 'public'
ORDER BY expected_tables.table_name;

-- 🔢 2. 각 테이블 데이터 수 확인
SELECT '📊 데이터 수 확인' as check_type, 'languages' as table_name, COUNT(*) as count FROM languages
UNION ALL
SELECT '📊 데이터 수 확인', 'specialties', COUNT(*) FROM specialties
UNION ALL  
SELECT '📊 데이터 수 확인', 'guides', COUNT(*) FROM guides
UNION ALL
SELECT '📊 데이터 수 확인', 'guide_languages', COUNT(*) FROM guide_languages
UNION ALL
SELECT '📊 데이터 수 확인', 'guide_specialties', COUNT(*) FROM guide_specialties
ORDER BY table_name;

-- 🔗 3. 외래키 관계 확인
SELECT 
    '🔗 외래키 관계 확인' as check_type,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS references_table,
    ccu.column_name AS references_column,
    '✅ 연결됨' as status
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name IN ('guide_languages', 'guide_specialties')
ORDER BY tc.table_name, kcu.column_name;

-- 📋 4. guides 테이블 새 컬럼 확인
SELECT 
    '📋 guides 새 컬럼 확인' as check_type,
    column_name,
    data_type,
    CASE WHEN column_name IN (
        'rating', 'completed_count', 'total_reservations', 
        'completion_rate', 'last_active_date', 'profile_image_url', 
        'bio', 'is_featured'
    ) THEN '✅ 새 컬럼' ELSE '기존 컬럼' END as column_status
FROM information_schema.columns 
WHERE table_name = 'guides'
AND column_name IN (
    'rating', 'completed_count', 'total_reservations', 
    'completion_rate', 'last_active_date', 'profile_image_url', 
    'bio', 'is_featured'
)
ORDER BY column_name;

-- 🎯 5. 언어 마스터 데이터 확인
SELECT 
    '🌐 언어 마스터 데이터' as check_type,
    name as language_name,
    code,
    sort_order,
    '✅ 등록됨' as status
FROM languages 
ORDER BY sort_order;

-- 🏥 6. 전문분야 마스터 데이터 확인
SELECT 
    '🏥 전문분야 마스터 데이터' as check_type,
    name as specialty_name,
    code,
    category,
    sort_order,
    '✅ 등록됨' as status
FROM specialties 
ORDER BY sort_order;

-- 📈 7. guides 성과 데이터 샘플 확인
SELECT 
    '📈 가이드 성과 데이터' as check_type,
    nickname,
    rating,
    completed_count,
    total_reservations,
    completion_rate,
    CASE 
        WHEN rating BETWEEN 0 AND 5 AND completion_rate BETWEEN 0 AND 100 
        THEN '✅ 정상' 
        ELSE '❌ 오류' 
    END as data_status
FROM guides 
ORDER BY rating DESC
LIMIT 3;

-- 🔍 8. 인덱스 생성 확인
SELECT 
    '🔍 인덱스 확인' as check_type,
    schemaname,
    tablename,
    indexname,
    '✅ 생성됨' as status
FROM pg_indexes 
WHERE tablename IN ('languages', 'specialties', 'guide_languages', 'guide_specialties', 'guides')
AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;

-- ✅ 9. 최종 요약 통계
SELECT 
    '🎉 최종 요약' as summary_type,
    '총 테이블 수' as metric,
    COUNT(DISTINCT table_name)::text as value
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('guides', 'languages', 'specialties', 'guide_languages', 'guide_specialties')

UNION ALL

SELECT 
    '🎉 최종 요약',
    '총 언어 수',
    COUNT(*)::text
FROM languages

UNION ALL

SELECT 
    '🎉 최종 요약',
    '총 전문분야 수',
    COUNT(*)::text
FROM specialties

UNION ALL

SELECT 
    '🎉 최종 요약',
    '총 가이드 수',
    COUNT(*)::text
FROM guides

UNION ALL

SELECT 
    '🎉 최종 요약',
    '평균 가이드 평점',
    ROUND(AVG(rating), 2)::text
FROM guides

UNION ALL

SELECT 
    '🎉 최종 요약',
    '평균 완료율(%)',
    ROUND(AVG(completion_rate), 1)::text
FROM guides;

-- 🚀 10. 다음 단계 준비 상태 확인
SELECT 
    '🚀 다음 단계 준비' as next_step,
    CASE 
        WHEN (SELECT COUNT(*) FROM languages) >= 8 
        AND (SELECT COUNT(*) FROM specialties) >= 8
        AND (SELECT COUNT(*) FROM guides) > 0
        THEN '✅ 가이드 등록 폼 개발 준비 완료'
        ELSE '❌ 추가 설정 필요'
    END as readiness_status,
    '언어/전문분야 마스터 데이터 완비, 가이드 테이블 확장 완료' as details; 