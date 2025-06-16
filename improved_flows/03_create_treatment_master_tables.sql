-- 시술 관련 마스터 테이블들 생성
-- 실행 순서: 3번째

-- 1. 시술 대분류 테이블
CREATE TABLE IF NOT EXISTS treatment_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL, -- 예: 단일, 복합, 레이저 등
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 시술 중분류 테이블
CREATE TABLE IF NOT EXISTS treatment_subcategories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES treatment_categories(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL, -- 예: 필러, 보톡스, 레이저토닝 등
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(category_id, name)
);

-- 3. 단일 시술명 테이블
CREATE TABLE IF NOT EXISTS treatment_procedures (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID REFERENCES treatment_subcategories(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL, -- 예: 필러(쥬비덤), 보톡스(보툴리눔 톡신) 등
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(subcategory_id, name)
);

-- 4. 시술 효과 테이블
CREATE TABLE IF NOT EXISTS treatment_effects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) UNIQUE NOT NULL, -- 예: 볼륨 개선, 꺼짐 부위 채움, 주름 개선 등
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 초기 데이터 삽입 (예시)
INSERT INTO treatment_categories (name, description) VALUES 
('단일', '단일 시술'),
('복합', '복합 시술'),
('레이저', '레이저 시술')
ON CONFLICT (name) DO NOTHING;

INSERT INTO treatment_subcategories (category_id, name, description) VALUES 
((SELECT id FROM treatment_categories WHERE name = '단일'), '필러', '히알루론산 필러'),
((SELECT id FROM treatment_categories WHERE name = '단일'), '보톡스', '보툴리눔 톡신'),
((SELECT id FROM treatment_categories WHERE name = '레이저'), '레이저토닝', '레이저 토닝 시술')
ON CONFLICT (category_id, name) DO NOTHING;

INSERT INTO treatment_procedures (subcategory_id, name, description) VALUES 
((SELECT id FROM treatment_subcategories WHERE name = '필러'), '필러(쥬비덤)', '쥬비덤 히알루론산 필러'),
((SELECT id FROM treatment_subcategories WHERE name = '보톡스'), '보톡스(보툴리눔)', '보툴리눔 톡신 주사')
ON CONFLICT (subcategory_id, name) DO NOTHING;

INSERT INTO treatment_effects (name, description) VALUES 
('볼륨 개선', '얼굴 볼륨 개선 효과'),
('꺼짐 부위 채움', '꺼진 부위를 채우는 효과'),
('주름 개선', '주름을 개선하는 효과'),
('리프팅', '얼굴 리프팅 효과')
ON CONFLICT (name) DO NOTHING;

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_treatment_subcategories_category_id ON treatment_subcategories(category_id);
CREATE INDEX IF NOT EXISTS idx_treatment_procedures_subcategory_id ON treatment_procedures(subcategory_id); 