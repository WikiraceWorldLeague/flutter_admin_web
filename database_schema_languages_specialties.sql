-- =====================================================
-- Phase 2.3: 언어/전문분야 데이터베이스 스키마 생성
-- =====================================================

-- 1. 언어 테이블 생성
CREATE TABLE IF NOT EXISTS languages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE, -- ISO 639-1 코드
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 전문분야 테이블 생성
CREATE TABLE IF NOT EXISTS specialties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL, -- 의료, 웰니스, 기타 등
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 가이드-언어 연결 테이블 (다대다, 레벨 포함)
CREATE TABLE IF NOT EXISTS guide_languages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guide_id UUID NOT NULL REFERENCES guides(id) ON DELETE CASCADE,
    language_id UUID NOT NULL REFERENCES languages(id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20) NOT NULL CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'native')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, language_id)
);

-- 4. 가이드-전문분야 연결 테이블 (다대다)
CREATE TABLE IF NOT EXISTS guide_specialties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guide_id UUID NOT NULL REFERENCES guides(id) ON DELETE CASCADE,
    specialty_id UUID NOT NULL REFERENCES specialties(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, specialty_id)
);

-- 5. guides 테이블에 성과 관련 컬럼 추가
ALTER TABLE guides 
ADD COLUMN IF NOT EXISTS rating NUMERIC(3,2) DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS total_reservations INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS completed_reservations INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS cancellation_rate NUMERIC(5,2) DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS last_reservation_at TIMESTAMP WITH TIME ZONE;

-- =====================================================
-- 초기 데이터 삽입
-- =====================================================

-- 6. 기본 언어 데이터 삽입
INSERT INTO languages (name, code, sort_order) VALUES
('한국어', 'ko', 1),
('영어', 'en', 2),
('중국어(간체)', 'zh-CN', 3),
('중국어(번체)', 'zh-TW', 4),
('일본어', 'ja', 5),
('태국어', 'th', 6),
('베트남어', 'vi', 7),
('러시아어', 'ru', 8)
ON CONFLICT (code) DO NOTHING;

-- 7. 기본 전문분야 데이터 삽입
INSERT INTO specialties (name, category, sort_order) VALUES
('성형외과', '의료', 1),
('피부과', '의료', 2),
('치과', '의료', 3),
('안과', '의료', 4),
('건강검진', '의료', 5),
('재활치료', '의료', 6),
('한방치료', '의료', 7),
('기타', '기타', 8)
ON CONFLICT DO NOTHING;

-- =====================================================
-- 인덱스 생성 (성능 최적화)
-- =====================================================

-- 8. 성능 최적화를 위한 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_languages_active_sort ON languages(is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_specialties_active_sort ON specialties(is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_guide_languages_guide_id ON guide_languages(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_languages_language_id ON guide_languages(language_id);
CREATE INDEX IF NOT EXISTS idx_guide_specialties_guide_id ON guide_specialties(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_specialties_specialty_id ON guide_specialties(specialty_id);
CREATE INDEX IF NOT EXISTS idx_guides_rating ON guides(rating DESC);
CREATE INDEX IF NOT EXISTS idx_guides_total_reservations ON guides(total_reservations DESC);
CREATE INDEX IF NOT EXISTS idx_guides_last_reservation ON guides(last_reservation_at DESC);

-- =====================================================
-- 샘플 데이터 생성 (기존 가이드들에 언어/전문분야 할당)
-- =====================================================

-- 9. 기존 가이드들에 랜덤 언어/전문분야 할당 (테스트용)
DO $$
DECLARE
    guide_record RECORD;
    korean_id UUID;
    english_id UUID;
    plastic_surgery_id UUID;
    dermatology_id UUID;
BEGIN
    -- 언어 ID 조회
    SELECT id INTO korean_id FROM languages WHERE code = 'ko';
    SELECT id INTO english_id FROM languages WHERE code = 'en';
    
    -- 전문분야 ID 조회
    SELECT id INTO plastic_surgery_id FROM specialties WHERE name = '성형외과';
    SELECT id INTO dermatology_id FROM specialties WHERE name = '피부과';
    
    -- 기존 가이드들에 언어/전문분야 할당
    FOR guide_record IN SELECT id FROM guides LIMIT 10 LOOP
        -- 모든 가이드에 한국어 원어민 레벨 할당
        INSERT INTO guide_languages (guide_id, language_id, proficiency_level)
        VALUES (guide_record.id, korean_id, 'native')
        ON CONFLICT (guide_id, language_id) DO NOTHING;
        
        -- 50% 확률로 영어 중급 레벨 할당
        IF random() > 0.5 THEN
            INSERT INTO guide_languages (guide_id, language_id, proficiency_level)
            VALUES (guide_record.id, english_id, 'intermediate')
            ON CONFLICT (guide_id, language_id) DO NOTHING;
        END IF;
        
        -- 모든 가이드에 성형외과 전문분야 할당
        INSERT INTO guide_specialties (guide_id, specialty_id)
        VALUES (guide_record.id, plastic_surgery_id)
        ON CONFLICT (guide_id, specialty_id) DO NOTHING;
        
        -- 30% 확률로 피부과도 추가
        IF random() > 0.7 THEN
            INSERT INTO guide_specialties (guide_id, specialty_id)
            VALUES (guide_record.id, dermatology_id)
            ON CONFLICT (guide_id, specialty_id) DO NOTHING;
        END IF;
        
        -- 성과 데이터 업데이트 (랜덤 값)
        UPDATE guides 
        SET 
            rating = 4.0 + (random() * 1.0), -- 4.0 ~ 5.0
            total_reservations = floor(random() * 50 + 5)::INTEGER, -- 5 ~ 55
            completed_reservations = floor(random() * 45 + 3)::INTEGER, -- 3 ~ 48
            cancellation_rate = random() * 10, -- 0 ~ 10%
            last_reservation_at = NOW() - (random() * INTERVAL '30 days')
        WHERE id = guide_record.id;
    END LOOP;
END $$;

-- =====================================================
-- 뷰 생성 (조인 쿼리 최적화)
-- =====================================================

-- 10. 가이드 상세 정보 뷰 생성 (언어/전문분야 포함)
CREATE OR REPLACE VIEW guide_details AS
SELECT 
    g.id,
    g.nickname,
    g.passport_first_name,
    g.nationality,
    g.gender,
    g.phone,
    g.email,
    g.status,
    g.rating,
    g.total_reservations,
    g.completed_reservations,
    g.cancellation_rate,
    g.last_reservation_at,
    g.created_at,
    g.updated_at,
    -- 언어 정보 (JSON 배열)
    COALESCE(
        json_agg(
            DISTINCT jsonb_build_object(
                'id', l.id,
                'name', l.name,
                'code', l.code,
                'proficiency_level', gl.proficiency_level
            )
        ) FILTER (WHERE l.id IS NOT NULL),
        '[]'::json
    ) AS languages,
    -- 전문분야 정보 (JSON 배열)
    COALESCE(
        json_agg(
            DISTINCT jsonb_build_object(
                'id', s.id,
                'name', s.name,
                'category', s.category
            )
        ) FILTER (WHERE s.id IS NOT NULL),
        '[]'::json
    ) AS specialties
FROM guides g
LEFT JOIN guide_languages gl ON g.id = gl.guide_id
LEFT JOIN languages l ON gl.language_id = l.id AND l.is_active = true
LEFT JOIN guide_specialties gs ON g.id = gs.guide_id
LEFT JOIN specialties s ON gs.specialty_id = s.id AND s.is_active = true
GROUP BY g.id, g.nickname, g.passport_first_name, g.nationality, g.gender, 
         g.phone, g.email, g.status, g.rating, g.total_reservations, 
         g.completed_reservations, g.cancellation_rate, g.last_reservation_at,
         g.created_at, g.updated_at;

-- =====================================================
-- 완료 메시지
-- =====================================================
SELECT 'Phase 2.3 언어/전문분야 스키마 생성 완료!' as status; 