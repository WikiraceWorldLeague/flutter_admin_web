-- =====================================================
-- Phase 2.4 - Step 5 (수정): guides 테이블 추가 컬럼
-- =====================================================

-- 1. 기존 guides 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'guides' 
ORDER BY ordinal_position;

-- 2. guides 테이블 데이터 확인
SELECT 
    'guides' as table_name,
    COUNT(*) as record_count
FROM guides;

-- 3. guides 테이블에 성과 관련 컬럼 추가 (없으면 추가)
ALTER TABLE guides 
ADD COLUMN IF NOT EXISTS rating DECIMAL(3,2) DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS completed_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS total_reservations INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS completion_rate DECIMAL(5,2) DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS last_active_date TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS profile_image_url TEXT,
ADD COLUMN IF NOT EXISTS bio TEXT,
ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT false;

-- 4. rating 컬럼에 CHECK 제약조건 추가 (없으면)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        WHERE tc.table_name = 'guides' 
        AND tc.constraint_type = 'CHECK'
        AND tc.constraint_name LIKE '%rating%'
    ) THEN
        ALTER TABLE guides 
        ADD CONSTRAINT guides_rating_check 
        CHECK (rating >= 0 AND rating <= 5);
    END IF;
END $$;

-- 5. completion_rate 컬럼에 CHECK 제약조건 추가 (없으면)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        WHERE tc.table_name = 'guides' 
        AND tc.constraint_type = 'CHECK'
        AND tc.constraint_name LIKE '%completion_rate%'
    ) THEN
        ALTER TABLE guides 
        ADD CONSTRAINT guides_completion_rate_check 
        CHECK (completion_rate >= 0 AND completion_rate <= 100);
    END IF;
END $$;

-- 6. 기존 데이터가 있다면 기본값으로 초기화 (rating이 0인 경우만)
UPDATE guides 
SET 
    rating = 4.0 + (RANDOM() * 1.0), -- 4.0~5.0 사이 랜덤
    total_reservations = FLOOR(RANDOM() * 50) + 20, -- 20~69 사이
    last_active_date = NOW() - INTERVAL '1 day' * FLOOR(RANDOM() * 30) -- 최근 30일 내
WHERE rating = 0.0;

-- 7. completed_count 설정 (total_reservations보다 작거나 같게)
UPDATE guides 
SET completed_count = FLOOR(total_reservations * (0.7 + RANDOM() * 0.3)) -- 70%~100% 완료율
WHERE completed_count = 0;

-- 8. completion_rate 계산 (완료율) - 올바른 계산
UPDATE guides 
SET completion_rate = CASE 
    WHEN total_reservations > 0 THEN 
        ROUND((completed_count::DECIMAL / total_reservations::DECIMAL) * 100, 2)
    ELSE 0.0 
END
WHERE completion_rate = 0.0 OR completion_rate > 100;

-- 9. 데이터 검증 및 수정 (혹시 모를 오류 방지)
UPDATE guides 
SET 
    completed_count = LEAST(completed_count, total_reservations),
    completion_rate = CASE 
        WHEN total_reservations > 0 THEN 
            ROUND((LEAST(completed_count, total_reservations)::DECIMAL / total_reservations::DECIMAL) * 100, 2)
        ELSE 0.0 
    END
WHERE completed_count > total_reservations OR completion_rate > 100;

-- 10. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_guides_rating ON guides(rating DESC);
CREATE INDEX IF NOT EXISTS idx_guides_completion_rate ON guides(completion_rate DESC);
CREATE INDEX IF NOT EXISTS idx_guides_featured ON guides(is_featured);
CREATE INDEX IF NOT EXISTS idx_guides_last_active ON guides(last_active_date DESC);

-- 11. 결과 확인 쿼리
SELECT 
    'Step 5 완료: guides 테이블 컬럼 추가됨' as status,
    COUNT(*) as total_guides
FROM guides;

-- 12. 업데이트된 guides 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'guides' 
ORDER BY ordinal_position;

-- 13. 제약조건 확인
SELECT 
    tc.constraint_name,
    tc.constraint_type,
    tc.table_name
FROM information_schema.table_constraints tc
WHERE tc.table_name = 'guides'
AND tc.constraint_type = 'CHECK'
ORDER BY tc.constraint_name;

-- 14. 샘플 데이터 확인
SELECT 
    id,
    nickname,
    status,
    rating,
    completed_count,
    total_reservations,
    completion_rate,
    last_active_date,
    is_featured
FROM guides 
ORDER BY rating DESC
LIMIT 5;

-- 15. 통계 확인
SELECT 
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(completion_rate), 2) as avg_completion_rate,
    COUNT(*) as total_guides,
    COUNT(CASE WHEN is_featured THEN 1 END) as featured_guides,
    COUNT(CASE WHEN rating >= 4.5 THEN 1 END) as high_rated_guides
FROM guides;

-- 16. 데이터 무결성 확인
SELECT 
    COUNT(*) as total_guides,
    COUNT(CASE WHEN completed_count > total_reservations THEN 1 END) as invalid_completion_count,
    COUNT(CASE WHEN completion_rate > 100 THEN 1 END) as invalid_completion_rate,
    COUNT(CASE WHEN rating > 5 OR rating < 0 THEN 1 END) as invalid_rating
FROM guides; 