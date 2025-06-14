-- Add default_duration_minutes to service_types table
-- 답변에서 요구한 서비스별 기본 소요시간 자동 설정을 위한 스키마 수정

ALTER TABLE service_types 
ADD COLUMN default_duration_minutes INTEGER DEFAULT 180;

-- Update existing data with default durations
UPDATE service_types SET 
  default_duration_minutes = CASE
    WHEN name LIKE '%상담%' THEN 120
    WHEN name LIKE '%시술%' THEN 180
    WHEN name LIKE '%수술%' THEN 240
    ELSE 180
  END;

COMMENT ON COLUMN service_types.default_duration_minutes IS 'Default duration in minutes for this service type'; 