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
- **목적**: 시술 관련 마스터 테이블들 생성 + **🆕 패키지 관리 시스템**
- **생성 테이블**:
  - `treatment_categories` (시술 대분류)
  - `treatment_subcategories` (시술 중분류)
  - `treatment_procedures` (단일 시술명)
  - `treatment_effects` (시술 효과)
  - **🆕 `treatment_packages`** (패키지 정의)
  - **🆕 `package_components`** (패키지 구성 요소)
  - **🆕 `treatment_analytics`** (분석용 분해 테이블)
- **초기 데이터**: 예시 데이터 자동 삽입
- **🤖 자동 분해 트리거**: 패키지 입력 시 자동으로 구성 요소 분해

#### 4. `04_create_customer_treatments_table.sql`
- **목적**: 고객별 시술 정보를 관리하는 핵심 테이블 생성
- **주요 기능**:
  - 고객-시술 연결 (1:N 관계)
  - 금액 자동 계산 (부가세 포함/불포함)
  - **패키지 analytics 연동**: 시술 입력 시 자동 분석 테이블 업데이트
  - 업데이트 트리거 적용

#### 5. `05_create_settlements_table.sql`
- **목적**: 가이드 정산 관리 테이블 생성/수정
- **주요 기능**:
  - 정산 상태 관리
  - 자동 수수료 계산
  - **settlements 테이블이 이미 존재**하므로 필요시 컬럼 추가
  - RLS (Row Level Security) 적용

#### 6. `06_create_calculated_views.sql`
- **목적**: 매출 분석을 위한 뷰들 생성 + **🆕 패키지 분석 뷰**
- **생성 뷰**:
  - 고객별 결제 요약
  - 월별 매출 분석
  - **🆕 시술별 인기도 분석** (패키지 분해 데이터 기반)
  - **🆕 패키지 vs 단일 시술 트렌드**
  - 유입경로별 분석
  - 정산 현황

#### 7. `07_sample_data_and_usage.sql` (선택사항)
- **목적**: 테스트용 샘플 데이터 및 사용 예시
- **포함 내용**:
  - 샘플 데이터 삽입
  - **🆕 패키지 샘플 데이터** (분리 가능/불가능 예시)
  - 금액 자동 계산 함수
  - **🆕 패키지 분석 쿼리** 예시
  - 유용한 쿼리 예시

## 📦 패키지 관리 시스템 특징

### 🎯 핵심 개념
1. **하이브리드 방식**: 원본 데이터 보존 + 분석용 분해
2. **자동 분해**: 패키지 입력 시 구성 시술로 자동 분해
3. **가중치 시스템**: 각 구성 시술의 비중 설정 가능
4. **통계 분석**: 개별 시술 인기도 및 트렌드 파악

### 🔄 자동화 플로우
```
패키지 등록 (관리자) → 고객 시술 입력 → 자동 감지 → 자동 분해 → 분석 데이터 생성
```

### 📊 분석 가능한 통계
- 개별 시술 인기도 (패키지 포함)
- 패키지 vs 단일 시술 선호도
- 시술 조합 패턴 분석
- 시기별 트렌드 변화

## ⚠️ 주의사항

### 실행 전 확인사항
1. **백업**: 중요한 데이터가 있다면 반드시 백업 후 진행
2. **권한**: Supabase 프로젝트의 관리자 권한 필요
3. **기존 테이블**: `customers`, `reservations`, `clinics`, `guides` 테이블 존재 확인
4. **settlements 테이블**: 이미 존재하므로 05번 스크립트는 신중히 실행

### 실행 중 오류 발생 시
1. **외래키 오류**: 참조되는 테이블이 먼저 생성되어야 함 (순서 확인)
2. **컬럼 중복 오류**: `IF NOT EXISTS` 옵션으로 처리되지만, 수동 확인 필요
3. **권한 오류**: RLS 정책 관련 오류 시 해당 부분 주석 처리 후 나중에 적용
4. **패키지 관련 오류**: 트리거 생성 시 `CREATE OR REPLACE` 사용

### 데이터 타입 관련
- **UUID**: PostgreSQL의 `uuid_generate_v4()` 함수 사용
- **금액**: `NUMERIC(10,2)` 타입으로 소수점 2자리까지 지원
- **날짜**: `DATE`, `TIME`, `TIMESTAMP WITH TIME ZONE` 타입 사용
- **가중치**: `NUMERIC(5,2)` 타입으로 백분율 지원

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
    'treatment_packages',     -- 🆕 패키지 정의
    'package_components',     -- 🆕 패키지 구성요소
    'treatment_analytics',    -- 🆕 분석용 분해
    'customer_treatments', 
    'settlements'
);
```

### 2. 패키지 시스템 확인
```sql
-- 패키지 관련 테이블 확인
SELECT 
    tp.package_name,
    tp.is_separable,
    pc.component_name,
    pc.weight_percentage
FROM treatment_packages tp
LEFT JOIN package_components pc ON tp.id = pc.package_id;
```

### 3. 트리거 확인
```sql
-- 생성된 트리거들 확인
SELECT trigger_name, event_manipulation, event_object_table
FROM information_schema.triggers 
WHERE trigger_schema = 'public'
AND trigger_name LIKE '%treatment%';
```

### 4. 뷰 생성 확인
```sql
-- 생성된 뷰들 확인
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public';
```

## 💡 사용법

### 패키지 등록 (수동)
```sql
-- 1. 패키지 정의
INSERT INTO treatment_packages (package_name, is_separable, description) 
VALUES ('울쎄라300+써마지300', true, '분리 가능한 레이저 콤보');

-- 2. 구성 요소 등록
INSERT INTO package_components (package_id, component_name, weight_percentage, is_primary)
VALUES 
  (package_id, '울쎄라300샷', 50.0, true),
  (package_id, '써마지300샷', 50.0, false);
```

### 고객 시술 입력
```sql
-- 고객 시술 입력 (패키지면 자동 분해됨)
INSERT INTO customer_treatments (customer_id, hospital_procedure_name, price_with_tax)
VALUES (customer_id, '울쎄라300+써마지300', 2200000);
-- → 자동으로 treatment_analytics 테이블에 분해되어 저장됨
```

### 통계 조회
```sql
-- 개별 시술 인기도 (패키지 분해 포함)
SELECT * FROM treatment_popularity_analysis;

-- 패키지 vs 단일 시술 비교
SELECT 
  CASE WHEN EXISTS(SELECT 1 FROM treatment_packages WHERE package_name = ta.component_treatment_name) 
       THEN 'Package' ELSE 'Single' END as type,
  COUNT(*) as count
FROM treatment_analytics ta
GROUP BY type;
```

## 📞 문제 발생 시
1. 실행 순서를 반드시 확인
2. 오류 메시지를 정확히 읽고 대응
3. **패키지 시스템은 선택적 실행 가능**: 03번에서 패키지 관련 부분만 주석 처리 가능
4. 테스트 환경에서 먼저 실행 권장
5. 필요시 개별 SQL 문을 나누어 실행

## 🚀 개발 로드맵

### Phase 1 (현재): 백엔드 구조 완성
- ✅ 테이블 구조 설계
- 🔄 SQL 스크립트 실행
- 🔄 패키지 시스템 테스트

### Phase 2: 프론트엔드 개발
- 패키지 관리 UI 구축
- 고객 시술 입력 UI (패키지 지원)
- 통계 대시보드 (패키지 분석 포함)

### Phase 3: 고도화
- AI 기반 패키지 자동 분류
- 실시간 트렌드 분석
- 예측 분석 기능

---

## 🎉 **업데이트 완료!**

모든 파일이 패키지 관리 시스템을 포함하여 완전히 업데이트되었습니다:

### ✅ **업데이트된 파일들**
1. **conversation_summary.md** - 패키지 관리 논의 내용 추가
2. **README_EXECUTION_ORDER.md** - 패키지 시스템 설명 및 가이드 추가
3. **03_create_treatment_master_tables.sql** - 패키지 테이블 및 자동 분해 시스템 추가
4. **04_create_customer_treatments_table.sql** - 패키지 연동 및 분석 기능 추가
5. **05_create_settlements_table.sql** - 패키지 지원 정산 기능 추가
6. **06_create_calculated_views.sql** - 패키지 분석 뷰 및 대시보드 추가
7. **07_sample_data_and_usage.sql** - 패키지 샘플 데이터 및 고급 쿼리 추가

### 🎯 **다음 단계**
1. **Supabase에서 SQL 실행**: 01-07번 순서대로 실행
2. **패키지 테스트**: 샘플 데이터로 자동 분해 시스템 검증
3. **프론트엔드 개발**: 패키지 관리 UI 구축 시작 