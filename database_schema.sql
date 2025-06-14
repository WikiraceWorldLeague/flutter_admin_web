-- ================================
-- Flutter Admin Web Database Schema
-- ================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================
-- 1. USERS (관리자) 테이블
-- ================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'admin' NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 2. SPECIALTIES (전문분야) 테이블
-- ================================
CREATE TABLE specialties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 3. LANGUAGES (언어) 테이블
-- ================================
CREATE TABLE languages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 4. GUIDES (가이드) 테이블
-- ================================
CREATE TABLE guides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 기본 정보
    passport_last_name VARCHAR(100) NOT NULL,
    passport_first_name VARCHAR(100) NOT NULL,
    nickname VARCHAR(100),
    nationality VARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    temp_password VARCHAR(255), -- 초기 발급 임시 비밀번호
    profile_image_url TEXT,
    
    -- 상태 정보
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    
    -- 경력 정보 (자동 계산 가능한 필드들)
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_assignments INTEGER DEFAULT 0,
    total_settlement_amount DECIMAL(15,2) DEFAULT 0,
    total_customers INTEGER DEFAULT 0,
    
    -- 현재 등급 (매월 1일 브론즈로 초기화)
    current_grade VARCHAR(20) DEFAULT 'bronze' CHECK (current_grade IN ('bronze', 'silver', 'gold', 'platinum')),
    grade_reset_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 커미션 관련
    custom_commission_rate DECIMAL(5,2), -- 개별 커미션율 (기본 4.5% 대신)
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 5. GUIDE_SPECIALTIES (가이드-전문분야 관계)
-- ================================
CREATE TABLE guide_specialties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guide_id UUID REFERENCES guides(id) ON DELETE CASCADE,
    specialty_id UUID REFERENCES specialties(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, specialty_id)
);

-- ================================
-- 6. GUIDE_LANGUAGES (가이드-언어 관계)
-- ================================
CREATE TABLE guide_languages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guide_id UUID REFERENCES guides(id) ON DELETE CASCADE,
    language_id UUID REFERENCES languages(id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20) DEFAULT 'fluent' CHECK (proficiency_level IN ('basic', 'intermediate', 'fluent', 'native')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, language_id)
);

-- ================================
-- 7. CLINICS (병원/클리닉) 테이블
-- ================================
CREATE TABLE clinics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_name VARCHAR(200) NOT NULL,
    address TEXT,
    region VARCHAR(100), -- 강남, 압구정 등
    phone VARCHAR(20),
    note TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 8. CLINIC_SPECIALTIES (병원-진료과목 관계)
-- ================================
CREATE TABLE clinic_specialties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID REFERENCES clinics(id) ON DELETE CASCADE,
    specialty_id UUID REFERENCES specialties(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(clinic_id, specialty_id)
);

-- ================================
-- 9. SERVICE_TYPES (서비스 타입) 테이블
-- ================================
CREATE TABLE service_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 10. RESERVATIONS (예약) 테이블
-- ================================
CREATE TABLE reservations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 예약 기본 정보
    reservation_number VARCHAR(20) UNIQUE NOT NULL, -- 예약 번호
    
    -- 날짜/시간
    reservation_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME, -- 선택사항 (기본 3시간 후)
    
    -- 관계
    guide_id UUID REFERENCES guides(id),
    clinic_id UUID REFERENCES clinics(id),
    
    -- 상태
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'assigned', 'in_progress', 'completed', 'cancelled')),
    
    -- 메모
    special_notes TEXT,
    admin_memo TEXT,
    
    -- 정산 관련
    total_amount DECIMAL(15,2) DEFAULT 0,
    commission_rate DECIMAL(5,2) DEFAULT 4.5,
    commission_amount DECIMAL(15,2) DEFAULT 0,
    settlement_status VARCHAR(20) DEFAULT 'pending' CHECK (settlement_status IN ('pending', 'processed', 'paid')),
    
    -- 할당 정보
    assigned_at TIMESTAMP WITH TIME ZONE,
    assigned_by UUID REFERENCES users(id),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 11. RESERVATION_SERVICES (예약-서비스타입 관계)
-- ================================
CREATE TABLE reservation_services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
    service_type_id UUID REFERENCES service_types(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(reservation_id, service_type_id)
);

-- ================================
-- 12. CUSTOMERS (고객) 테이블
-- ================================
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
    
    -- 고객 정보
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    nationality VARCHAR(100),
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    age INTEGER,
    
    -- 고객별 메모
    customer_note TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- 13. SETTLEMENTS (정산) 테이블
-- ================================
CREATE TABLE settlements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    guide_id UUID REFERENCES guides(id) NOT NULL,
    settlement_period VARCHAR(20) NOT NULL, -- 'YYYY-MM' 형식
    
    -- 정산 금액
    total_reservations INTEGER DEFAULT 0,
    total_revenue DECIMAL(15,2) DEFAULT 0,
    commission_amount DECIMAL(15,2) DEFAULT 0,
    bonus_amount DECIMAL(15,2) DEFAULT 0, -- 등급별 보너스 (70만원)
    additional_expenses JSONB, -- 추가 비용 (교통비, 식사비 등)
    final_amount DECIMAL(15,2) DEFAULT 0,
    
    -- 상태
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed')),
    
    -- 처리 정보
    processed_at TIMESTAMP WITH TIME ZONE,
    processed_by UUID REFERENCES users(id),
    payment_method VARCHAR(50),
    payment_reference TEXT,
    
    notes TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(guide_id, settlement_period)
);

-- ================================
-- 14. REVIEWS (리뷰) 테이블
-- ================================
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
    guide_id UUID REFERENCES guides(id) NOT NULL,
    
    -- 리뷰 내용
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    title VARCHAR(200),
    content TEXT,
    
    -- 고객 정보 (익명화 가능)
    reviewer_name VARCHAR(100),
    reviewer_nationality VARCHAR(100),
    
    -- 상태
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'hidden', 'reported')),
    
    -- 관리자 응답
    admin_response TEXT,
    admin_responded_at TIMESTAMP WITH TIME ZONE,
    admin_responded_by UUID REFERENCES users(id),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================
-- INDEXES 생성
-- ================================

-- Guides indexes
CREATE INDEX idx_guides_status ON guides(status);
CREATE INDEX idx_guides_email ON guides(email);
CREATE INDEX idx_guides_phone ON guides(phone);

-- Reservations indexes
CREATE INDEX idx_reservations_status ON reservations(status);
CREATE INDEX idx_reservations_date ON reservations(reservation_date);
CREATE INDEX idx_reservations_guide_id ON reservations(guide_id);
CREATE INDEX idx_reservations_clinic_id ON reservations(clinic_id);
CREATE INDEX idx_reservations_number ON reservations(reservation_number);

-- Customers indexes
CREATE INDEX idx_customers_reservation_id ON customers(reservation_id);
CREATE INDEX idx_customers_phone ON customers(phone);

-- Settlements indexes
CREATE INDEX idx_settlements_guide_id ON settlements(guide_id);
CREATE INDEX idx_settlements_period ON settlements(settlement_period);
CREATE INDEX idx_settlements_status ON settlements(status);

-- Reviews indexes
CREATE INDEX idx_reviews_guide_id ON reviews(guide_id);
CREATE INDEX idx_reviews_reservation_id ON reviews(reservation_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_reviews_status ON reviews(status);

-- ================================
-- 초기 데이터 삽입
-- ================================

-- 전문분야 데이터
INSERT INTO specialties (name, code) VALUES
('피부과', 'dermatology'),
('성형외과', 'plastic_surgery'),
('퍼스널컬러', 'personal_color'),
('헤어샵', 'hair_salon'),
('메이크업샵', 'makeup_salon'),
('박람회', 'exhibition'),
('기타', 'other');

-- 언어 데이터
INSERT INTO languages (name, code) VALUES
('중국어', 'zh'),
('광동어', 'yue'),
('영어', 'en'),
('일본어', 'ja'),
('한국어', 'ko');

-- 서비스 타입 데이터
INSERT INTO service_types (name, code, description) VALUES
('미용의료 풀패키지', 'full_package', '병원 추천, 비교 견적, 동행 통역, 사후 커뮤니케이션'),
('단순 통역', 'translation_only', '비제휴 병원, 비병원, 박람회 등'),
('일반 관광 가이드', 'general_guide', '관광 및 일반 가이드 서비스');

-- 관리자 계정 (비밀번호는 'admin123'의 해시값으로 대체 필요)
INSERT INTO users (email, password_hash, full_name, role) VALUES
('admin@demo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '관리자', 'admin');

-- ================================
-- 트리거 및 함수 생성
-- ================================

-- Updated_at 자동 업데이트 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Updated_at 트리거 적용
CREATE TRIGGER update_guides_updated_at BEFORE UPDATE ON guides FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_clinics_updated_at BEFORE UPDATE ON clinics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reservations_updated_at BEFORE UPDATE ON reservations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_settlements_updated_at BEFORE UPDATE ON settlements FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 예약 번호 자동 생성 함수
CREATE OR REPLACE FUNCTION generate_reservation_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.reservation_number = 'RES' || TO_CHAR(NOW(), 'YYYYMMDD') || LPAD(EXTRACT(EPOCH FROM NOW())::bigint % 10000::bigint, 4, '0');
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 예약 번호 자동 생성 트리거
CREATE TRIGGER generate_reservation_number_trigger 
    BEFORE INSERT ON reservations 
    FOR EACH ROW 
    EXECUTE FUNCTION generate_reservation_number();

COMMENT ON DATABASE postgres IS 'Flutter Admin Web Database'; 