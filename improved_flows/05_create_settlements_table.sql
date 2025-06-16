-- 가이드 정산 관리 테이블 생성
-- 실행 순서: 5번째

-- 가이드 정산 테이블
CREATE TABLE IF NOT EXISTS settlements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guide_id UUID REFERENCES guides(id) ON DELETE RESTRICT NOT NULL, -- 가이드 ID
    customer_id UUID REFERENCES customers(id) ON DELETE RESTRICT NOT NULL, -- 고객 ID
    reservation_id UUID REFERENCES reservations(id) ON DELETE RESTRICT NOT NULL, -- 예약 ID
    
    -- 정산 기준 정보
    base_amount NUMERIC(10,2) NOT NULL, -- 정산 기준 금액 (고객 총 결제금액)
    commission_rate NUMERIC(5,2) DEFAULT 4.5 NOT NULL, -- 가이드 수수료율 (기본 4.5%)
    commission_amount NUMERIC(10,2) GENERATED ALWAYS AS (base_amount * commission_rate / 100) STORED, -- 정산 금액 (자동 계산)
    
    -- 정산 상태 관리
    settlement_status VARCHAR(20) DEFAULT 'pending' CHECK (settlement_status IN ('pending', 'paid', 'cancelled')), -- 정산 상태
    settlement_date DATE, -- 정산 완료일
    payment_method VARCHAR(50), -- 지급 방법 (계좌이체, 현금 등)
    
    -- 정산 기간 정보
    service_date DATE NOT NULL, -- 서비스 제공일 (병원 방문일)
    settlement_month VARCHAR(10) NOT NULL, -- 정산 월 (YYYY-MM)
    
    -- 메타 정보
    notes TEXT, -- 특이사항
    created_by UUID REFERENCES auth.users(id), -- 정산 생성자
    paid_by UUID REFERENCES auth.users(id), -- 정산 처리자
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- updated_at 트리거 적용
CREATE TRIGGER update_settlements_updated_at 
    BEFORE UPDATE ON settlements 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_settlements_guide_id ON settlements(guide_id);
CREATE INDEX IF NOT EXISTS idx_settlements_customer_id ON settlements(customer_id);
CREATE INDEX IF NOT EXISTS idx_settlements_reservation_id ON settlements(reservation_id);
CREATE INDEX IF NOT EXISTS idx_settlements_settlement_status ON settlements(settlement_status);
CREATE INDEX IF NOT EXISTS idx_settlements_settlement_month ON settlements(settlement_month);
CREATE INDEX IF NOT EXISTS idx_settlements_service_date ON settlements(service_date);

-- 복합 인덱스 (정산 조회 성능 향상)
CREATE INDEX IF NOT EXISTS idx_settlements_guide_month_status ON settlements(guide_id, settlement_month, settlement_status);

-- 유니크 제약조건 (중복 정산 방지)
ALTER TABLE settlements ADD CONSTRAINT unique_settlement_per_customer 
UNIQUE (customer_id, guide_id, service_date);

-- RLS (Row Level Security) 설정 (선택사항)
ALTER TABLE settlements ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 가이드는 자신의 정산만 조회 가능
CREATE POLICY settlements_guide_policy ON settlements
    FOR SELECT
    USING (guide_id = auth.uid() OR auth.role() = 'admin');

-- RLS 정책: 관리자만 정산 생성/수정 가능  
CREATE POLICY settlements_admin_policy ON settlements
    FOR ALL
    USING (auth.role() = 'admin'); 