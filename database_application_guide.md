# 🗄️ Phase 2.4 데이터베이스 스키마 적용 가이드

## 📋 개요
Phase 2.3에서 설계한 언어/전문분야 스키마를 실제 Supabase 데이터베이스에 단계별로 적용하는 가이드입니다.

## 🎯 적용 목표
- ✅ 8개 언어 마스터 테이블 생성
- ✅ 8개 전문분야 마스터 테이블 생성  
- ✅ 가이드-언어 다대다 관계 테이블 생성
- ✅ 가이드-전문분야 다대다 관계 테이블 생성
- ✅ guides 테이블에 성과 관련 컬럼 추가

## 📝 5단계 적용 순서

### 1️⃣ Step 1: languages 테이블 생성
**파일**: `step1_languages_table.sql`

**실행 방법**:
1. Supabase 대시보드 → SQL Editor 이동
2. `step1_languages_table.sql` 내용 복사/붙여넣기
3. 실행 후 결과 확인

**예상 결과**:
```
Step 1 완료: languages 테이블 생성됨 | 8
```

### 2️⃣ Step 2: specialties 테이블 생성
**파일**: `step2_specialties_table.sql`

**실행 방법**:
1. Step 1 성공 확인 후 진행
2. `step2_specialties_table.sql` 내용 복사/붙여넣기
3. 실행 후 결과 확인

**예상 결과**:
```
Step 2 완료: specialties 테이블 생성됨 | 8
```

### 3️⃣ Step 3: guide_languages 테이블 생성
**파일**: `step3_guide_languages_table.sql`

**실행 방법**:
1. Step 1, 2 성공 확인 후 진행
2. `step3_guide_languages_table.sql` 내용 복사/붙여넣기
3. 실행 후 결과 확인

**예상 결과**:
```
Step 3 완료: guide_languages 테이블 생성됨 | 0
```

### 4️⃣ Step 4: guide_specialties 테이블 생성
**파일**: `step4_guide_specialties_table.sql`

**실행 방법**:
1. Step 1, 2, 3 성공 확인 후 진행
2. `step4_guide_specialties_table.sql` 내용 복사/붙여넣기
3. 실행 후 결과 확인

**예상 결과**:
```
Step 4 완료: guide_specialties 테이블 생성됨 | 0
```

### 5️⃣ Step 5: guides 테이블 컬럼 추가
**파일**: `step5_guides_columns.sql`

**실행 방법**:
1. Step 1~4 성공 확인 후 진행
2. `step5_guides_columns.sql` 내용 복사/붙여넣기
3. 실행 후 결과 확인

**예상 결과**:
```
Step 5 완료: guides 테이블 컬럼 추가됨 | [기존 가이드 수]
```

## ⚠️ 주의사항

### 🔍 단계별 검증 필수
- 각 단계 완료 후 반드시 결과 확인
- 에러 발생 시 다음 단계 진행 금지
- 외래키 제약조건 확인 쿼리 실행

### 🚨 에러 대응 방안
1. **테이블 이미 존재** → `IF NOT EXISTS` 사용으로 안전
2. **외래키 제약조건 실패** → guides 테이블 존재 여부 확인
3. **데이터 타입 오류** → 스키마 재검토 후 수정

### 📊 데이터 확인 방법
각 단계마다 포함된 확인 쿼리 실행:
- 테이블 생성 확인
- 데이터 삽입 확인  
- 인덱스 생성 확인
- 외래키 관계 확인

## 🎉 완료 후 확인사항

### ✅ 전체 스키마 확인
```sql
-- 모든 테이블 존재 확인
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('languages', 'specialties', 'guide_languages', 'guide_specialties', 'guides')
ORDER BY table_name;
```

### ✅ 데이터 확인
```sql
-- 기본 데이터 확인
SELECT 'languages' as table_name, COUNT(*) as count FROM languages
UNION ALL
SELECT 'specialties', COUNT(*) FROM specialties
UNION ALL  
SELECT 'guide_languages', COUNT(*) FROM guide_languages
UNION ALL
SELECT 'guide_specialties', COUNT(*) FROM guide_specialties
UNION ALL
SELECT 'guides', COUNT(*) FROM guides;
```

## 🚀 다음 단계
스키마 적용 완료 후:
1. **가이드 등록 폼** 개발 시작
2. **언어/전문분야 선택** UI 연동
3. **유효성 검증** 로직 구현
4. **실제 데이터 입력** 테스트

---
**📅 작성일**: 2024년  
**🔄 업데이트**: Phase 2.4 스키마 적용 완료 시 