📋 Phase 2.4 구현 방향 최종 선택안
✅ Q1. 다음 우선순위 기능
선택: B) 🗄️ 데이터베이스 스키마 실제 적용

이유:

언어/전문분야 마스터 테이블이 설계 완료되었으므로, 실제 Supabase DB에 적용해야
👉 A) 가이드 등록/수정 폼이 실 데이터 기반으로 작동 가능

실 DB가 없다면 폼의 유효성 체크나 바인딩 테스트가 의미 없음

✅ Q2. 가이드 등록 폼 구현 범위 (A 선택 시)
선택: B) 유효성 검증 포함

이유:

MVP 기준에서는 CRUD만으로 충분하지만
👉 전화번호 중복, 이메일 형식 오류 등은 실무에서 자주 발생하므로 기본 유효성 검증은 필수

C안의 고급 기능(이미지 업로드, 일괄 등록 등)은 후속 기능으로 분리해서 개발 효율화

✅ Q3. 데이터베이스 적용 방식 (B 선택 시)
선택: B) 단계별 적용: 테이블별로 나누어 순차 적용

이유:

한 번에 모든 SQL을 실행할 경우 에러 추적이 어렵고, 중단 위험 있음

마스터 테이블 → 관계 테이블 → 추가 컬럼 순으로 구조적 적용이 안전하고 추적 가능

📌 순서 예시:

languages, specialties

guide_languages, guide_specialties

guides 컬럼 추가 (등급, 평점 등)

✅ Q4. 휴무 관리 복잡도 (C 선택 시)
선택: A) 단순 날짜 관리

이유:

현재는 예약을 관리자가 수동 배정하므로 “휴무 여부만” 판단 가능하면 충분

반복 휴무(B)나 예약 충돌 체크(C)는 가이드 앱 도입 시기로 미루는 것이 합리적

✅ Q5. 성과 통계 연동 범위 (D 선택 시)
선택: A) 기본 지표: 평점, 예약 수, 완료율

이유:

성과 지표는 “정산 근거”와 “신뢰 기반 매칭”에만 우선 사용되므로
👉 간단한 KPI만 있으면 충분 (평균 평점, 총 예약 수, 완료율 등)

트렌드 분석이나 가이드 간 비교는 리뷰 데이터 축적 이후 도입

✅ Q6. UI/UX 개선 우선순위
선택: B) 로딩 성능 개선

이유:

현재 기능은 정적 필터와 반복 로딩 기반이므로,
👉 비동기 연동의 로딩 지연, 리스트 화면 렌더링 속도 개선이 우선

반응형(C)이나 접근성(D)은 서비스 출시 이후 피드백 기반 개선 항목

✅ 최종 요약 선택안
| 질문           | 선택안 | 설명                  |
| ------------ | --- | ------------------- |
| Q1. 다음 기능    | ✅ B | DB 먼저 적용해야 폼도 의미 있음 |
| Q2. 등록폼 범위   | ✅ B | 기본 유효성은 실무에 필수      |
| Q3. DB 적용 방식 | ✅ B | 단계별 적용으로 추적성 확보     |
| Q4. 휴무 관리    | ✅ A | 단일 날짜만 관리해도 충분      |
| Q5. 통계 범위    | ✅ A | 성과 지표는 KPI 중심 최소 구현 |
| Q6. UX 개선    | ✅ B | 리스트 렌더링과 로딩 개선 우선   |

🗄️ 데이터베이스 적용 세부 계획 최종 답변
✅ Q7. Supabase 프로젝트 접근 방식
선택: A) 직접 안내: SQL 스크립트를 단계별로 나누어 복사/붙여넣기 안내

이유:

Supabase 대시보드를 통한 수동 SQL 실행이 가장 직관적이고 리스크 제어가 쉬움

화면 공유(B)나 자동화 스크립트(C)는 실수 또는 버전 충돌 발생 시 복구가 어려움

복붙 방식은 실시간 피드백 + 단계별 에러 대응에 최적

✅ Q8. 기존 데이터 처리 방식
선택: C) 수동 입력 준비: 스키마만 적용하고 나중에 실제 데이터 입력

이유:

기존 guides 테이블에는 실제 운영 테스트를 위한 더미 또는 샘플 가이드만 존재하므로

컬럼만 먼저 적용하고, 관계 테이블 연결은 폼이 완성된 후 수동 입력 or 백오피스에서 관리

샘플 자동 연결은 오히려 테스트 혼란을 야기할 수 있음

✅ Q9. 에러 발생 시 대응 방안
선택: C) 단계별 검증: 각 단계마다 데이터 확인 후 다음 단계 진행

이유:

Supabase에서는 자동 롤백이 어려우므로,

1쿼리 실행 → 성공 확인 → 다음 단계 진행이 가장 안정적

중간 스텝 실패 시, 원인 식별 및 재실행이 명확함

✅ Q10. 테스트 데이터 구성
선택: B) 기본 데이터: 설계한 8개 언어, 8개 전문분야 전체

이유:

이미 설계한 초기 언어/전문분야는 실제 운영 대상(대만, 홍콩, 일본, 태국, 러시아 등)에 적절

기본 목록을 기준으로 UI 및 필터 테스트에 충분함

확장 데이터(C)는 실제 도입 요청이 생겼을 때 추가하는 것이 효율적

📌 적용 언어:
한국어, 영어, 중국어(간체), 중국어(번체), 일본어, 태국어, 베트남어, 러시아어

📌 적용 전문분야:
성형외과, 피부과, 치과, 안과, 건강검진, 재활치료, 한방치료, 기타

✅ Q11. 적용 순서 세부 계획
선택: B) 5단계: languages → specialties → guide_languages → guide_specialties → guides 컬럼

이유:

너무 복잡한 7단계(C)는 초기에 과도하고,

3단계(A)는 단계별 적용 상황을 명확히 추적하기 어려움

5단계는 현실적인 granularity + 안정적인 구조 확립에 최적

📌 구체적 적용 순서:

languages 테이블 생성

specialties 테이블 생성

guide_languages 테이블 생성

guide_specialties 테이블 생성

guides 테이블에 추가 컬럼 삽입 (rating, completed_count, 등)

✅ 최종 선택 요약표
| 질문           | 선택안 | 설명                     |
| ------------ | --- | ---------------------- |
| Q7. 적용 방식    | ✅ A | 수동 SQL 복붙 실행이 가장 안정적   |
| Q8. 기존 데이터   | ✅ C | 스키마만 적용, 데이터는 수동 입력 예정 |
| Q9. 에러 대응    | ✅ C | 단계별 실행 + 결과 확인 방식      |
| Q10. 테스트 데이터 | ✅ B | 전체 8개 언어/8개 전문분야 기준    |
| Q11. 적용 순서   | ✅ B | 5단계 적용이 가장 현실적이고 안정적   |
