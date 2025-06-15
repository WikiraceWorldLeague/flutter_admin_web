import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'guides_providers.dart' show supabaseClientProvider;
import 'guide_form_models.dart';
import 'guide_form_notifier.dart';
import 'language_specialty_models.dart';
import 'language_specialty_repository.dart';
import '../../reservations/domain/reservation_models.dart' show Guide;

// UUID 프로바이더
final uuidProvider = Provider<Uuid>((ref) => const Uuid());

// 언어/전문분야 저장소 프로바이더
final languageSpecialtyRepositoryProvider =
    Provider<LanguageSpecialtyRepository>((ref) {
      final supabase = ref.watch(supabaseClientProvider);
      return LanguageSpecialtyRepository(supabase);
    });

// 가이드 폼 상태 관리 Provider
final guideFormProvider =
    StateNotifierProvider<GuideFormNotifier, GuideFormState>((ref) {
      final supabase = ref.watch(supabaseClientProvider);
      final languageSpecialtyRepository = ref.watch(
        languageSpecialtyRepositoryProvider,
      );
      final uuid = ref.watch(uuidProvider);

      return GuideFormNotifier(
        supabase,
        languageSpecialtyRepository,
        uuid,
        ref,
      );
    });

// 언어 목록 Provider (폼에서 선택용)
final availableLanguagesProvider = FutureProvider<List<Language>>((ref) async {
  final repository = ref.watch(languageSpecialtyRepositoryProvider);
  return await repository.getActiveLanguages();
});

// 전문분야 목록 Provider (폼에서 선택용)
final availableSpecialtiesProvider = FutureProvider<List<Specialty>>((
  ref,
) async {
  final repository = ref.watch(languageSpecialtyRepositoryProvider);
  return await repository.getActiveSpecialties();
});

// 폼 유효성 상태 Provider (UI에서 버튼 활성화 등에 사용)
final isFormValidProvider = Provider<bool>((ref) {
  final formState = ref.watch(guideFormProvider);
  return formState.isValid;
});

// 폼 로딩 상태 Provider
final isFormLoadingProvider = Provider<bool>((ref) {
  final formState = ref.watch(guideFormProvider);
  return formState.isLoading;
});

// 특정 필드의 에러 메시지 Provider
final fieldErrorProvider = Provider.family<String?, String>((ref, fieldName) {
  final formState = ref.watch(guideFormProvider);
  return formState.validationErrors[fieldName];
});

// 선택된 언어 목록 Provider (UI 표시용)
final selectedLanguagesProvider = Provider<List<GuideLanguageForm>>((ref) {
  final formState = ref.watch(guideFormProvider);
  return formState.languages;
});

// 선택된 전문분야 ID 목록 Provider
final selectedSpecialtyIdsProvider = Provider<List<String>>((ref) {
  final formState = ref.watch(guideFormProvider);
  return formState.selectedSpecialtyIds;
});

// 편집 모드 여부 Provider
final isEditModeProvider = Provider<bool>((ref) {
  final formState = ref.watch(guideFormProvider);
  return formState.isEditing;
});

// 폼 변경사항 여부 Provider (뒤로가기 시 확인용)
final hasFormChangesProvider = Provider<bool>((ref) {
  final formState = ref.watch(guideFormProvider);
  return formState.hasChanges;
});

// 현재 편집 중인 가이드 Provider
final currentGuideProvider = Provider<Guide?>((ref) {
  final formState = ref.watch(guideFormProvider);
  return formState.currentGuide;
});

// 현재 가이드의 활성 상태 Provider
final currentGuideActiveStatusProvider = FutureProvider<bool>((ref) async {
  final currentGuide = ref.watch(currentGuideProvider);
  if (currentGuide == null) return true;

  try {
    final supabase = ref.watch(supabaseClientProvider);
    final response =
        await supabase
            .from('guides')
            .select('is_active')
            .eq('id', currentGuide.id)
            .single();

    return response['is_active'] as bool? ?? true;
  } catch (e) {
    return true;
  }
});
