# 🌿 브랜치 전략 가이드

## 📋 브랜치 전략 개요

### 🎯 Git Flow 기반 전략
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
└── hotfix/emergency-fixes (필요시)
```

### 🔄 브랜치 역할 정의

#### **main** (운영 브랜치)
- **목적**: 배포 가능한 안정적인 코드만 보관
- **규칙**: 직접 푸시 금지, PR만 허용
- **배포**: 이 브랜치에서만 프로덕션 배포
- **태그**: 릴리즈 버전 태깅 (v1.0.0, v1.1.0...)

#### **develop** (개발 통합 브랜치)
- **목적**: 일상적인 개발의 중심, "개발자의 main"
- **규칙**: 모든 feature 브랜치가 여기서 시작/병합
- **테스트**: 통합 테스트 및 기능 검증
- **문서**: 모든 핵심 문서 보관

#### **feature/** (기능 개발 브랜치)
- **목적**: 개별 기능 개발
- **명명**: `feature/기능명` (예: `feature/customer-management`)
- **시작점**: develop 브랜치에서 분기
- **병합**: develop 브랜치로 PR

#### **refactor/** (리팩토링 브랜치)
- **목적**: 기존 기능 개선
- **명명**: `refactor/대상명` (예: `refactor/reservations`)
- **시작점**: develop 브랜치에서 분기
- **병합**: develop 브랜치로 PR

#### **hotfix/** (긴급 수정 브랜치)
- **목적**: 운영 환경 긴급 수정
- **명명**: `hotfix/문제명` (예: `hotfix/payment-bug`)
- **시작점**: main 브랜치에서 분기
- **병합**: main과 develop 양쪽에 병합

---

## 🔄 표준 워크플로우

### 🚀 새 기능 개발 시

#### **1단계: 브랜치 생성**
```bash
# develop 브랜치로 이동 및 최신 상태 확인
git checkout develop
git pull origin develop

# 새 feature 브랜치 생성
git checkout -b feature/customer-management

# 원격에 브랜치 푸시
git push -u origin feature/customer-management
```

#### **2단계: 개발 진행**
```bash
# 작업 진행
# ... 개발 작업 ...

# 변경사항 커밋 (컨벤션 준수)
git add .
git commit -m "feat: implement customer registration form

- Add customer model with Freezed
- Implement validation logic
- Create responsive UI components
- Add integration with Supabase

Closes #123"

# 원격 브랜치에 푸시
git push origin feature/customer-management
```

#### **3단계: 병합 및 정리**
```bash
# develop 브랜치 최신 상태 확인 후 병합
git checkout develop
git pull origin develop
git merge feature/customer-management

# 원격 develop 업데이트
git push origin develop

# feature 브랜치 정리 (선택사항)
git branch -d feature/customer-management
git push origin --delete feature/customer-management
```

### 🔄 기존 기능 리팩토링 시

#### **브랜치 생성 및 작업**
```bash
git checkout develop
git pull origin develop
git checkout -b refactor/reservations

# 리팩토링 작업 진행
# ... 코드 개선 ...

git add .
git commit -m "refactor: integrate reservations with new customer system

- Update reservation form to use customer management
- Improve data validation
- Enhance UI consistency
- Add real-time customer search

Breaking Changes: None
Migration: Automatic"

git push origin refactor/reservations
```

### 🆘 긴급 수정 시

#### **핫픽스 워크플로우**
```bash
# main 브랜치에서 핫픽스 브랜치 생성
git checkout main
git pull origin main
git checkout -b hotfix/payment-calculation-bug

# 긴급 수정 작업
# ... 버그 수정 ...

git add .
git commit -m "fix: correct payment calculation in settlement

- Fix rounding error in commission calculation
- Add validation for negative amounts
- Update test cases

Fixes critical bug reported in #456"

# main 브랜치에 병합
git checkout main
git merge hotfix/payment-calculation-bug
git push origin main

# develop 브랜치에도 병합
git checkout develop
git merge hotfix/payment-calculation-bug
git push origin develop

# 핫픽스 브랜치 정리
git branch -d hotfix/payment-calculation-bug
git push origin --delete hotfix/payment-calculation-bug

# 버전 태그 추가
git tag v1.0.1
git push origin v1.0.1
```

---

## 💬 커밋 메시지 컨벤션

### 🎯 기본 형식
```
type(scope): subject

body

footer
```

### 📋 타입 정의

#### **feat**: 새로운 기능 추가
```bash
feat: add customer registration form
feat(auth): implement login with Supabase
```

#### **fix**: 버그 수정
```bash
fix: resolve calculation error in settlement
fix(ui): correct responsive layout on mobile
```

#### **refactor**: 코드 리팩토링
```bash
refactor: improve customer search performance
refactor(data): optimize database queries
```

#### **style**: 코드 스타일 변경
```bash
style: format code with prettier
style: fix linting warnings
```

#### **docs**: 문서 변경
```bash
docs: update API documentation
docs: add development setup guide
```

#### **test**: 테스트 코드 추가/수정
```bash
test: add unit tests for customer validation
test: update integration tests
```

#### **chore**: 기타 변경사항
```bash
chore: update dependencies
chore: configure build settings
```

### 📝 커밋 메시지 예시

#### **좋은 커밋 메시지**
```bash
feat: implement package decomposition system

- Add automatic package detection trigger
- Create weighted analysis for components
- Implement real-time analytics updates
- Add comprehensive test data

This enables automatic analysis of treatment packages
vs individual treatments for better business insights.

Closes #234
Refs #156
```

#### **나쁜 커밋 메시지**
```bash
# 너무 짧음
git commit -m "fix"

# 구체적이지 않음
git commit -m "update files"

# 여러 작업을 한 번에
git commit -m "fix bug and add feature and update docs"
```

---

## 🔀 Pull Request 가이드

### 📋 PR 생성 체크리스트

#### **코드 품질**
- [ ] global_rule.mdc 준수 100%
- [ ] 코드 중복 제거
- [ ] 네이밍 컨벤션 준수
- [ ] 주석 및 문서화 적절

#### **기능 검증**
- [ ] 모든 새 기능 정상 동작
- [ ] 기존 기능 영향 없음
- [ ] 에러 케이스 처리
- [ ] 반응형 UI 확인

#### **문서 업데이트**
- [ ] README 업데이트 (필요시)
- [ ] API 문서 업데이트 (필요시)
- [ ] 개발 로드맵 진행상황 업데이트

### 📝 PR 템플릿

```markdown
## 🎯 작업 내용
- [ ] 고객 등록 폼 구현
- [ ] 중복 검증 로직 추가
- [ ] Supabase 연동 완료

## 🔧 주요 변경사항
### 추가된 파일
- `lib/features/customers/data/models/customer_model.dart`
- `lib/features/customers/presentation/pages/customers_page.dart`

### 수정된 파일
- `lib/core/router/app_router.dart` (라우팅 추가)
- `docs/PROJECT_STATUS.md` (진행상황 업데이트)

## 🧪 테스트
- [x] 고객 등록 기능 테스트
- [x] 중복 검증 테스트
- [x] UI 반응형 테스트
- [x] 데이터베이스 연동 테스트

## 📸 스크린샷
(UI 변경사항이 있는 경우 스크린샷 첨부)

## 🔗 관련 이슈
Closes #123
Refs #456

## 📋 추가 노트
- 새로운 의존성: 없음
- Breaking Changes: 없음
- Migration 필요: 없음
```

---

## 🎯 브랜치별 개발 가이드

### 👥 feature/customer-management

#### **브랜치 목적**
고객 관리 시스템 완전 구현

#### **주요 작업**
- 고객 CRUD 기능
- 검색 및 필터링
- 시술 이력 조회
- 중복 고객 관리

#### **완료 조건**
- [ ] 모든 CRUD 기능 동작
- [ ] 검색/필터 정상 동작
- [ ] 중복 검증 시스템 완성
- [ ] global_rule.mdc 100% 준수

#### **브랜치 수명**
- **시작**: Phase 1 시작 시
- **종료**: 고객 관리 완전 구현 후
- **예상 기간**: 1-2주

### 💉 feature/treatment-management

#### **브랜치 목적**
패키지 시스템 활용 시술 관리

#### **주요 작업**
- 시술 입력 시스템
- 패키지 관리 인터페이스
- 분석 대시보드
- 자동 분해 시스템 UI

#### **완료 조건**
- [ ] 패키지 자동 감지 동작
- [ ] 분석 대시보드 완성
- [ ] 고객 관리와 완전 연동

#### **브랜치 수명**
- **시작**: customer-management 완료 후
- **종료**: 시술 관리 완전 구현 후
- **예상 기간**: 2-3주

### 💰 feature/settlement-management

#### **브랜치 목적**
가이드 등급 시스템 및 자동 정산

#### **주요 작업**
- 정산 처리 인터페이스
- 9단계 등급 시스템
- 수수료 자동 계산
- 월별 정산 관리

#### **완료 조건**
- [ ] 등급 시스템 완전 동작
- [ ] 자동 계산 정확성 검증
- [ ] 월별 리포트 생성

#### **브랜치 수명**
- **시작**: treatment-management 완료 후
- **종료**: 정산 관리 완전 구현 후
- **예상 기간**: 1-2주

---

## 🚨 충돌 해결 가이드

### 🔍 충돌 발생 시나리오

#### **시나리오 1: develop 업데이트 충돌**
```bash
# feature 브랜치에서 작업 중 develop이 업데이트된 경우
git checkout feature/customer-management
git fetch origin
git merge origin/develop

# 충돌 발생 시
# 1. 충돌 파일 수정
# 2. 수정 완료 후
git add .
git commit -m "resolve: merge conflicts with develop"
git push origin feature/customer-management
```

#### **시나리오 2: 동시 개발 충돌**
```bash
# 같은 파일을 다른 브랜치에서 수정한 경우
# 1. 먼저 병합된 브랜치의 변경사항 확인
# 2. 충돌 해결 시 비즈니스 로직 우선순위 고려
# 3. 필요시 다른 개발자와 상의 (개인 개발이므로 해당 없음)
```

### 🛠️ 충돌 해결 도구

#### **VS Code / Cursor 내장 도구**
- 충돌 마커 활용
- 변경사항 비교 도구
- 병합 도구 사용

#### **명령어 도구**
```bash
# 충돌 상태 확인
git status

# 충돌 파일 목록
git diff --name-only --diff-filter=U

# 병합 취소 (필요시)
git merge --abort
```

---

## 📊 브랜치 관리 모니터링

### 📈 브랜치 상태 추적

#### **정기 점검 항목**
- [ ] 오래된 feature 브랜치 정리
- [ ] develop 브랜치 안정성 확인
- [ ] main 브랜치 동기화 상태
- [ ] 미완료 PR 상태 점검

#### **자동화 스크립트 (향후)**
```bash
#!/bin/bash
# branch_cleanup.sh

# 30일 이상 된 원격 브랜치 조회
git for-each-ref --format='%(refname:short) %(committerdate)' refs/remotes | \
awk '$2 <= "'$(date -d '30 days ago' '+%Y-%m-%d')'"' | \
awk '{print $1}'

# 병합된 브랜치 자동 삭제
git branch --merged develop | grep -v "\* develop" | xargs -n 1 git branch -d
```

### 📋 브랜치 네이밍 규칙

#### **올바른 네이밍**
```
✅ feature/customer-management
✅ feature/treatment-analytics
✅ refactor/reservation-system
✅ hotfix/payment-bug-fix
✅ docs/api-documentation
```

#### **잘못된 네이밍**
```
❌ feature/fix
❌ new-feature
❌ customer_management
❌ Feature/Customer-Management
❌ feature/customer management (공백 포함)
```

---

## 🔄 릴리즈 관리

### 📦 버전 관리 전략

#### **시맨틱 버저닝**
```
v{MAJOR}.{MINOR}.{PATCH}

MAJOR: 호환성 없는 API 변경
MINOR: 하위 호환 기능 추가
PATCH: 하위 호환 버그 수정
```

#### **태그 관리**
```bash
# Phase 1 완료 시
git tag v1.0.0
git push origin v1.0.0

# 기능 추가 시
git tag v1.1.0
git push origin v1.1.0

# 버그 수정 시
git tag v1.0.1
git push origin v1.0.1
```

### 🚀 배포 프로세스

#### **develop → main 병합 조건**
- [ ] Phase 단위 완성
- [ ] 모든 기능 테스트 통과
- [ ] 1주일 develop 브랜치 사용 테스트
- [ ] 문서 업데이트 완료
- [ ] 백업 시스템 준비

#### **배포 체크리스트**
- [ ] 데이터베이스 마이그레이션 확인
- [ ] 환경변수 설정 확인
- [ ] 백업 완료
- [ ] 롤백 계획 수립
- [ ] 모니터링 시스템 준비

---

**📅 마지막 업데이트**: 2025-06-17
**🎯 현재 브랜치**: develop (문서화 완료)
**📞 다음 작업**: feature/customer-management 브랜치 생성 