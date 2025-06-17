# 🗄️ 데이터베이스 현재 상태

## 📊 Supabase 프로젝트 정보

### 🔗 연결 정보
- **프로젝트 ID**: `ojclqjfakodwlkzcguto`
- **PostgreSQL 버전**: 17.4.1
- **지역**: 한국 (asia-northeast-1)
- **상태**: ✅ 운영 중 (안정)

### 🎯 현재 상태 요약
- **테이블 수**: 9개 (완전 구축)
- **패키지 시스템**: ✅ 100% 완성
- **트리거 시스템**: ✅ 모든 자동화 완료
- **분석 뷰**: ✅ 4개 뷰 구축
- **샘플 데이터**: ✅ 테스트 데이터 충분

---

## 📋 핵심 테이블 구조

### 1️⃣ **customers** (고객 정보) ✅
```sql
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE NOT NULL,
    nationality VARCHAR(5) NOT NULL,
    customer_code VARCHAR(50) UNIQUE NOT NULL,
    total_payment_amount DECIMAL(12,2) DEFAULT 0,
    visit_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2️⃣ **treatment_packages** (패키지 마스터) ✅
```sql
CREATE TABLE treatment_packages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    package_name VARCHAR(200) NOT NULL UNIQUE,
    is_separable BOOLEAN NOT NULL DEFAULT true,
    description TEXT,
    total_weight_percentage DECIMAL(5,2) DEFAULT 100.00,
    is_active BOOLEAN DEFAULT true
);
```

**현재 등록된 패키지:**
- ✅ '울쎄라600샷+써마지600샷' (분리 가능)
- ✅ '포텐자+쥬베룩스킨2cc' (분리 불가능)
- ✅ '필러3cc+보톡스300유닛+PRP' (분리 가능)
- ✅ '리프팅+골드PTT' (분리 불가능)

### 3️⃣ **customer_treatments** (고객 시술 이력) ✅
```sql
CREATE TABLE customer_treatments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    treatment_name VARCHAR(200) NOT NULL,
    treatment_price DECIMAL(10,2) NOT NULL,
    treatment_date DATE NOT NULL,
    is_package BOOLEAN DEFAULT false,
    package_id UUID REFERENCES treatment_packages(id)
);
```

### 4️⃣ **treatment_analytics** (시술 분석 데이터) ✅
```sql
CREATE TABLE treatment_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_treatment_id UUID NOT NULL REFERENCES customer_treatments(id),
    component_name VARCHAR(200) NOT NULL,
    original_package_name VARCHAR(200),
    weight_percentage DECIMAL(5,2) NOT NULL,
    weighted_price DECIMAL(10,2) NOT NULL,
    is_package_component BOOLEAN DEFAULT false
);
```

---

## ⚡ 자동화 트리거 시스템 (완성)

### 🔄 패키지 분해 트리거
**기능**: 시술 입력 시 자동으로 패키지 감지하여 구성요소별 분석 데이터 생성

**동작 과정**:
1. customer_treatments에 시술 추가
2. treatment_name을 패키지 테이블에서 검색
3. 매칭 시 package_components에서 구성요소 추출
4. 가중치 기반으로 가격 분배 계산
5. treatment_analytics에 분석 데이터 삽입

### 📊 고객 통계 업데이트 트리거
**기능**: 시술 추가 시 고객 정보 자동 업데이트

**업데이트 항목**:
- 총 결제금액 누적
- 방문 횟수 증가
- 신규/재구매 상태 갱신

---

## 📊 분석 뷰 시스템 (완성)

### 📈 **treatment_popularity_analysis**
시술별 인기도 및 매출 기여도 분석

### 📦 **package_performance_analysis**
패키지별 사용률 및 성과 분석

### ⚖️ **package_vs_single_analysis**
패키지 vs 단일 시술 비교 분석

### 📅 **monthly_dashboard_metrics**
월별 대시보드 핵심 지표

---

## 🔍 성능 최적화 (완성)

### 📊 주요 인덱스
```sql
-- 고객 관련
CREATE INDEX idx_customers_customer_code ON customers(customer_code);
CREATE INDEX idx_customers_name ON customers(name);

-- 시술 관련
CREATE INDEX idx_customer_treatments_customer_id ON customer_treatments(customer_id);
CREATE INDEX idx_customer_treatments_date ON customer_treatments(treatment_date);

-- 분석 관련
CREATE INDEX idx_treatment_analytics_component ON treatment_analytics(component_name);
```

---

## 🧪 현재 테스트 데이터

### 👥 고객 데이터: 3명
- 김지영 (한국인, 신규)
- 张伟 (중국인, 재구매)
- 田中美咲 (일본인)

### 💉 시술 데이터: 6건
- 패키지 시술 4건
- 단일 시술 2건

### 🏥 병원 데이터: 2개
- 강남뷰티클리닉 (18% 수수료)
- 압구정메디컬센터 (15.5% 수수료)

---

## 🔧 자주 사용하는 쿼리

### 📊 시스템 상태 확인
```sql
-- 테이블별 레코드 수
SELECT tablename, n_tup_ins as "행 수"
FROM pg_stat_user_tables
ORDER BY tablename;

-- 패키지 시스템 동작 확인
SELECT tp.package_name, COUNT(ct.id) as usage_count
FROM treatment_packages tp
LEFT JOIN customer_treatments ct ON tp.id = ct.package_id
GROUP BY tp.package_name;
```

### 🧪 트리거 테스트
```sql
-- 새 시술 추가 (트리거 동작 확인)
INSERT INTO customer_treatments (
    customer_id, treatment_name, treatment_price, treatment_date
) VALUES (
    (SELECT id FROM customers LIMIT 1),
    '울쎄라600샷+써마지600샷', 4500000, CURRENT_DATE
);

-- 자동 분해 결과 확인
SELECT * FROM treatment_analytics 
WHERE customer_treatment_id = (
    SELECT id FROM customer_treatments 
    ORDER BY created_at DESC LIMIT 1
);
```

---

## 🚨 중요 주의사항

### ⚠️ 데이터 무결성
- **외래키 제약**: 모든 참조 관계 검증
- **체크 제약**: 잘못된 값 입력 방지
- **유니크 제약**: 중복 데이터 방지

### 🔒 보안 설정
- **RLS**: Row Level Security 활성화
- **인증**: Supabase Auth 기반 접근 제어
- **권한**: 인증된 사용자만 CRUD 가능

---

## 🎯 프론트엔드 연동 준비 완료

### ✅ 완료된 작업
- [x] 모든 테이블 스키마 완성
- [x] 패키지 시스템 완전 구축
- [x] 트리거 시스템 구축
- [x] 분석 뷰 생성
- [x] 테스트 데이터 준비
- [x] 인덱스 최적화

### 📱 다음 단계
1. **feature/customer-management** 브랜치 시작
2. Supabase 클라이언트 설정
3. 고객 모델 정의 (Freezed)
4. Repository 패턴 구현

---

**📅 마지막 업데이트**: 2025-06-17  
**🎯 상태**: 데이터베이스 100% 완성 (개발 준비 완료)  
**📞 Supabase MCP**: 정상 연결 확인 