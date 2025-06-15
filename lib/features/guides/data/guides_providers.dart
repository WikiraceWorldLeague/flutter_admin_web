import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../../reservations/domain/reservation_models.dart'
    hide Language, Specialty;
import 'language_specialty_models.dart';
import 'guides_repository.dart';
import 'language_specialty_repository.dart';

// Supabase 클라이언트 프로바이더
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// 가이드 저장소 프로바이더
final guidesRepositoryProvider = Provider<GuidesRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GuidesRepository(supabase);
});

// 언어/전문분야 저장소 프로바이더
final languageSpecialtyRepositoryProvider =
    Provider<LanguageSpecialtyRepository>((ref) {
      final supabase = ref.watch(supabaseClientProvider);
      return LanguageSpecialtyRepository(supabase);
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
final guideViewModeProvider = StateProvider<GuideViewMode>(
  (ref) => GuideViewMode.grid,
);

// 언어/전문분야 필터 프로바이더
final languageSpecialtyFiltersProvider =
    StateProvider<LanguageSpecialtyFilters>(
      (ref) => const LanguageSpecialtyFilters(),
    );

// 활성 언어 목록 프로바이더
final activeLanguagesProvider = FutureProvider.autoDispose<List<Language>>((
  ref,
) async {
  final repository = ref.watch(languageSpecialtyRepositoryProvider);
  return await repository.getActiveLanguages();
});

// 활성 전문분야 목록 프로바이더
final activeSpecialtiesProvider = FutureProvider.autoDispose<List<Specialty>>((
  ref,
) async {
  final repository = ref.watch(languageSpecialtyRepositoryProvider);
  return await repository.getActiveSpecialties();
});

// 카테고리별 전문분야 프로바이더
final specialtiesByCategoryProvider =
    FutureProvider.autoDispose<Map<String, List<Specialty>>>((ref) async {
      final repository = ref.watch(languageSpecialtyRepositoryProvider);
      return await repository.getSpecialtiesByCategory();
    });

// 가이드 목록 프로바이더
final guidesProvider = FutureProvider.autoDispose<PaginatedGuides>((ref) async {
  final repository = ref.watch(guidesRepositoryProvider);
  final searchQuery = ref.watch(guideSearchQueryProvider);
  final status = ref.watch(guideStatusFilterProvider);
  final language = ref.watch(guideLanguageFilterProvider);
  final specialty = ref.watch(guideSpecialtyFilterProvider);
  final grade = ref.watch(guideGradeFilterProvider);
  final page = ref.watch(guidePageProvider);
  final pageSize = ref.watch(guidePageSizeProvider);

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

// 특정 가이드의 언어 목록 프로바이더
final guideLanguagesProvider = FutureProvider.autoDispose
    .family<List<GuideLanguage>, String>((ref, guideId) async {
      final repository = ref.watch(languageSpecialtyRepositoryProvider);
      return await repository.getGuideLanguages(guideId);
    });

// 특정 가이드의 전문분야 목록 프로바이더
final guideSpecialtiesProvider = FutureProvider.autoDispose
    .family<List<GuideSpecialty>, String>((ref, guideId) async {
      final repository = ref.watch(languageSpecialtyRepositoryProvider);
      return await repository.getGuideSpecialties(guideId);
    });

// 가이드 뷰 모드 enum
enum GuideViewMode { grid, list }

// 가이드 상세 프로바이더
final guideProvider = FutureProvider.family<Guide?, String>((ref, id) async {
  final repository = ref.watch(guidesRepositoryProvider);
  return await repository.getGuide(id);
});

// 가이드 삭제 프로바이더
final deleteGuideProvider = FutureProvider.family<void, String>((
  ref,
  guideId,
) async {
  final repository = ref.watch(guidesRepositoryProvider);
  await repository.deleteGuide(guideId);

  // 삭제 후 가이드 목록 새로고침
  ref.invalidate(guidesProvider);
  ref.invalidate(guideStatsProvider);
});
