-- =====================================================
-- Phase 2.4 - Step 3: guide_languages 테이블 생성
-- =====================================================

-- 1. 기존 guide_languages 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'guide_languages' 
ORDER BY ordinal_position;

-- 2. 필요한 테이블들 존재 확인
SELECT 
    'guides' as table_name,
    COUNT(*) as record_count
FROM guides
UNION ALL
SELECT 
    'languages' as table_name,
    COUNT(*) as record_count
FROM languages;

-- 3. 가이드-언어 연결 테이블 생성 (다대다, 레벨 포함)
CREATE TABLE IF NOT EXISTS guide_languages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guide_id UUID NOT NULL REFERENCES guides(id) ON DELETE CASCADE,
    language_id UUID NOT NULL REFERENCES languages(id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20) NOT NULL CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'native')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, language_id)
);

-- 4. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_guide_languages_guide_id ON guide_languages(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_languages_language_id ON guide_languages(language_id);
CREATE INDEX IF NOT EXISTS idx_guide_languages_proficiency ON guide_languages(proficiency_level);

-- 5. 결과 확인 쿼리
SELECT 
    'Step 3 완료: guide_languages 테이블 생성됨' as status,
    COUNT(*) as total_guide_languages
FROM guide_languages;

-- 6. 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'guide_languages' 
ORDER BY ordinal_position;

-- 7. 외래키 제약조건 확인
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = 'guide_languages';

-- 8. 샘플 데이터 확인 (현재는 비어있음)
SELECT 
    gl.id,
    g.nickname as guide_name,
    l.name as language_name,
    gl.proficiency_level
FROM guide_languages gl
JOIN guides g ON gl.guide_id = g.id
JOIN languages l ON gl.language_id = l.id
LIMIT 5; 