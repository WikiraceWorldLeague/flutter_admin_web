# 🛣️ 개발 로드맵

## 📋 전체 개발 전략

### 🎯 개발 방식
- **개인 개발**: 협업 없이 단독 진행
- **점진적 개발**: 탭별로 순차 완성
- **브랜치 기반**: feature → develop → main 전략
- **문서 중심**: 모든 context를 문서로 관리

### 🔄 브랜치 전략
```
main (운영 배포용)
├── develop (통합 개발 브랜치)
│   ├── feature/customer-management
│   ├── feature/treatment-management
│   ├── feature/settlement-management
│   ├── feature/hospital-management
│   ├── refactor/reservations
│   ├── refactor/guides
│   └── feature/dashboard-enhancement
```

---

## 📅 Phase 1: 핵심 기능 구현 (우선순위)

### 🎯 Phase 1 목표
**새로운 패키지 시스템을 활용하는 핵심 비즈니스 기능 완성**

### 📋 Phase 1 스코프
```
완료 조건: 고객 등록 → 시술 입력 → 정산 처리의 전체 플로우 완성
예상 기간: 4-6주
```

---

## 1️⃣ **feature/customer-management** (1-2주)

### 🎯 개발 목표
고객 정보의 중앙 집중 관리 시스템 구축

### 📁 디렉토리 구조
```
lib/features/customers/
├── data/
│   ├── models/
│   │   ├── customer_model.dart
│   │   ├── customer_model.freezed.dart
│   │   └── customer_model.g.dart
│   ├── repositories/
│   │   └── customers_repository.dart
│   └── providers/
│       └── customers_providers.dart
├── domain/
│   └── customer_entities.dart
└── presentation/
    ├── pages/
    │   └── customers_page.dart
    ├── widgets/
    │   ├── customer_list_widget.dart
    │   ├── customer_form_dialog.dart
    │   ├── customer_detail_widget.dart
    │   ├── customer_search_widget.dart
    │   └── customer_history_widget.dart
    └── providers/
        └── customers_ui_providers.dart
```

### 🔧 주요 기능

#### **고객 CRUD**
- [x] 데이터베이스 스키마 (완료)
- [ ] 고객 모델 정의 (Freezed)
- [ ] Repository 패턴 구현
- [ ] Riverpod Provider 설정

#### **UI 컴포넌트**
- [ ] 고객 목록 페이지
- [ ] 고객 등록/수정 다이얼로그
- [ ] 고객 상세 정보 위젯
- [ ] 검색 및 필터링 위젯

#### **비즈니스 로직**
- [ ] 중복 고객 검증 로직
- [ ] 신규/재구매 고객 자동 판별
- [ ] 고객 ID 자동 생성 (여권명-국적-생년월일)

### 📊 DB 연동
```sql
-- 활용할 테이블: customers
-- 관련 뷰: customer_payment_summary
-- 트리거: 고객 정보 업데이트 시 자동 계산
```

### ✅ 완료 기준
- [ ] 고객 등록/수정/삭제/조회 모든 기능 동작
- [ ] 텍스트 검색 및 다중 필터링 동작
- [ ] 중복 고객 검증 시스템 동작
- [ ] 시술 이력 조회 기능 동작
- [ ] global_rule.mdc 준수 100%

---

## 2️⃣ **feature/treatment-management** (2-3주)

### 🎯 개발 목표
패키지 시스템을 활용한 시술 관리 및 분석 도구 구축

### 📁 디렉토리 구조
```
lib/features/treatments/
├── data/
│   ├── models/
│   │   ├── treatment_models.dart
│   │   ├── package_models.dart
│   │   └── analytics_models.dart
│   ├── repositories/
│   │   ├── treatments_repository.dart
│   │   └── packages_repository.dart
│   └── providers/
│       ├── treatments_providers.dart
│       └── packages_providers.dart
└── presentation/
    ├── pages/
    │   ├── treatments_page.dart
    │   └── package_management_page.dart
    ├── widgets/
    │   ├── treatment_entry_form.dart      # 핵심!
    │   ├── package_selector_widget.dart
    │   ├── package_definition_form.dart
    │   ├── analytics_dashboard.dart
    │   └── popularity_chart_widget.dart
    └── providers/
        └── treatments_ui_providers.dart
```

### 🔧 주요 기능

#### **시술 입력 시스템** (핵심!)
- [ ] 시술명 입력 시 패키지 자동 감지
- [ ] 패키지 선택 시 구성요소 표시
- [ ] 가격 입력 및 부가세 자동 계산
- [ ] 실시간 패키지 분해 결과 표시

#### **패키지 관리 시스템**
- [ ] 새 패키지 정의 인터페이스
- [ ] 구성요소 및 가중치 설정
- [ ] 분리 가능/불가능 패키지 구분
- [ ] 패키지 수정/삭제 기능

#### **분석 대시보드**
- [ ] 시술별 인기도 차트
- [ ] 패키지 vs 단일 시술 트렌드
- [ ] 매출 기여도 분석
- [ ] 시술 조합 패턴 분석

### 📊 DB 연동
```sql
-- 핵심 테이블: 
--   - treatment_packages, package_components
--   - customer_treatments, treatment_analytics
-- 핵심 뷰:
--   - treatment_popularity_analysis
--   - package_performance_analysis
--   - package_vs_single_analysis
```

### ✅ 완료 기준
- [ ] 시술 입력 시 패키지 자동 감지 동작
- [ ] 패키지 등록/수정/삭제 모든 기능 동작
- [ ] 자동 분해 트리거 정상 동작 확인
- [ ] 분석 대시보드 실시간 업데이트
- [ ] 고객 관리 탭과 완전 연동

---

## 3️⃣ **feature/settlement-management** (1-2주)

### 🎯 개발 목표
가이드 등급 시스템과 자동 정산 처리 시스템 구축

### 📁 디렉토리 구조
```
lib/features/settlements/
├── data/
│   ├── models/
│   │   ├── settlement_models.dart
│   │   ├── guide_tier_models.dart
│   │   └── commission_models.dart
│   ├── repositories/
│   │   └── settlements_repository.dart
│   └── providers/
│       └── settlements_providers.dart
└── presentation/
    ├── pages/
    │   └── settlements_page.dart
    ├── widgets/
    │   ├── settlement_form_dialog.dart
    │   ├── guide_tier_widget.dart
    │   ├── commission_calculator.dart
    │   ├── monthly_settlement_view.dart
    │   └── tier_upgrade_notification.dart
    └── providers/
        └── settlements_ui_providers.dart
```

### 🔧 주요 기능

#### **정산 처리 시스템**
- [ ] 예약별 정산 처리 인터페이스
- [ ] 시술 내역 입력 및 금액 계산
- [ ] 병원별 수수료율 자동 적용
- [ ] 가이드 수수료 (4.5%) 자동 계산

#### **가이드 등급 시스템**
- [ ] 9단계 등급 시스템 구현
- [ ] 누적 매출 기준 자동 등급 계산
- [ ] 등급별 보너스 (70만원) 적용
- [ ] 등급 변동 알림 시스템

#### **정산 관리 도구**
- [ ] 월별 정산 현황 조회
- [ ] 가이드별 정산 내역
- [ ] 정산 승인/완료 처리
- [ ] 정산서 생성 기능

### 📊 DB 연동
```sql
-- 핵심 테이블: settlements
-- 관련 뷰: 
--   - settlement_analysis
--   - monthly_settlement_summary
--   - guide_tier_calculation (새로 생성)
```

### ✅ 완료 기준
- [ ] 정산 프로세스 전체 플로우 완성
- [ ] 9단계 등급 시스템 정상 동작
- [ ] 자동 수수료 계산 정확성 검증
- [ ] 월별 정산 리포트 생성 기능
- [ ] 예약 관리 탭과 완전 연동

---

## 4️⃣ **feature/hospital-management** (1주)

### 🎯 개발 목표
병원 파트너 관리 및 수수료율 설정 시스템

### 📁 디렉토리 구조
```
lib/features/hospitals/
├── data/
│   ├── models/
│   │   └── hospital_models.dart
│   ├── repositories/
│   │   └── hospitals_repository.dart
│   └── providers/
│       └── hospitals_providers.dart
└── presentation/
    ├── pages/
    │   └── hospitals_page.dart
    ├── widgets/
    │   ├── hospital_list_widget.dart
    │   ├── hospital_form_dialog.dart
    │   ├── commission_rate_setting.dart
    │   └── hospital_performance_widget.dart
    └── providers/
        └── hospitals_ui_providers.dart
```

### 🔧 주요 기능

#### **병원 정보 관리**
- [ ] 병원 등록/수정/삭제
- [ ] 계약 정보 관리
- [ ] 전문 시술 분야 설정

#### **수수료율 관리**
- [ ] 병원별 개별 수수료율 설정 (15-20%)
- [ ] 수수료율 변경 이력 관리
- [ ] 정산 시 자동 적용 시스템

#### **성과 분석**
- [ ] 병원별 매출 현황
- [ ] 고객 만족도 연계
- [ ] 파트너십 평가 지표

### ✅ 완료 기준
- [ ] 병원 CRUD 모든 기능 동작
- [ ] 수수료율 설정/변경 시스템 완성
- [ ] 예약/정산 관리와 완전 연동
- [ ] 성과 분석 대시보드 완성

---

## 📊 Phase 1 통합 테스트

### 🔄 End-to-End 플로우 테스트
```
1. 고객 등록 (신규/재구매 판별)
2. 시술 입력 (패키지 자동 감지)
3. 정산 처리 (등급 시스템 적용)
4. 병원 수수료 계산
5. 모든 대시보드 실시간 업데이트
```

### ✅ Phase 1 완료 기준
- [ ] 모든 feature 브랜치가 develop에 머지 완료
- [ ] End-to-End 플로우 테스트 통과
- [ ] 패키지 시스템 완전 동작 확인
- [ ] 실제 데이터로 1주일 사용 테스트
- [ ] 문서 업데이트 완료

---

## 📅 Phase 2: 기존 기능 리팩토링 (2-3주)

### 🎯 Phase 2 목표
**기존 기능들을 새로운 시스템과 연동하여 일관성 확보**

---

## 5️⃣ **refactor/reservations** (1-2주)

### 🎯 리팩토링 목표
새로운 고객 관리 시스템과 완전 연동

### 🔧 주요 변경사항

#### **고객 정보 연동**
- [ ] 예약 생성 시 고객 관리 DB 활용
- [ ] 신규/재구매 고객 자동 구분 표시
- [ ] 고객 시술 이력 실시간 조회

#### **UI/UX 개선**
- [ ] 새로운 디자인 시스템 적용
- [ ] 필터링 기능 강화
- [ ] 반응형 디자인 적용

#### **비즈니스 로직 개선**
- [ ] 가이드 배정 로직 최적화
- [ ] 스케줄 충돌 검증 강화
- [ ] 예약 상태 관리 체계화

### ✅ 완료 기준
- [ ] 고객 관리 탭과 완전 연동
- [ ] 새로운 디자인 시스템 적용
- [ ] 모든 기존 기능 정상 동작
- [ ] 성능 개선 확인

---

## 6️⃣ **refactor/guides** (1주)

### 🎯 리팩토링 목표
등급 시스템과 정산 시스템 완전 연동

### 🔧 주요 변경사항

#### **등급 시스템 연동**
- [ ] 가이드별 실시간 등급 표시
- [ ] 진급 조건 및 진행률 표시
- [ ] 등급 변동 이력 관리

#### **성과 지표 강화**
- [ ] 패키지 시스템 기반 성과 분석
- [ ] 시술별 전문성 지표
- [ ] 고객 만족도 연계

### ✅ 완료 기준
- [ ] 정산 관리 탭과 완전 연동
- [ ] 등급 시스템 실시간 반영
- [ ] 성과 분석 기능 완성

---

## 7️⃣ **feature/dashboard-enhancement** (1주)

### 🎯 개발 목표
실시간 대시보드 및 고급 분석 기능

### 🔧 주요 기능

#### **실시간 메트릭스**
- [ ] 새로운 지표들 실시간 표시
- [ ] 패키지 vs 단일 시술 트렌드
- [ ] 가이드 등급 분포 현황

#### **TODO 리스트**
- [ ] 배정 대기 예약 알림
- [ ] 정산 처리 대기 알림
- [ ] 가이드 등급 변동 알림

#### **고급 차트**
- [ ] 매출 트렌드 라인 차트
- [ ] 시술 인기도 파이 차트
- [ ] 병원별 성과 바 차트

---

## 📅 Phase 3: 분석 및 관리 기능 (2-3주)

### 🎯 Phase 3 목표
**고급 분석 기능 및 관리 도구 완성**

---

## 8️⃣ **feature/financial-management** (1-2주)

### 🎯 개발 목표
종합 재무 분석 및 리포팅 시스템

### 🔧 주요 기능
- [ ] P&L 손익계산서 자동 생성
- [ ] 월별/분기별 재무 리포트
- [ ] 예측 분석 및 목표 관리
- [ ] Excel/PDF 리포트 내보내기

---

## 9️⃣ **feature/review-management** (1주)

### 🎯 개발 목표
고객 리뷰 수집 및 분석 시스템

### 🔧 주요 기능
- [ ] Google Form 연동 시스템
- [ ] 리뷰 분석 대시보드
- [ ] 만족도 트렌드 분석
- [ ] 개선 포인트 식별

---

## 🔄 배포 및 운영

### 📦 배포 전략
```
develop → main 머지 조건:
1. Phase별 모든 기능 완성
2. End-to-End 테스트 통과
3. 1주일 develop 브랜치 사용 테스트
4. 문서 업데이트 완료
```

### 🎯 운영 계획
- **주간 백업**: 자동 백업 시스템 구축
- **성능 모니터링**: 대시보드 로딩 시간 최적화
- **사용자 피드백**: 실제 사용 중 개선사항 수집

---

## 📋 브랜치별 체크리스트

### ✅ feature 브랜치 완료 조건
- [ ] 모든 기능 요구사항 구현
- [ ] global_rule.mdc 100% 준수
- [ ] 단위 테스트 작성 (필요시)
- [ ] 코드 리뷰 셀프 체크
- [ ] 문서 업데이트

### ✅ develop 머지 조건
- [ ] feature 브랜치 테스트 완료
- [ ] 다른 기능과의 충돌 없음
- [ ] 성능 이슈 없음
- [ ] UI/UX 일관성 확보

### ✅ main 배포 조건
- [ ] Phase 단위 완성
- [ ] 전체 시스템 안정성 확인
- [ ] 백업 시스템 준비
- [ ] 롤백 계획 수립

---

**📅 최종 목표**: 2025년 Q2 내 Phase 1-3 모든 기능 완성
**🎯 성공 지표**: 실제 비즈니스에서 안정적 사용 가능한 수준
**📞 지원**: Cursor + MCP 환경에서 완전 자립적 개발 가능 