import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../reservations/data/providers.dart';
import 'guides_repository.dart';

// 가이드 저장소 프로바이더
final guidesRepositoryProvider = Provider<GuidesRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GuidesRepository(supabase);
});

// 가이드 페이지 상태 프로바이더
final guidePageProvider = StateProvider<int>((ref) => 1);

// 가이드 페이지 크기 프로바이더
final guidePageSizeProvider = StateProvider<int>((ref) => 12);

// 가이드 검색어 프로바이더
final guideSearchQueryProvider = StateProvider<String>((ref) => '');

// 가이드 필터 프로바이더들
final guideStatusFilterProvider = StateProvider<String?>((ref) => null);
final guideLanguageFilterProvider = StateProvider<String?>((ref) => null);
final guideSpecialtyFilterProvider = StateProvider<String?>((ref) => null);
final guideGradeFilterProvider = StateProvider<String?>((ref) => null);

// 가이드 뷰 모드 프로바이더 (그리드/리스트)
final guideViewModeProvider = StateProvider<GuideViewMode>((ref) => GuideViewMode.grid);

// 가이드 목록 프로바이더
final guidesProvider = FutureProvider.autoDispose<PaginatedGuides>((ref) async {
  final repository = ref.watch(guidesRepositoryProvider);
  final page = ref.watch(guidePageProvider);
  final pageSize = ref.watch(guidePageSizeProvider);
  final searchQuery = ref.watch(guideSearchQueryProvider);
  final status = ref.watch(guideStatusFilterProvider);
  final language = ref.watch(guideLanguageFilterProvider);
  final specialty = ref.watch(guideSpecialtyFilterProvider);
  final grade = ref.watch(guideGradeFilterProvider);

  return await repository.getGuides(
    page: page,
    pageSize: pageSize,
    searchQuery: searchQuery.isEmpty ? null : searchQuery,
    status: status,
    language: language,
    specialty: specialty,
    grade: grade,
  );
});

// 가이드 통계 프로바이더
final guideStatsProvider = FutureProvider.autoDispose<GuideStats>((ref) async {
  final repository = ref.watch(guidesRepositoryProvider);
  return await repository.getGuideStats();
});

// 선택된 가이드 프로바이더 (상세 모달용)
final selectedGuideProvider = StateProvider<String?>((ref) => null);

// 가이드 뷰 모드 enum
enum GuideViewMode {
  grid,
  list,
} 