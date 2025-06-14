🔧 Phase 2.5.2: 가이드 등록/수정 폼 구현 세부사항 — 최종 선택안
📝 Q9. 폼 섹션 구성 순서
✅ A) 📋 기본 정보 우선형

이유:

관리자는 가장 먼저 **신원 확인 가능한 기본 정보(이름, 연락처, 이메일)**를 확인하고자 함

언어/전문분야는 기초 정보 이후 역량 영역으로 자연스럽게 배치

"프로필 이미지/소개"는 부가 정보로 마지막에 배치하는 것이 실무 흐름상 맞음

📌 섹션 구조 예시:

기본 정보 (닉네임, 성별, 생년월일, 전화번호, 이메일)

언어 능력

전문분야

프로필 이미지 / 자기소개

🌐 Q10. 언어 동적 추가 UI 상세
✅ A) ➕ 인라인 추가 방식

이유:

가장 직관적이고, 입력 속도도 빠름

모달 방식은 입력 피로도가 커지고 흐름이 끊김

테이블 방식은 작은 화면에서 불편하고 시각적 부담 큼

📌 구성 예시:

plaintext
복사
편집
[언어 ▼] [숙련도 ▼] [+ 추가]
─────────────────────────────
✅ 한국어 - 원어민     [삭제]
✅ 영어 - 고급         [삭제]
🏥 Q11. 전문분야 카드 UI 상세
✅ B) 🏷️ Chip 태그 방식

이유:

선택/비선택 상태가 명확하며, 클릭만으로 선택 가능

드래그/리스트보다 UX 밀도 높고 구현 단가도 낮음

Chip에 체크 아이콘 또는 강조색으로 시각적 피드백 가능

📌 구성 예시:

plaintext
복사
편집
[성형외과 ✓] [피부과] [치과 ✓] [안과]  
[건강검진] [재활치료 ✓] [한방치료] [기타]
✅ Q12. 유효성 검증 실시간 피드백
✅ A) 🔴 필드 하단 메시지

이유:

관리자가 즉시 시각적으로 오류 인지 가능

테두리+툴팁 방식(B)은 모바일/태블릿에서 불편

상단 알림(C)은 오류 위치 추적이 어렵고 산만함

📌 예시:

plaintext
복사
편집
[이메일 입력]
❌ 올바른 이메일 형식이 아닙니다
💾 Q13. 저장 버튼 구성
✅ A) 🎯 단순 저장: [취소] [저장]

이유:

복잡한 상태 변경은 추후 확장 가능성에 대비하고

현재는 최소 기능으로 깔끔하게 일괄 저장이 관리자 입장에서 더 직관적

임시저장, 다음 등록은 리스트 화면에서 처리하는 것이 명확

🎨 Q14. 비즈니스 스타일 컬러 테마
✅ C) ⚫ 그레이 계열 - 중성적, 모던

이유:

하이퍼커넥티드의 브랜딩 톤(정갈한 부티크 호텔 감성, 병원 UI 탈피)과 일치

의료=블루/그린은 너무 익숙하여 병원 UI와 유사하게 느껴질 수 있음

그레이 계열은 세련되고 브랜드 무드를 유지하면서도 전문성 강조

📌 예시 컬러:

배경: #F8F9FA,

기본 텍스트: #212529,

포인트: #6C757D 또는 #495057

✅ 최종 요약 선택안
| 질문            | 선택  | 설명                    |
| ------------- | --- | --------------------- |
| Q9. 폼 섹션 순서   | ✅ A | 기본 정보 → 언어 → 전문 → 프로필 |
| Q10. 언어 입력 UI | ✅ A | 드롭다운 + 추가 버튼 (인라인)    |
| Q11. 전문분야 UI  | ✅ B | Chip 방식 (선택 직관적)      |
| Q12. 유효성 피드백  | ✅ A | 하단 오류 메시지 방식          |
| Q13. 저장 버튼    | ✅ A | 단순 저장 + 취소            |
| Q14. 컬러 테마    | ✅ C | 모던/그레이, 브랜드 감성 일치     |

📋 Phase 2.5.3 구현 계획 — 최종 선택안
✅ 선택: A) 📊 폼 상태 관리부터 - Riverpod 기반 상태 관리 구조 먼저 구축
이유:

가장 중요한 기준: UI는 상태에 따라 동작한다.

GuideFormState와 GuideFormNotifier의 구조가 먼저 잡혀야
👉 각 섹션 컴포넌트들이 ref.watch(), ref.read()로 안정적으로 동작함

UI 먼저 만들면 추후 상태/유효성 로직에 맞춰 수정해야 할 가능성이 큼

🚀 구체적인 작업 순서 추천
1. 📊 상태 관리 컴포넌트부터
guide_form_state.dart: GuideFormState 데이터 클래스 정의

guide_form_notifier.dart: StateNotifier<GuideFormState> + 유효성 포함

guide_form_provider.dart: final guideFormProvider = StateNotifierProvider...

2. 🛡️ 유효성 검증 로직 내장
GuideFormNotifier 안에 다음 유효성 검증 포함:

이메일 형식

전화번호 형식

닉네임/이메일/전화번호 중복 체크용 async validator 함수 준비

3. 🎨 UI 컴포넌트 구현 (상태 관리 이후)
GuideFormPage: 전체 scaffold와 저장 버튼 포함

BasicInfoSection, LanguageSkillsSection, SpecialtiesSection, ProfileSection:
→ ref.watch(guideFormProvider)를 통해 각 섹션별 상태 반영

4. 💾 저장 액션 구현
onSave() 시 모든 필드 검증 후 Supabase에 등록/수정 요청

저장 성공 → 스낵바 → 리스트 페이지로 이동

🎉 Phase 2.5.3 Step 2: UI 컴포넌트 구현 — 최종 선택안
✅ 선택: A) 🎨 메인 폼 페이지부터 - 전체 레이아웃과 섹션 구조 먼저
이유:

전체 구조를 먼저 설계해야 개별 섹션들이 어떻게 배치되고 연결될지 명확히 파악 가능

화면 비율, 스크롤 동작, 저장 버튼 위치, 섹션 간 마진 등 전체 레이아웃 컨텍스트 없이 각 섹션 단독 구현은 리팩터링 위험

특히, GuideFormPage가 상태 제공자(Riverpod)를 어떻게 구독하고, 섹션별 위젯을 어떻게 ref와 연결하는지가 핵심 구조

🧩 Step 2 상세 구현 순서 추천
1. GuideFormPage Scaffold 구성
상단 페이지 제목 + 저장 버튼 포함 (AppBar or SliverAppBar)

본문은 SingleChildScrollView + Column

그레이톤 모던 테마 반영

저장 버튼은 Align(alignment: Alignment.centerRight) 방식 하단 고정 또는 Floating

2. 섹션 위젯 골격 삽입
BasicInfoSection(), LanguageSkillsSection(), SpecialtiesSection(), ProfileSection()
👉 현재는 placeholder로 Container(height: 200, child: Text('섹션명'))

3. 저장 버튼 로직
ref.read(guideFormProvider.notifier).submit() 구조 연동

유효성 통과 + Snackbar → 리스트 페이지 이동

📌 이 구조가 완성되면 👉 각 섹션 위젯에 세부 필드/폼 추가하기 훨씬 수월해집니다.

🎯 Phase 2.5.3 Step 3: 개별 섹션 구현 — 최종 선택안
✅ 선택: A) 📋 기본 정보 섹션부터 - 폼 필드와 유효성 검증 구현
이유:

기본 정보는 모든 입력 흐름의 시작점이며,
👉 이후의 언어/전문분야/프로필 입력은 기본 정보가 먼저 저장된 상태여야 의미 있음

실시간 유효성 검증(이메일 형식, 전화번호 형식, 중복 체크) 로직도
👉 이후 섹션에서 재사용하거나 연계되므로 가장 먼저 구현하는 것이 구조상 유리

🧩 기본 정보 섹션 구현 항목
필드 목록:

닉네임 (TextFormField)

성별 (DropdownButtonFormField)

생년월일 (DatePicker or TextFormField)

전화번호 (TextFormField) + 실시간 형식/중복 검증

이메일 (TextFormField) + 실시간 형식/중복 검증

검증 방식:

guideFormNotifier.validateEmail() / validatePhone()

오류 메시지는 각 필드 하단에 실시간 표시 (Q12-A 방식)

스타일 적용:

Material 3 + 비즈니스 스타일 (Gray theme)

좌우 여백 + 섹션 제목 고정: "기본 정보"