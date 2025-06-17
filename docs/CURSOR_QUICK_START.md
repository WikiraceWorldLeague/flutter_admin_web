# 🚀 Cursor 새 채팅 시작 가이드

> **목적**: 새로운 PC 또는 새로운 채팅 세션에서 즉시 개발을 시작할 수 있도록 안내

## 1️⃣ 즉시 확인 체크리스트

### 📂 현재 위치 파악
```bash
# 현재 브랜치 확인
git branch

# 최신 상태 확인
git status
git log --oneline -5
```

### 📋 필수 파일 확인
- [ ] `global_rule.mdc` 존재 확인
- [ ] `docs/PROJECT_STATUS.md` 읽기
- [ ] 현재 브랜치에 맞는 작업 파일들 확인

## 2️⃣ Context 로딩 순서 (필수!)

### 🎯 Step 1: 핵심 문서 첨부
```
1. @docs/PROJECT_STATUS.md (현재 상태 파악)
2. @global_rule.mdc (코딩 규칙)
3. @docs/PRD.md (제품 요구사항)
```

### 🎯 Step 2: 작업별 추가 문서
```
고객 관리 개발 시:
- @docs/DEVELOPMENT_ROADMAP.md
- @lib/features/customers/ (있다면)

시술 관리 개발 시:
- @docs/TECHNICAL_ARCHITECTURE.md
- @improved_flows/ (DB 관련)

기존 기능 리팩토링 시:
- @lib/features/reservations/
- @lib/features/guides/
```

### 🎯 Step 3: MCP 연결 확인
- [ ] **Supabase MCP**: 프로젝트 ID `ojclqjfakodwlkzcguto` 연결 확인
- [ ] **Context7 MCP**: Flutter/Dart 문서 참조 가능 확인

## 3️⃣ 브랜치별 작업 시작 가이드

### 🌟 develop 브랜치에서 작업할 때
```bash
git checkout develop
git pull origin develop

# 새 feature 브랜치 생성 시
git checkout -b feature/feature-name
```

**첨부할 파일들:**
- @docs/PROJECT_STATUS.md
- @global_rule.mdc
- @docs/PRD.md
- @docs/DEVELOPMENT_ROADMAP.md

### 🔧 feature 브랜치에서 작업할 때
```bash
git checkout feature/브랜치명
git pull origin feature/브랜치명
```

**첨부할 파일들:**
- @docs/PROJECT_STATUS.md (현재 상태)
- @global_rule.mdc (코딩 규칙)
- 해당 feature 관련 문서들
- 관련된 기존 코드 파일들

## 4️⃣ 작업 유형별 빠른 시작

### 👥 고객 관리 개발
```
현재 상태: 미구현
다음 단계: feature/customer-management 브랜치 생성

필수 Context:
- @docs/PROJECT_STATUS.md
- @global_rule.mdc  
- @docs/PRD.md (6. 고객 관리 탭 섹션)
- @improved_flows/01_modify_customers_table.sql (DB 구조)
```

### 💉 시술 관리 개발
```
현재 상태: 미구현 (DB는 완성)
선행 조건: 고객 관리 완성 후

필수 Context:
- @docs/PROJECT_STATUS.md
- @improved_flows/03_create_treatment_master_tables.sql
- @improved_flows/04_create_customer_treatments_table.sql
- 패키지 시스템 관련 모든 SQL 파일
```

### 🔄 기존 기능 리팩토링
```
대상: 예약 관리, 가이드 관리, 대시보드
조건: 새 기능들 완성 후

필수 Context:
- 기존 코드: @lib/features/reservations/, @lib/features/guides/
- 새 시스템과의 연동 방법
```

## 5️⃣ 자주 사용하는 명령어

### 🔄 브랜치 작업
```bash
# 현재 상태 확인
git status
git branch -v

# 새 feature 시작
git checkout develop
git pull origin develop
git checkout -b feature/new-feature

# 작업 저장
git add .
git commit -m "feat: 작업 내용 설명"
git push origin feature/new-feature

# develop 업데이트
git checkout develop
git pull origin develop
git checkout feature/current-feature
git merge develop  # 필요시
```

### 🗄️ 데이터베이스 확인
```bash
# Supabase MCP로 테이블 확인
mcp_supabase_list_tables

# 특정 테이블 구조 확인
mcp_supabase_execute_sql "SELECT column_name, data_type FROM information_schema.columns WHERE table_name='customers'"
```

## 6️⃣ 문제 해결 가이드

### ❌ Context가 부족할 때
**증상**: AI가 프로젝트 구조를 모르거나 잘못된 제안을 할 때

**해결책**:
1. @docs/PROJECT_STATUS.md 다시 첨부
2. @global_rule.mdc 첨부
3. 현재 작업 중인 feature 관련 파일들 첨부

### ❌ 데이터베이스 연결 문제
**증상**: Supabase MCP가 동작하지 않을 때

**해결책**:
1. Supabase MCP 재연결 확인
2. 프로젝트 ID 확인: `ojclqjfakodwlkzcguto`
3. 권한 문제 시 재인증

### ❌ 브랜치 충돌
**증상**: 다른 PC에서 작업한 내용과 충돌

**해결책**:
```bash
git fetch origin
git status
git pull origin 현재브랜치명
# 충돌 해결 후
git add .
git commit -m "resolve: merge conflicts"
git push origin 현재브랜치명
```

## 7️⃣ 개발 플로우 체크리스트

### ✅ 작업 시작 전
- [ ] 올바른 브랜치에 있는가?
- [ ] 최신 상태로 pull 했는가?
- [ ] 필요한 문서들을 첨부했는가?
- [ ] MCP 연결이 정상인가?

### ✅ 작업 중
- [ ] global_rule.mdc 규칙을 따르고 있는가?
- [ ] 테스트 데이터로 확인했는가?
- [ ] 커밋 메시지가 명확한가?

### ✅ 작업 완료 후
- [ ] 모든 변경사항을 커밋했는가?
- [ ] push를 완료했는가?
- [ ] 다음 작업을 위한 메모를 남겼는가?

## 8️⃣ 응급 상황 대응

### 🆘 완전히 길을 잃었을 때
```
1. @docs/PROJECT_STATUS.md 읽기
2. git branch로 현재 위치 확인
3. git log --oneline -10으로 최근 작업 확인
4. 필요시 develop 브랜치로 이동해서 다시 시작
```

### 🆘 데이터베이스 상태가 불확실할 때
```
1. Supabase MCP로 테이블 목록 확인
2. @improved_flows/ SQL 파일들과 비교
3. 필요시 샘플 데이터 다시 실행
```

---

## 📞 도움 요청 시 포함할 정보

1. **현재 브랜치**: `git branch`
2. **최근 커밋**: `git log --oneline -5`
3. **작업 내용**: 무엇을 하려고 했는지
4. **오류 메시지**: 전체 오류 내용
5. **첨부된 파일들**: 어떤 context를 제공했는지

---
**🎯 이 가이드의 목적**: 어떤 상황에서도 5분 내에 작업을 시작할 수 있도록! 