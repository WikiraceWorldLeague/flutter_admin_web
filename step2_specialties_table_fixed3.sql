-- =====================================================
-- Phase 2.4 - Step 2 (최종수정): specialties 테이블 생성/수정
-- =====================================================

-- 1. 기존 specialties 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'specialties' 
ORDER BY ordinal_position;

-- 2. specialties 테이블이 없으면 생성
CREATE TABLE IF NOT EXISTS specialties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 필요한 컬럼들 추가 (없으면 추가)
ALTER TABLE specialties 
ADD COLUMN IF NOT EXISTS category VARCHAR(50) DEFAULT '의료',
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 0;

-- 4. 기본 전문분야 데이터 삽입 (8개 전문분야) - code 포함
INSERT INTO specialties (name, code, category, sort_order) VALUES
('성형외과', 'plastic', '의료', 1),
('피부과', 'derma', '의료', 2),
('치과', 'dental', '의료', 3),
('안과', 'eye', '의료', 4),
('건강검진', 'checkup', '의료', 5),
('재활치료', 'rehab', '의료', 6),
('한방치료', 'oriental', '의료', 7),
('기타', 'other', '기타', 8)
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    sort_order = EXCLUDED.sort_order;

-- 5. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_specialties_active_sort ON specialties(is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_specialties_category ON specialties(category);
CREATE INDEX IF NOT EXISTS idx_specialties_code ON specialties(code);

-- 6. 결과 확인 쿼리
SELECT 
    'Step 2 완료: specialties 테이블 수정됨' as status,
    COUNT(*) as total_specialties
FROM specialties;

-- 7. 최종 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'specialties' 
ORDER BY ordinal_position;

-- 8. 데이터 확인
SELECT id, name, code, category, is_active, sort_order 
FROM specialties 
ORDER BY sort_order;

-- 9. 카테고리별 분포 확인
SELECT 
    category,
    COUNT(*) as count
FROM specialties 
GROUP BY category 
ORDER BY category; 