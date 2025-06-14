-- =====================================================
-- Phase 2.4 - Step 4 (최종수정): guide_specialties 테이블 생성/수정
-- =====================================================

-- 1. 기존 guide_specialties 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'guide_specialties' 
ORDER BY ordinal_position;

-- 2. 필요한 테이블들 존재 확인
SELECT 
    'guides' as table_name,
    COUNT(*) as record_count
FROM guides
UNION ALL
SELECT 
    'specialties' as table_name,
    COUNT(*) as record_count
FROM specialties;

-- 3. 가이드-전문분야 연결 테이블 생성 (없으면)
CREATE TABLE IF NOT EXISTS guide_specialties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guide_id UUID NOT NULL REFERENCES guides(id) ON DELETE CASCADE,
    specialty_id UUID NOT NULL REFERENCES specialties(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 필요한 컬럼들 추가 (없으면 추가)
ALTER TABLE guide_specialties 
ADD COLUMN IF NOT EXISTS experience_level VARCHAR(20) DEFAULT 'beginner',
ADD COLUMN IF NOT EXISTS years_of_experience INTEGER DEFAULT 0;

-- 5. experience_level에 CHECK 제약조건 추가 (없으면)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.constraint_column_usage ccu
            ON tc.constraint_name = ccu.constraint_name
        WHERE tc.table_name = 'guide_specialties' 
        AND tc.constraint_type = 'CHECK'
        AND tc.constraint_name LIKE '%experience_level%'
    ) THEN
        ALTER TABLE guide_specialties 
        ADD CONSTRAINT guide_specialties_experience_level_check 
        CHECK (experience_level IN ('beginner', 'intermediate', 'advanced', 'expert'));
    END IF;
END $$;

-- 6. UNIQUE 제약조건 추가 (없으면)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE table_name = 'guide_specialties' 
        AND constraint_type = 'UNIQUE' 
        AND constraint_name LIKE '%guide_id%specialty_id%'
    ) THEN
        ALTER TABLE guide_specialties ADD CONSTRAINT guide_specialties_guide_specialty_unique UNIQUE (guide_id, specialty_id);
    END IF;
END $$;

-- 7. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_guide_specialties_guide_id ON guide_specialties(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_specialties_specialty_id ON guide_specialties(specialty_id);
CREATE INDEX IF NOT EXISTS idx_guide_specialties_experience ON guide_specialties(experience_level);

-- 8. 결과 확인 쿼리
SELECT 
    'Step 4 완료: guide_specialties 테이블 수정됨' as status,
    COUNT(*) as total_guide_specialties
FROM guide_specialties;

-- 9. 최종 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'guide_specialties' 
ORDER BY ordinal_position;

-- 10. 제약조건 확인
SELECT 
    tc.constraint_name,
    tc.constraint_type,
    tc.table_name
FROM information_schema.table_constraints tc
WHERE tc.table_name = 'guide_specialties'
ORDER BY tc.constraint_type;

-- 11. 외래키 제약조건 확인
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
    AND tc.table_name = 'guide_specialties';

-- 12. 샘플 데이터 확인 (현재는 비어있음)
SELECT 
    gs.id,
    g.nickname as guide_name,
    s.name as specialty_name,
    gs.experience_level,
    gs.years_of_experience
FROM guide_specialties gs
JOIN guides g ON gs.guide_id = g.id
JOIN specialties s ON gs.specialty_id = s.id
LIMIT 5; 