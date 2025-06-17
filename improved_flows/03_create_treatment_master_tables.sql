-- 시술 관련 마스터 테이블들 생성 + 패키지 관리 시스템
-- 실행 순서: 3번째

-- ========================================
-- 1. 기본 시술 마스터 테이블들
-- ========================================

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

-- ========================================
-- 🆕 2. 패키지 관리 시스템 테이블들
-- ========================================

-- 5. 패키지 정의 테이블
CREATE TABLE IF NOT EXISTS treatment_packages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    package_name VARCHAR(255) UNIQUE NOT NULL, -- 예: "울쎄라300+써마지300"
    is_separable BOOLEAN DEFAULT false NOT NULL, -- 분리 가능 여부
    description TEXT,
    naming_rule VARCHAR(500), -- 명명 규칙 (예: "[기기명]+[용량]+[부위]")
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. 패키지 구성 요소 테이블
CREATE TABLE IF NOT EXISTS package_components (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    package_id UUID REFERENCES treatment_packages(id) ON DELETE CASCADE NOT NULL,
    component_name VARCHAR(255) NOT NULL, -- 구성 시술명
    weight_percentage NUMERIC(5,2) DEFAULT 100.00 NOT NULL, -- 패키지에서 차지하는 비중 (%)
    is_primary BOOLEAN DEFAULT false, -- 주요 시술 여부
    notes TEXT, -- 특이사항
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT check_weight_percentage CHECK (weight_percentage > 0 AND weight_percentage <= 100)
);

-- 7. 분석용 시술 분해 테이블
CREATE TABLE IF NOT EXISTS treatment_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_treatment_id UUID, -- customer_treatments 테이블과 연결 (나중에 FK 설정)
    original_treatment_name VARCHAR(500) NOT NULL, -- 원본 시술명 (패키지 또는 단일)
    component_treatment_name VARCHAR(255) NOT NULL, -- 분해된 구성 시술명
    component_category VARCHAR(100), -- 구성 시술 카테고리
    weight_percentage NUMERIC(5,2) DEFAULT 100.00, -- 비중
    is_package BOOLEAN DEFAULT false, -- 패키지 여부
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 3. 인덱스 생성
-- ========================================

-- 기본 마스터 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_treatment_subcategories_category_id ON treatment_subcategories(category_id);
CREATE INDEX IF NOT EXISTS idx_treatment_procedures_subcategory_id ON treatment_procedures(subcategory_id);

-- 패키지 관련 인덱스
CREATE INDEX IF NOT EXISTS idx_package_components_package_id ON package_components(package_id);
CREATE INDEX IF NOT EXISTS idx_package_components_component_name ON package_components(component_name);
CREATE INDEX IF NOT EXISTS idx_treatment_analytics_customer_treatment_id ON treatment_analytics(customer_treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_analytics_component_name ON treatment_analytics(component_treatment_name);
CREATE INDEX IF NOT EXISTS idx_treatment_analytics_is_package ON treatment_analytics(is_package);

-- ========================================
-- 🤖 4. 자동 분해 트리거 시스템
-- ========================================

-- 시술 자동 분해 함수
CREATE OR REPLACE FUNCTION auto_decompose_treatment()
RETURNS TRIGGER AS $$
BEGIN
    -- 기존 분석 데이터 삭제 (UPDATE 시)
    IF TG_OP = 'UPDATE' THEN
        DELETE FROM treatment_analytics WHERE customer_treatment_id = NEW.id;
    END IF;
    
    -- 패키지인지 확인
    IF EXISTS (SELECT 1 FROM treatment_packages WHERE package_name = NEW.hospital_procedure_name) THEN
        -- 패키지인 경우: 구성 요소들을 분석 테이블에 삽입
        INSERT INTO treatment_analytics (
            customer_treatment_id, 
            original_treatment_name, 
            component_treatment_name, 
            weight_percentage, 
            is_package
        )
        SELECT 
            NEW.id,
            NEW.hospital_procedure_name,
            pc.component_name,
            pc.weight_percentage,
            true
        FROM treatment_packages tp
        JOIN package_components pc ON tp.id = pc.package_id
        WHERE tp.package_name = NEW.hospital_procedure_name;
    ELSE
        -- 단일 시술인 경우: 그대로 분석 테이블에 삽입
        INSERT INTO treatment_analytics (
            customer_treatment_id, 
            original_treatment_name, 
            component_treatment_name, 
            weight_percentage, 
            is_package
        )
        VALUES (
            NEW.id, 
            NEW.hospital_procedure_name, 
            NEW.hospital_procedure_name, 
            100.00, 
            false
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거는 customer_treatments 테이블 생성 후 적용됩니다 (04번 스크립트에서)

-- ========================================
-- 5. 초기 데이터 삽입
-- ========================================

-- 기본 시술 카테고리
INSERT INTO treatment_categories (name, description) VALUES 
('단일시술', '단일 시술'),
('복합시술', '복합 시술'),
('레이저시술', '레이저 시술'),
('주사시술', '주사 시술')
ON CONFLICT (name) DO NOTHING;

-- 시술 중분류
INSERT INTO treatment_subcategories (category_id, name, description) VALUES 
((SELECT id FROM treatment_categories WHERE name = '주사시술'), '필러', '히알루론산 필러'),
((SELECT id FROM treatment_categories WHERE name = '주사시술'), '보톡스', '보툴리눔 톡신'),
((SELECT id FROM treatment_categories WHERE name = '레이저시술'), '울쎄라', '울쎄라 HIFU'),
((SELECT id FROM treatment_categories WHERE name = '레이저시술'), '써마지', '써마지 RF'),
((SELECT id FROM treatment_categories WHERE name = '레이저시술'), '포텐자', '포텐자 마이크로니들')
ON CONFLICT (category_id, name) DO NOTHING;

-- 단일 시술명
INSERT INTO treatment_procedures (subcategory_id, name, description) VALUES 
((SELECT id FROM treatment_subcategories WHERE name = '필러'), '필러(쥬비덤)', '쥬비덤 히알루론산 필러'),
((SELECT id FROM treatment_subcategories WHERE name = '보톡스'), '보톡스(보툴리눔)', '보툴리눔 톡신 주사'),
((SELECT id FROM treatment_subcategories WHERE name = '울쎄라'), '울쎄라300샷', '울쎄라 300샷'),
((SELECT id FROM treatment_subcategories WHERE name = '써마지'), '써마지300샷', '써마지 300샷'),
((SELECT id FROM treatment_subcategories WHERE name = '포텐자'), '포텐자', '포텐자 마이크로니들')
ON CONFLICT (subcategory_id, name) DO NOTHING;

-- 시술 효과
INSERT INTO treatment_effects (name, description) VALUES 
('볼륨개선', '얼굴 볼륨 개선 효과'),
('꺼짐부위채움', '꺼진 부위를 채우는 효과'),
('주름개선', '주름을 개선하는 효과'),
('리프팅', '얼굴 리프팅 효과'),
('피부재생', '피부 재생 및 탄력 개선'),
('모공축소', '모공 축소 효과')
ON CONFLICT (name) DO NOTHING;

-- ========================================
-- 🆕 6. 패키지 샘플 데이터 (테스트용)
-- ========================================

-- 테스트용 패키지 데이터
INSERT INTO treatment_packages (id, package_name, is_separable, description, naming_rule) VALUES 
('11111111-1111-1111-1111-111111111111', '울쎄라300+써마지300', true, '분리 가능한 레이저 콤보 패키지', '[기기명][용량]+[기기명][용량]'),
('22222222-2222-2222-2222-222222222222', '포텐자+쥬베룩스킨2cc', false, '함께 시행하는 안티에이징 패키지', '[기기명]+[제품명][용량]')
ON CONFLICT (package_name) DO NOTHING;

-- 패키지 구성 요소
INSERT INTO package_components (package_id, component_name, weight_percentage, is_primary) VALUES 
-- 울쎄라+써마지 (분리 가능)
('11111111-1111-1111-1111-111111111111', '울쎄라300샷', 50.0, true),
('11111111-1111-1111-1111-111111111111', '써마지300샷', 50.0, false),
-- 포텐자+쥬베룩 (분리 불가능)
('22222222-2222-2222-2222-222222222222', '포텐자', 70.0, true),
('22222222-2222-2222-2222-222222222222', '쥬베룩스킨2cc', 30.0, false)
ON CONFLICT DO NOTHING;

-- ========================================
-- 7. updated_at 트리거 적용
-- ========================================

-- updated_at 자동 업데이트 함수 (이미 존재할 수 있음)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 각 테이블에 updated_at 트리거 적용
CREATE TRIGGER update_treatment_categories_updated_at 
    BEFORE UPDATE ON treatment_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_treatment_subcategories_updated_at 
    BEFORE UPDATE ON treatment_subcategories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_treatment_procedures_updated_at 
    BEFORE UPDATE ON treatment_procedures 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_treatment_effects_updated_at 
    BEFORE UPDATE ON treatment_effects 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_treatment_packages_updated_at 
    BEFORE UPDATE ON treatment_packages 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- 완료 메시지
-- ========================================

-- 생성 완료 확인
DO $$
BEGIN
    RAISE NOTICE '✅ 시술 마스터 테이블 + 패키지 관리 시스템 생성 완료!';
    RAISE NOTICE '📦 패키지 테이블: treatment_packages, package_components, treatment_analytics';
    RAISE NOTICE '🤖 자동 분해 함수: auto_decompose_treatment() 준비 완료';
    RAISE NOTICE '🎯 다음 단계: 04_create_customer_treatments_table.sql 실행';
END $$; 