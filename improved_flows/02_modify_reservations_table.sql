-- reservations 테이블 수정: 예약 관련 정보 추가
-- 실행 순서: 2번째

-- 예약 관련 정보 컬럼 추가
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS reservation_code VARCHAR(50) UNIQUE; -- 예약 번호 (G-YYYYMMDD-A 형식)
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS group_size INTEGER DEFAULT 1; -- 그룹 사이즈
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS hospital_booking_date DATE; -- 병원 예약일
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS hospital_visit_date DATE; -- 병원 방문일
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS visit_day_of_week VARCHAR(10); -- 병원 방문 요일
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS interpretation_start_time TIME; -- 통역서비스 시작 시간
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS interpretation_end_time TIME; -- 통역서비스 종료 시간
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS visit_month VARCHAR(20); -- 병원 방문월 (YYYY년 MM월)

-- 인덱스 생성 (검색 성능 향상)
CREATE INDEX IF NOT EXISTS idx_reservations_reservation_code ON reservations(reservation_code);
CREATE INDEX IF NOT EXISTS idx_reservations_hospital_visit_date ON reservations(hospital_visit_date);
CREATE INDEX IF NOT EXISTS idx_reservations_visit_month ON reservations(visit_month); 