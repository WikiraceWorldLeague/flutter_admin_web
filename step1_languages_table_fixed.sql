-- =====================================================
-- Phase 2.4 - Step 1 (수정): languages 테이블 생성/수정
-- =====================================================

-- 1. 기존 languages 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'languages' 
ORDER BY ordinal_position;

-- 2. languages 테이블이 없으면 생성, 있으면 컬럼 추가
CREATE TABLE IF NOT EXISTS languages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 필요한 컬럼들 추가 (없으면 추가)
ALTER TABLE languages 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 0;

-- 4. 기본 언어 데이터 삽입 (8개 언어)
INSERT INTO languages (name, code, sort_order) VALUES
('한국어', 'ko', 1),
('영어', 'en', 2),
('중국어(간체)', 'zh-CN', 3),
('중국어(번체)', 'zh-TW', 4),
('일본어', 'ja', 5),
('태국어', 'th', 6),
('베트남어', 'vi', 7),
('러시아어', 'ru', 8)
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    sort_order = EXCLUDED.sort_order;

-- 5. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_languages_active_sort ON languages(is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_languages_code ON languages(code);

-- 6. 결과 확인 쿼리
SELECT 
    'Step 1 완료: languages 테이블 수정됨' as status,
    COUNT(*) as total_languages
FROM languages;

-- 7. 최종 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'languages' 
ORDER BY ordinal_position;

-- 8. 데이터 확인
SELECT id, name, code, is_active, sort_order 
FROM languages 
ORDER BY sort_order; 