-- ================================
-- 데모 데이터 삽입
-- ================================

-- 병원/클리닉 데이터
INSERT INTO clinics (clinic_name, address, region, phone) VALUES
('강남 아름다운 피부과', '서울시 강남구 역삼동 123-45', '강남', '02-1234-5678'),
('압구정 성형외과', '서울시 강남구 압구정동 678-90', '압구정', '02-9876-5432'),
('신사동 더마 클리닉', '서울시 강남구 신사동 111-22', '신사', '02-5555-6666'),
('청담 뷰티 센터', '서울시 강남구 청담동 333-44', '청담', '02-7777-8888'),
('기타 (직접입력)', '', '기타', '');

-- 병원-전문분야 관계 설정
INSERT INTO clinic_specialties (clinic_id, specialty_id) 
SELECT c.id, s.id 
FROM clinics c, specialties s 
WHERE 
    (c.clinic_name = '강남 아름다운 피부과' AND s.code = 'dermatology') OR
    (c.clinic_name = '압구정 성형외과' AND s.code = 'plastic_surgery') OR
    (c.clinic_name = '신사동 더마 클리닉' AND s.code = 'dermatology') OR
    (c.clinic_name = '청담 뷰티 센터' AND s.code IN ('dermatology', 'plastic_surgery'));

-- 가이드 데이터
INSERT INTO guides (
    passport_last_name, passport_first_name, nickname, nationality, gender, 
    birth_date, phone, email, temp_password, status, started_at, current_grade
) VALUES
('김', '민수', '민수가이드', '대한민국', 'male', '1990-05-15', '010-1111-2222', 'guide1@demo.com', 'temp123', 'active', '2023-01-15', 'gold'),
('이', '지영', '지영가이드', '대한민국', 'female', '1988-08-20', '010-3333-4444', 'guide2@demo.com', 'temp123', 'active', '2022-11-01', 'silver'),
('박', '준호', '준호가이드', '대한민국', 'male', '1992-03-10', '010-5555-6666', 'guide3@demo.com', 'temp123', 'active', '2023-06-01', 'bronze'),
('최', '수정', '수정가이드', '대한민국', 'female', '1995-12-25', '010-7777-8888', 'guide4@demo.com', 'temp123', 'active', '2023-09-15', 'bronze'),
('정', '현우', '현우가이드', '대한민국', 'male', '1987-07-30', '010-9999-0000', 'guide5@demo.com', 'temp123', 'inactive', '2022-05-20', 'bronze');

-- 가이드-전문분야 관계 설정
INSERT INTO guide_specialties (guide_id, specialty_id)
SELECT g.id, s.id 
FROM guides g, specialties s 
WHERE 
    (g.nickname = '민수가이드' AND s.code IN ('dermatology', 'plastic_surgery')) OR
    (g.nickname = '지영가이드' AND s.code IN ('dermatology', 'personal_color')) OR
    (g.nickname = '준호가이드' AND s.code IN ('plastic_surgery', 'exhibition')) OR
    (g.nickname = '수정가이드' AND s.code IN ('hair_salon', 'makeup_salon')) OR
    (g.nickname = '현우가이드' AND s.code IN ('dermatology', 'other'));

-- 가이드-언어 관계 설정
INSERT INTO guide_languages (guide_id, language_id, proficiency_level)
SELECT g.id, l.id, 
    CASE 
        WHEN l.code = 'ko' THEN 'native'
        WHEN l.code = 'zh' THEN 'fluent'
        WHEN l.code = 'en' THEN 'intermediate'
        ELSE 'basic'
    END as proficiency_level
FROM guides g, languages l 
WHERE 
    (g.nickname = '민수가이드' AND l.code IN ('ko', 'zh', 'en')) OR
    (g.nickname = '지영가이드' AND l.code IN ('ko', 'zh', 'yue')) OR
    (g.nickname = '준호가이드' AND l.code IN ('ko', 'en', 'ja')) OR
    (g.nickname = '수정가이드' AND l.code IN ('ko', 'zh')) OR
    (g.nickname = '현우가이드' AND l.code IN ('ko', 'zh', 'en', 'ja'));

-- 예약 데이터
INSERT INTO reservations (
    reservation_date, start_time, end_time, guide_id, clinic_id, 
    status, special_notes, total_amount, commission_rate, commission_amount, settlement_status
) VALUES
('2024-01-15', '10:00', '13:00', (SELECT id FROM guides WHERE nickname = '민수가이드'), (SELECT id FROM clinics WHERE clinic_name = '강남 아름다운 피부과'), 'completed', '피부 레이저 시술 동행', 500000, 4.5, 22500, 'paid'),
('2024-01-18', '14:00', '17:00', (SELECT id FROM guides WHERE nickname = '지영가이드'), (SELECT id FROM clinics WHERE clinic_name = '압구정 성형외과'), 'completed', '코 성형 상담', 300000, 4.5, 13500, 'paid'),
('2024-01-20', '11:00', '14:00', (SELECT id FROM guides WHERE nickname = '준호가이드'), (SELECT id FROM clinics WHERE clinic_name = '신사동 더마 클리닉'), 'in_progress', '여드름 치료', 250000, 4.5, 11250, 'pending'),
('2024-01-22', '15:00', '18:00', (SELECT id FROM guides WHERE nickname = '수정가이드'), (SELECT id FROM clinics WHERE clinic_name = '청담 뷰티 센터'), 'assigned', '보톡스 시술', 400000, 4.5, 18000, 'pending'),
('2024-01-25', '09:00', '12:00', NULL, (SELECT id FROM clinics WHERE clinic_name = '강남 아름다운 피부과'), 'pending', '전체적인 피부 관리 상담', 0, 4.5, 0, 'pending');

-- 예약-서비스타입 관계 설정
INSERT INTO reservation_services (reservation_id, service_type_id)
SELECT r.id, st.id
FROM reservations r, service_types st
WHERE 
    (r.special_notes LIKE '%피부 레이저%' AND st.code = 'full_package') OR
    (r.special_notes LIKE '%코 성형%' AND st.code = 'full_package') OR
    (r.special_notes LIKE '%여드름%' AND st.code = 'translation_only') OR
    (r.special_notes LIKE '%보톡스%' AND st.code = 'full_package') OR
    (r.special_notes LIKE '%전체적인%' AND st.code = 'full_package');

-- 고객 데이터
INSERT INTO customers (reservation_id, name, phone, nationality, gender, age, customer_note) VALUES
((SELECT id FROM reservations WHERE special_notes LIKE '%피부 레이저%'), '장웨이', '010-1234-5678', '중국', 'female', 28, '중국어 통역 필요'),
((SELECT id FROM reservations WHERE special_notes LIKE '%피부 레이저%'), '리멍', '010-1234-5679', '중국', 'female', 25, '친구와 함께 방문'),

((SELECT id FROM reservations WHERE special_notes LIKE '%코 성형%'), '타나카 유키', '010-9876-5432', '일본', 'female', 32, '일본어 통역 필요'),

((SELECT id FROM reservations WHERE special_notes LIKE '%여드름%'), '스미스 존', '010-5555-1234', '미국', 'male', 29, '영어 통역 필요'),

((SELECT id FROM reservations WHERE special_notes LIKE '%보톡스%'), '왕리나', '010-7777-9999', '중국', 'female', 35, '처음 방문, 상세 설명 필요'),

((SELECT id FROM reservations WHERE special_notes LIKE '%전체적인%'), '최유진', '010-1111-9999', '대한민국', 'female', 30, '종합 상담 희망');

-- 리뷰 데이터
INSERT INTO reviews (
    reservation_id, guide_id, rating, title, content, reviewer_name, reviewer_nationality, status
) VALUES
((SELECT id FROM reservations WHERE special_notes LIKE '%피부 레이저%'), (SELECT id FROM guides WHERE nickname = '민수가이드'), 5, '완벽한 서비스!', '민수 가이드님이 정말 친절하고 전문적이었습니다. 병원에서도 꼼꼼하게 통역해주셔서 안심이 되었어요.', '장웨이', '중국', 'active'),
((SELECT id FROM reservations WHERE special_notes LIKE '%코 성형%'), (SELECT id FROM guides WHERE nickname = '지영가이드'), 4, '만족스러운 상담', '지영님 덕분에 성형외과 상담을 잘 받을 수 있었습니다. 다음에도 부탁드리고 싶어요.', '타나카 유키', '일본', 'active'),
((SELECT id FROM reservations WHERE special_notes LIKE '%여드름%'), (SELECT id FROM guides WHERE nickname = '준호가이드'), 5, '최고의 가이드', '준호님이 정말 세심하게 도와주셨어요. 치료 과정도 자세히 설명해주시고 감사했습니다.', '스미스 존', '미국', 'active');

-- 정산 데이터
INSERT INTO settlements (
    guide_id, settlement_period, total_reservations, total_revenue, 
    commission_amount, bonus_amount, final_amount, status, processed_at
) VALUES
((SELECT id FROM guides WHERE nickname = '민수가이드'), '2023-12', 12, 3500000, 157500, 700000, 857500, 'completed', '2024-01-10 09:00:00'),
((SELECT id FROM guides WHERE nickname = '지영가이드'), '2023-12', 8, 2200000, 99000, 0, 99000, 'completed', '2024-01-10 09:00:00'),
((SELECT id FROM guides WHERE nickname = '준호가이드'), '2023-12', 5, 1500000, 67500, 0, 67500, 'completed', '2024-01-10 09:00:00'),
((SELECT id FROM guides WHERE nickname = '수정가이드'), '2024-01', 3, 800000, 36000, 0, 36000, 'pending', NULL),
((SELECT id FROM guides WHERE nickname = '민수가이드'), '2024-01', 1, 500000, 22500, 0, 22500, 'processing', NULL);

-- 가이드 통계 업데이트 (경력 정보)
UPDATE guides SET 
    total_assignments = (
        SELECT COUNT(*) FROM reservations 
        WHERE guide_id = guides.id AND status = 'completed'
    ),
    total_settlement_amount = (
        SELECT COALESCE(SUM(final_amount), 0) FROM settlements 
        WHERE guide_id = guides.id AND status = 'completed'
    ),
    total_customers = (
        SELECT COUNT(*) FROM customers c 
        JOIN reservations r ON c.reservation_id = r.id 
        WHERE r.guide_id = guides.id AND r.status = 'completed'
    )
WHERE id IN (SELECT id FROM guides); 