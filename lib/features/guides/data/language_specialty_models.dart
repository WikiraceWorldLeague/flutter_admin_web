// 언어 모델
class Language {
  final String id;
  final String name;
  final String code;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;

  const Language({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// 전문분야 모델
class Specialty {
  final String id;
  final String name;
  final String category;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;

  const Specialty({
    required this.id,
    required this.name,
    required this.category,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Specialty && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// 가이드 언어 연결 모델 (레벨 포함)
class GuideLanguage {
  final String id;
  final String guideId;
  final String languageId;
  final Language language;
  final ProficiencyLevel proficiencyLevel;
  final DateTime createdAt;

  const GuideLanguage({
    required this.id,
    required this.guideId,
    required this.languageId,
    required this.language,
    required this.proficiencyLevel,
    required this.createdAt,
  });

  factory GuideLanguage.fromJson(Map<String, dynamic> json) {
    return GuideLanguage(
      id: json['id'] as String,
      guideId: json['guide_id'] as String,
      languageId: json['language_id'] as String,
      language: Language.fromJson(json['language'] as Map<String, dynamic>),
      proficiencyLevel: ProficiencyLevel.fromString(json['proficiency_level'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guide_id': guideId,
      'language_id': languageId,
      'proficiency_level': proficiencyLevel.value,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// 가이드 전문분야 연결 모델
class GuideSpecialty {
  final String id;
  final String guideId;
  final String specialtyId;
  final Specialty specialty;
  final DateTime createdAt;

  const GuideSpecialty({
    required this.id,
    required this.guideId,
    required this.specialtyId,
    required this.specialty,
    required this.createdAt,
  });

  factory GuideSpecialty.fromJson(Map<String, dynamic> json) {
    return GuideSpecialty(
      id: json['id'] as String,
      guideId: json['guide_id'] as String,
      specialtyId: json['specialty_id'] as String,
      specialty: Specialty.fromJson(json['specialty'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guide_id': guideId,
      'specialty_id': specialtyId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// 언어 숙련도 레벨 enum
enum ProficiencyLevel {
  beginner('beginner', '초급'),
  intermediate('intermediate', '중급'),
  advanced('advanced', '고급'),
  native('native', '원어민');

  const ProficiencyLevel(this.value, this.displayName);

  final String value;
  final String displayName;

  static ProficiencyLevel fromString(String value) {
    return ProficiencyLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => ProficiencyLevel.beginner,
    );
  }

  @override
  String toString() => displayName;
}

// 언어/전문분야 필터 옵션
class LanguageSpecialtyFilters {
  final List<Language> selectedLanguages;
  final List<Specialty> selectedSpecialties;
  final List<String> selectedCategories;

  const LanguageSpecialtyFilters({
    this.selectedLanguages = const [],
    this.selectedSpecialties = const [],
    this.selectedCategories = const [],
  });

  LanguageSpecialtyFilters copyWith({
    List<Language>? selectedLanguages,
    List<Specialty>? selectedSpecialties,
    List<String>? selectedCategories,
  }) {
    return LanguageSpecialtyFilters(
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      selectedSpecialties: selectedSpecialties ?? this.selectedSpecialties,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  bool get isEmpty =>
      selectedLanguages.isEmpty &&
      selectedSpecialties.isEmpty &&
      selectedCategories.isEmpty;

  bool get isNotEmpty => !isEmpty;
} 