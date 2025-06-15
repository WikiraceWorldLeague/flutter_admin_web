import 'language_specialty_models.dart';
import '../../reservations/domain/reservation_models.dart' show Guide;

// 가이드 폼 상태 모델
class GuideFormState {
  // 기본 정보
  final String nickname;
  final String? gender;
  final DateTime? birthDate;
  final String phoneNumber;
  final String email;

  // 여권 정보 (필수)
  final String passportFirstName;
  final String passportLastName;
  final String nationality;

  // 언어 능력 (동적 추가)
  final List<GuideLanguageForm> languages;

  // 전문분야 (Chip 선택)
  final List<String> selectedSpecialtyIds;

  // 프로필 정보
  final String? profileImageUrl;
  final String? bio;

  // 유효성 검증 상태
  final Map<String, String?> validationErrors;

  // 폼 상태
  final bool isLoading;
  final bool isEditing;
  final String? editingGuideId;
  final Guide? currentGuide;

  const GuideFormState({
    this.nickname = '',
    this.gender,
    this.birthDate,
    this.phoneNumber = '',
    this.email = '',
    this.passportFirstName = '',
    this.passportLastName = '',
    this.nationality = '',
    this.languages = const [],
    this.selectedSpecialtyIds = const [],
    this.profileImageUrl,
    this.bio,
    this.validationErrors = const {},
    this.isLoading = false,
    this.isEditing = false,
    this.editingGuideId,
    this.currentGuide,
  });

  GuideFormState copyWith({
    String? nickname,
    String? gender,
    DateTime? birthDate,
    String? phoneNumber,
    String? email,
    String? passportFirstName,
    String? passportLastName,
    String? nationality,
    List<GuideLanguageForm>? languages,
    List<String>? selectedSpecialtyIds,
    String? profileImageUrl,
    String? bio,
    Map<String, String?>? validationErrors,
    bool? isLoading,
    bool? isEditing,
    String? editingGuideId,
    Guide? currentGuide,
  }) {
    return GuideFormState(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      passportFirstName: passportFirstName ?? this.passportFirstName,
      passportLastName: passportLastName ?? this.passportLastName,
      nationality: nationality ?? this.nationality,
      languages: languages ?? this.languages,
      selectedSpecialtyIds: selectedSpecialtyIds ?? this.selectedSpecialtyIds,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      validationErrors: validationErrors ?? this.validationErrors,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      editingGuideId: editingGuideId ?? this.editingGuideId,
      currentGuide: currentGuide ?? this.currentGuide,
    );
  }

  // 폼 유효성 검사
  bool get isValid {
    return validationErrors.isEmpty &&
        nickname.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        email.isNotEmpty &&
        passportFirstName.isNotEmpty &&
        passportLastName.isNotEmpty &&
        nationality.isNotEmpty &&
        languages.isNotEmpty &&
        selectedSpecialtyIds.isNotEmpty;
  }

  // 변경사항 확인
  bool get hasChanges {
    return nickname.isNotEmpty ||
        phoneNumber.isNotEmpty ||
        email.isNotEmpty ||
        passportFirstName.isNotEmpty ||
        passportLastName.isNotEmpty ||
        nationality.isNotEmpty ||
        languages.isNotEmpty ||
        selectedSpecialtyIds.isNotEmpty;
  }
}

// 폼에서 사용하는 언어 모델 (임시 ID 포함)
class GuideLanguageForm {
  final String tempId; // 폼에서 관리용 임시 ID
  final String languageId;
  final Language language;
  final ProficiencyLevel proficiencyLevel;

  const GuideLanguageForm({
    required this.tempId,
    required this.languageId,
    required this.language,
    required this.proficiencyLevel,
  });

  GuideLanguageForm copyWith({
    String? tempId,
    String? languageId,
    Language? language,
    ProficiencyLevel? proficiencyLevel,
  }) {
    return GuideLanguageForm(
      tempId: tempId ?? this.tempId,
      languageId: languageId ?? this.languageId,
      language: language ?? this.language,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
    );
  }

  // GuideLanguage로 변환 (저장시 사용)
  GuideLanguage toGuideLanguage(String guideId) {
    return GuideLanguage(
      id: '', // 서버에서 생성
      guideId: guideId,
      languageId: languageId,
      language: language,
      proficiencyLevel: proficiencyLevel,
      createdAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideLanguageForm &&
          runtimeType == other.runtimeType &&
          tempId == other.tempId;

  @override
  int get hashCode => tempId.hashCode;
}

// 성별 옵션
enum Gender {
  male('male', '남성'),
  female('female', '여성'),
  other('other', '기타');

  const Gender(this.value, this.displayName);

  final String value;
  final String displayName;

  static Gender? fromString(String? value) {
    if (value == null) return null;
    return Gender.values.firstWhere(
      (gender) => gender.value == value,
      orElse: () => Gender.other,
    );
  }
}

// 유효성 검증 결과
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});

  static const ValidationResult valid = ValidationResult(isValid: true);

  static ValidationResult invalid(String message) {
    return ValidationResult(isValid: false, errorMessage: message);
  }
}
