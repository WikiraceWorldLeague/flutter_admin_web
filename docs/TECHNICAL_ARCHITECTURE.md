# 🏗️ 기술 아키텍처

## 📖 전체 시스템 구조

### 🎯 아키텍처 개요
```
┌─────────────────────────────────────────┐
│               Flutter Web               │
├─────────────────────────────────────────┤
│ State Management: Riverpod + Hooks      │
├─────────────────────────────────────────┤
│ Data Layer: Repository Pattern          │
├─────────────────────────────────────────┤
│ Network: Supabase Client                │
├─────────────────────────────────────────┤
│ Backend: Supabase (PostgreSQL)          │
└─────────────────────────────────────────┘
```

### 🔧 기술 스택 상세

#### **Frontend**
- **프레임워크**: Flutter Web (Dart 3.x)
- **상태관리**: Riverpod 2.x + Flutter Hooks
- **데이터 모델**: Freezed + json_annotation
- **라우팅**: go_router
- **UI 컴포넌트**: Custom Admin Dashboard

#### **Backend**
- **플랫폼**: Supabase
- **데이터베이스**: PostgreSQL 17.4.1
- **인증**: Supabase Auth
- **실시간**: Supabase Realtime
- **스토리지**: Supabase Storage (필요시)

#### **개발 도구**
- **IDE**: Cursor with MCP integrations
- **버전 관리**: Git + GitHub
- **빌드 도구**: Flutter Web build
- **배포**: Supabase Hosting (예정)

---

## 📁 프로젝트 구조

### 🎯 디렉토리 아키텍처
```
lib/
├── core/                          # 핵심 설정 및 공통 기능
│   ├── config/
│   │   ├── supabase_config.dart   # Supabase 연결 설정
│   │   └── app_config.dart        # 앱 전체 설정
│   ├── router/
│   │   └── app_router.dart        # 라우팅 설정
│   ├── theme/
│   │   └── app_theme.dart         # 테마 및 디자인 시스템
│   ├── constants/
│   │   ├── api_constants.dart     # API 상수
│   │   └── app_constants.dart     # 앱 상수
│   └── utils/
│       ├── date_utils.dart        # 날짜 유틸리티
│       ├── currency_utils.dart    # 금액 계산 유틸리티
│       └── validation_utils.dart  # 입력 검증 유틸리티
├── features/                      # 기능별 모듈
│   ├── auth/                      # 인증 기능
│   ├── customers/                 # 고객 관리 (신규)
│   ├── treatments/                # 시술 관리 (신규)
│   ├── settlements/               # 정산 관리 (신규)
│   ├── hospitals/                 # 병원 관리 (신규)
│   ├── reservations/              # 예약 관리 (기존)
│   ├── guides/                    # 가이드 관리 (기존)
│   ├── reviews/                   # 리뷰 관리 (기존)
│   └── dashboard/                 # 대시보드 (기존)
├── shared/                        # 공유 컴포넌트
│   ├── widgets/
│   │   ├── common/                # 공통 위젯
│   │   ├── layout/                # 레이아웃 위젯
│   │   ├── forms/                 # 폼 관련 위젯
│   │   └── charts/                # 차트 위젯
│   ├── models/                    # 공유 데이터 모델
│   └── services/                  # 공유 서비스
└── main.dart                      # 앱 엔트리 포인트
```

### 🔧 Feature 모듈 구조 (예: customers)
```
features/customers/
├── data/                          # 데이터 레이어
│   ├── models/                    # 데이터 모델 (Freezed)
│   ├── repositories/              # 데이터 접근 계층
│   └── providers/                 # 데이터 프로바이더
├── domain/                        # 도메인 레이어
│   └── entities/                  # 비즈니스 엔티티
└── presentation/                  # 프레젠테이션 레이어
    ├── pages/                     # 페이지
    ├── widgets/                   # 위젯
    └── providers/                 # UI 상태 프로바이더
```

---

## 🗄️ 데이터베이스 아키텍처

### 📊 현재 테이블 구조 (완성됨)
```sql
-- 핵심 비즈니스 테이블
customers                # 고객 정보 ✅
reservations             # 예약 정보 ✅
guides                   # 가이드 정보 ✅
clinics                  # 파트너 병원 정보 ✅
settlements              # 정산 정보 ✅
reviews                  # 고객 리뷰 ✅

-- 패키지 관리 시스템 (신규 완성) ✅
treatment_packages       # 패키지 마스터
package_components       # 패키지 구성요소
customer_treatments      # 고객 시술 이력
treatment_analytics      # 시술 분석 데이터
```

### 🔗 테이블 관계도
```
customers ──── reservations ──── guides
    │               │
    │               └── settlements
    │
    └── customer_treatments ──── treatment_packages
                   │                    │
                   │                    └── package_components
                   │
                   └── treatment_analytics
```

### 🔄 자동화 트리거 시스템 (구현 완료)

#### **패키지 분해 트리거**
- 시술 입력 시 패키지명 자동 감지
- 패키지 구성요소별 자동 분해
- 가중치 기반 분석 데이터 생성
- treatment_analytics 테이블 자동 업데이트

#### **고객 정보 업데이트 트리거**
- 시술 추가 시 고객 총 결제금액 자동 업데이트
- 방문 횟수 자동 증가
- 신규/재구매 상태 자동 판별

### 📊 분석 뷰 시스템 (구현 완료)

#### **주요 분석 뷰들**
- `treatment_popularity_analysis`: 시술 인기도 분석
- `package_performance_analysis`: 패키지 성과 분석
- `package_vs_single_analysis`: 패키지 vs 단일 시술 비교
- `monthly_dashboard_metrics`: 월별 대시보드 지표

---

## 🔧 상태 관리 아키텍처

### 🎯 Riverpod 프로바이더 구조

#### **기본 패턴**
```dart
// 1. Repository 프로바이더
final customersRepositoryProvider = Provider<CustomersRepository>((ref) {
  return CustomersRepository(supabase: Supabase.instance.client);
});

// 2. 상태 프로바이더
final customersProvider = StateNotifierProvider<CustomersNotifier, AsyncValue<List<Customer>>>((ref) {
  return CustomersNotifier(ref.read(customersRepositoryProvider));
});

// 3. UI 상태 프로바이더
final customersPageStateProvider = StateProvider<CustomersPageState>((ref) {
  return const CustomersPageState();
});
```

#### **검색 및 필터링 패턴**
```dart
// 검색어 프로바이더
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

// 필터 프로바이더
final customerFiltersProvider = StateProvider<CustomerFilters>((ref) {
  return const CustomerFilters();
});

// 필터링된 결과
final filteredCustomersProvider = Provider<List<Customer>>((ref) {
  final customers = ref.watch(customersProvider).valueOrNull ?? [];
  final searchQuery = ref.watch(customerSearchQueryProvider);
  final filters = ref.watch(customerFiltersProvider);
  
  return _applyFilters(customers, searchQuery, filters);
});
```

### 🔄 데이터 플로우
```
User Input → UI State Provider → Business Logic → Repository → Supabase
          ←                   ← StateNotifier  ← Response    ←
```

---

## 🎨 UI/UX 아키텍처

### 🎯 디자인 시스템

#### **컬러 팔레트**
```dart
class AppColors {
  // Primary Colors
  static const primary = Color(0xFF2563EB);      // Blue-600
  static const primaryDark = Color(0xFF1D4ED8);   // Blue-700
  static const primaryLight = Color(0xFF3B82F6);  // Blue-500
  
  // Neutral Colors
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray500 = Color(0xFF6B7280);
  static const gray900 = Color(0xFF111827);
  
  // Status Colors
  static const success = Color(0xFF10B981);       // Green-500
  static const warning = Color(0xFFF59E0B);       // Amber-500
  static const error = Color(0xFFEF4444);         // Red-500
  static const info = Color(0xFF3B82F6);          // Blue-500
}
```

#### **컴포넌트 계층구조**
```
Pages (전체 화면)
├── Sections (화면 영역)
│   ├── Widgets (재사용 컴포넌트)
│   │   ├── Atoms (기본 요소)
│   │   ├── Molecules (조합 요소)
│   │   └── Organisms (복합 요소)
│   └── Dialogs (모달/다이얼로그)
└── Layouts (레이아웃 템플릿)
```

---

## 🔒 보안 아키텍처

### 🛡️ 인증 및 권한 관리

#### **Supabase Auth 통합**
```dart
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
```

#### **Row Level Security (RLS)**
```sql
-- 예: customers 테이블 보안 정책
CREATE POLICY "Users can view all customers" ON customers
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert customers" ON customers
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
```

---

## 📊 성능 최적화

### ⚡ 프론트엔드 최적화

#### **지연 로딩 및 캐싱**
```dart
// Riverpod keepAlive로 데이터 캐싱
final customersProvider = FutureProvider.autoDispose.family<List<Customer>, CustomerFilters>((ref, filters) async {
  ref.keepAlive();
  Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  
  return ref.read(customersRepositoryProvider).getCustomers(filters);
});
```

### 🗄️ 데이터베이스 최적화

#### **인덱스 설정 (구현 완료)**
```sql
-- 핵심 인덱스들
CREATE INDEX idx_customers_customer_code ON customers(customer_code);
CREATE INDEX idx_customers_name ON customers(name);
CREATE INDEX idx_customer_treatments_customer_id ON customer_treatments(customer_id);
CREATE INDEX idx_customer_treatments_date ON customer_treatments(treatment_date);
```

---

## 🔧 개발 환경 설정

### 📋 필수 도구

#### **핵심 의존성**
```yaml
# pubspec.yaml 주요 의존성
dependencies:
  flutter: sdk: flutter
  riverpod: ^2.4.9
  flutter_riverpod: ^2.4.9
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  supabase_flutter: ^2.0.0
  go_router: ^12.1.3
  flutter_hooks: ^0.20.3

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
```

---

**📅 마지막 업데이트**: 2025-06-17
**🎯 상태**: 데이터베이스 100% 완성, 프론트엔드 개발 준비 완료
**📞 기술 지원**: Cursor + Supabase MCP + Context7 MCP 