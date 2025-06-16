# SQL 실행 가이드

## 📋 실행 순서

아래 순서대로 Supabase SQL Editor에서 실행해주세요:

### ✅ 이미 실행 완료된 작업
1. **테이블 삭제** (완료)
   - `clinic_specialties`, `specialties`, `languages`, `guide_languages`, `guide_specialties`, `settlement_items` 테이블 삭제

2. **clinics 테이블 수정** (완료)
   - 불필요한 컬럼 삭제: `address`, `region`, `phone`, `note`
   - 새 컬럼 추가: `commission_rate`, `specialty`

### 🔄 실행 예정 작업

#### 1. `01_modify_customers_table.sql`
- **목적**: customers 테이블에 고객 정보 및 금액 관련 컬럼 추가
- **주요 변경사항**:
  - 고객 코드, 여권명, 유입경로 등 추가
  - 금액 계산 필드들 추가
  - 복합 유니크 제약조건 추가 (중복 방지)

#### 2. `02_modify_reservations_table.sql`
- **목적**: reservations 테이블에 예약 관련 정보 추가
- **주요 변경사항**:
  - 예약 코드, 그룹 사이즈, 병원 방문 정보 추가
  - 통역 서비스 시간 정보 추가

#### 3. `03_create_treatment_master_tables.sql`
- **목적**: 시술 관련 마스터 테이블들 생성
- **생성 테이블**:
  - `treatment_categories` (시술 대분류)
  - `treatment_subcategories` (시술 중분류)
  - `treatment_procedures` (단일 시술명)
  - `treatment_effects` (시술 효과)
- **초기 데이터**: 예시 데이터 자동 삽입

#### 4. `04_create_customer_treatments_table.sql`
- **목적**: 고객별 시술 정보를 관리하는 핵심 테이블 생성
- **주요 기능**:
  - 고객-시술 연결 (1:N 관계)
  - 금액 자동 계산 (부가세 포함/불포함)
  - 업데이트 트리거 적용

#### 5. `05_create_settlements_table.sql`
- **목적**: 가이드 정산 관리 테이블 생성
- **주요 기능**:
  - 정산 상태 관리
  - 자동 수수료 계산
  - RLS (Row Level Security) 적용

#### 6. `06_create_calculated_views.sql`
- **목적**: 매출 분석을 위한 뷰들 생성
- **생성 뷰**:
  - 고객별 결제 요약
  - 월별 매출 분석
  - 시술별 인기도 분석
  - 유입경로별 분석
  - 정산 현황

#### 7. `07_sample_data_and_usage.sql` (선택사항)
- **목적**: 테스트용 샘플 데이터 및 사용 예시
- **포함 내용**:
  - 샘플 데이터 삽입
  - 금액 자동 계산 함수
  - 유용한 쿼리 예시

## ⚠️ 주의사항

### 실행 전 확인사항
1. **백업**: 중요한 데이터가 있다면 반드시 백업 후 진행
2. **권한**: Supabase 프로젝트의 관리자 권한 필요
3. **기존 테이블**: `customers`, `reservations`, `clinics`, `guides` 테이블 존재 확인

### 실행 중 오류 발생 시
1. **외래키 오류**: 참조되는 테이블이 먼저 생성되어야 함 (순서 확인)
2. **컬럼 중복 오류**: `IF NOT EXISTS` 옵션으로 처리되지만, 수동 확인 필요
3. **권한 오류**: RLS 정책 관련 오류 시 해당 부분 주석 처리 후 나중에 적용

### 데이터 타입 관련
- **UUID**: PostgreSQL의 `uuid_generate_v4()` 함수 사용
- **금액**: `NUMERIC(10,2)` 타입으로 소수점 2자리까지 지원
- **날짜**: `DATE`, `TIME`, `TIMESTAMP WITH TIME ZONE` 타입 사용

## 🔍 실행 후 검증

### 1. 테이블 생성 확인
```sql
-- 새로 생성된 테이블들 확인
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
    'treatment_categories', 
    'treatment_subcategories', 
    'treatment_procedures', 
    'treatment_effects',
    'customer_treatments', 
    'settlements'
);
```

### 2. 컬럼 추가 확인
```sql
-- customers 테이블 컬럼 확인
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'customers' 
ORDER BY ordinal_position;
```

### 3. 뷰 생성 확인
```sql
-- 생성된 뷰들 확인
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public';
```

## 💡 사용법

### 고객 검색
```sql
SELECT * FROM customers 
WHERE name ILIKE '%검색어%' 
   OR customer_code ILIKE '%검색어%';
```

### 매출 현황 조회
```sql
SELECT * FROM monthly_revenue_analysis 
WHERE visit_month = '2024년 01월';
```

### 정산 현황 조회
```sql
SELECT * FROM settlement_status_view 
WHERE settlement_month = '2024-01';
```

## 📞 문제 발생 시
1. 실행 순서를 반드시 확인
2. 오류 메시지를 정확히 읽고 대응
3. 테스트 환경에서 먼저 실행 권장
4. 필요시 개별 SQL 문을 나누어 실행 