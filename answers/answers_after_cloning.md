✅ 작동 중인 기능 (보존 대상)
예약 관리 (Reservation)
예약 목록 조회는 Supabase DB와 연동되어 정상 작동

삭제 요청은 DB에 반영되지만 UI에서는 실시간 반영되지 않음 (새로고침 필요)

필터링 기능 미작동

예약 추가/수정 기능 미구현

예약에 연결된 고객 데이터가 **조인되지 않아 '고객 0명'**으로 표시됨

가이드 관리 (Guide)
가이드 목록 조회는 정상 작동

가이드 등록은 Supabase에 잘 반영됨, 그러나 등록 후 목록 자동 반영 X (새로고침 필요)

필터링 기능은 console 상 이벤트는 발생하나, UI에 반영되지 않음

status 필터는 일부 반응하나 실제 상태값과 불일치

기타
네비게이션 사이드바 탭 이동 정상 작동

정산/리뷰 탭은 아직 기능 없음 (정산은 하드코딩된 UI만 존재)

🛡️ 보호해야 할 사항 (건드리지 말아야 할 부분)
✅ UI 구조 (각 관리 탭 공통)
UI 상단 → 하단 순서 유지 필수:

상단: 등록/추가 버튼

그 아래: 필터링

중간: 대시보드 요약 카드

하단: 목록 (ListView 또는 GridView)

이 구조는 예약, 가이드, 정산, 리뷰 탭 전체 공통 적용이므로 절대 변경 금지

✅ 상태 관리 로직
현재 예약/가이드 폼 및 리스트 상태 관리는 Riverpod (StateNotifier) 기반
→ 기존 Notifier 및 Provider 구조를 유지하면서 확장 필요
예: GuideFormNotifier, ReservationListNotifier 등

✅ 라우팅
GoRouter를 기반으로 현재 '/guides', '/reservations' 등 기본 구조가 정상 작동 중
→ 기존 router.dart의 Route path 및 구조는 보존, 단 페이지 추가는 가능

🛠️ 앞으로 추가할 기능 (계획 정리)
🎯 목표: Phase 2.5.2 - 가이드 등록/수정 폼
기존 코드와 완전히 분리되어 모듈화된 구조로 개발하는 것이 목표

GuideFormPage 또는 GuideEditorPanel 컴포넌트는
presentation/widgets 또는 presentation/pages 내에서 독립적으로 구성

guide_form_state.dart, guide_form_notifier.dart는 domain/ 또는 state/ 폴더 내 유지

기존 guide_list_view.dart나 guides_management_page.dart에는 직접 수정 없이 통합하는 방식 선호