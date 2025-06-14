import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'guide_form_models.dart';
import 'language_specialty_models.dart';
import 'language_specialty_repository.dart';

class GuideFormNotifier extends StateNotifier<GuideFormState> {
  final LanguageSpecialtyRepository _languageSpecialtyRepository;
  final SupabaseClient _supabase;
  final Uuid _uuid = const Uuid();

  GuideFormNotifier(this._languageSpecialtyRepository, this._supabase) 
      : super(const GuideFormState());

  // 기본 정보 업데이트
  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
    _validateField('nickname', nickname);
  }

  void updateGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void updateBirthDate(DateTime? birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
    _validateField('phoneNumber', phoneNumber);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
    _validateField('email', email);
  }

  // 프로필 정보 업데이트
  void updateProfileImageUrl(String? profileImageUrl) {
    state = state.copyWith(profileImageUrl: profileImageUrl);
  }

  void updateBio(String? bio) {
    state = state.copyWith(bio: bio);
  }

  // 언어 관리 (인라인 추가 방식)
  void addLanguage(Language language, ProficiencyLevel proficiencyLevel) {
    // 중복 체크
    final exists = state.languages.any((gl) => gl.languageId == language.id);
    if (exists) {
      _setValidationError('languages', '이미 추가된 언어입니다.');
      return;
    }

    final newLanguage = GuideLanguageForm(
      tempId: _uuid.v4(),
      languageId: language.id,
      language: language,
      proficiencyLevel: proficiencyLevel,
    );

    final updatedLanguages = [...state.languages, newLanguage];
    state = state.copyWith(languages: updatedLanguages);
    _clearValidationError('languages');
  }

  void removeLanguage(String tempId) {
    final updatedLanguages = state.languages
        .where((gl) => gl.tempId != tempId)
        .toList();
    state = state.copyWith(languages: updatedLanguages);
    
    if (updatedLanguages.isEmpty) {
      _setValidationError('languages', '최소 1개 이상의 언어를 선택해주세요.');
    }
  }

  void updateLanguageProficiency(String tempId, ProficiencyLevel proficiencyLevel) {
    final updatedLanguages = state.languages.map((gl) {
      if (gl.tempId == tempId) {
        return gl.copyWith(proficiencyLevel: proficiencyLevel);
      }
      return gl;
    }).toList();
    
    state = state.copyWith(languages: updatedLanguages);
  }

  // 전문분야 관리 (Chip 방식)
  void toggleSpecialty(String specialtyId) {
    final currentIds = List<String>.from(state.selectedSpecialtyIds);
    
    if (currentIds.contains(specialtyId)) {
      currentIds.remove(specialtyId);
    } else {
      currentIds.add(specialtyId);
    }
    
    state = state.copyWith(selectedSpecialtyIds: currentIds);
    
    if (currentIds.isEmpty) {
      _setValidationError('specialties', '최소 1개 이상의 전문분야를 선택해주세요.');
    } else {
      _clearValidationError('specialties');
    }
  }

  // 유효성 검증
  void _validateField(String fieldName, String value) {
    ValidationResult result;
    
    switch (fieldName) {
      case 'nickname':
        result = _validateNickname(value);
        break;
      case 'phoneNumber':
        result = _validatePhoneNumber(value);
        break;
      case 'email':
        result = _validateEmail(value);
        break;
      default:
        result = ValidationResult.valid;
    }
    
    if (result.isValid) {
      _clearValidationError(fieldName);
    } else {
      _setValidationError(fieldName, result.errorMessage!);
    }
  }

  ValidationResult _validateNickname(String nickname) {
    if (nickname.isEmpty) {
      return ValidationResult.invalid('닉네임을 입력해주세요.');
    }
    if (nickname.length < 2) {
      return ValidationResult.invalid('닉네임은 2자 이상 입력해주세요.');
    }
    if (nickname.length > 20) {
      return ValidationResult.invalid('닉네임은 20자 이하로 입력해주세요.');
    }
    return ValidationResult.valid;
  }

  ValidationResult _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return ValidationResult.invalid('전화번호를 입력해주세요.');
    }
    
    // 한국 전화번호 형식 검증 (010-1234-5678 또는 01012345678)
    final phoneRegex = RegExp(r'^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      return ValidationResult.invalid('올바른 전화번호 형식이 아닙니다. (예: 010-1234-5678)');
    }
    
    return ValidationResult.valid;
  }

  ValidationResult _validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationResult.invalid('이메일을 입력해주세요.');
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return ValidationResult.invalid('올바른 이메일 형식이 아닙니다.');
    }
    
    return ValidationResult.valid;
  }

  void _setValidationError(String fieldName, String errorMessage) {
    final updatedErrors = Map<String, String?>.from(state.validationErrors);
    updatedErrors[fieldName] = errorMessage;
    state = state.copyWith(validationErrors: updatedErrors);
  }

  void _clearValidationError(String fieldName) {
    final updatedErrors = Map<String, String?>.from(state.validationErrors);
    updatedErrors.remove(fieldName);
    state = state.copyWith(validationErrors: updatedErrors);
  }

  // 중복 검사 (비동기)
  Future<void> checkEmailDuplicate(String email) async {
    if (email.isEmpty) return;
    
    try {
      final response = await _supabase
          .from('guides')
          .select('id')
          .eq('email', email)
          .maybeSingle();
      
      if (response != null && response['id'] != state.editingGuideId) {
        _setValidationError('email', '이미 사용 중인 이메일입니다.');
      } else {
        _clearValidationError('email');
      }
    } catch (e) {
      print('이메일 중복 검사 오류: $e');
    }
  }

  Future<void> checkPhoneDuplicate(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    
    try {
      final response = await _supabase
          .from('guides')
          .select('id')
          .eq('phone', phoneNumber)
          .maybeSingle();
      
      if (response != null && response['id'] != state.editingGuideId) {
        _setValidationError('phoneNumber', '이미 사용 중인 전화번호입니다.');
      } else {
        _clearValidationError('phoneNumber');
      }
    } catch (e) {
      print('전화번호 중복 검사 오류: $e');
    }
  }

  // 전체 폼 유효성 검증
  Future<bool> validateForm() async {
    // 기본 필드 검증
    _validateField('nickname', state.nickname);
    _validateField('phoneNumber', state.phoneNumber);
    _validateField('email', state.email);
    
    // 언어 검증
    if (state.languages.isEmpty) {
      _setValidationError('languages', '최소 1개 이상의 언어를 선택해주세요.');
    }
    
    // 전문분야 검증
    if (state.selectedSpecialtyIds.isEmpty) {
      _setValidationError('specialties', '최소 1개 이상의 전문분야를 선택해주세요.');
    }
    
    // 중복 검사
    await checkEmailDuplicate(state.email);
    await checkPhoneDuplicate(state.phoneNumber);
    
    return state.isValid;
  }

  // 폼 저장
  Future<bool> saveGuide() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isValid = await validateForm();
      if (!isValid) {
        state = state.copyWith(isLoading: false);
        return false;
      }
      
      if (state.isEditing) {
        return await _updateGuide();
      } else {
        return await _createGuide();
      }
    } catch (e) {
      print('가이드 저장 오류: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> _createGuide() async {
    try {
      // 1. 가이드 기본 정보 저장
      final guideData = {
        'nickname': state.nickname,
        'gender': state.gender,
        'birth_date': state.birthDate?.toIso8601String(),
        'phone': state.phoneNumber,
        'email': state.email,
        'profile_image_url': state.profileImageUrl,
        'bio': state.bio,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      final guideResponse = await _supabase
          .from('guides')
          .insert(guideData)
          .select('id')
          .single();
      
      final guideId = guideResponse['id'] as String;
      
      // 2. 언어 정보 저장
      if (state.languages.isNotEmpty) {
        final languageData = state.languages.map((gl) => {
          'guide_id': guideId,
          'language_id': gl.languageId,
          'proficiency_level': gl.proficiencyLevel.value,
          'created_at': DateTime.now().toIso8601String(),
        }).toList();
        
        await _supabase.from('guide_languages').insert(languageData);
      }
      
      // 3. 전문분야 정보 저장
      if (state.selectedSpecialtyIds.isNotEmpty) {
        final specialtyData = state.selectedSpecialtyIds.map((specialtyId) => {
          'guide_id': guideId,
          'specialty_id': specialtyId,
          'created_at': DateTime.now().toIso8601String(),
        }).toList();
        
        await _supabase.from('guide_specialties').insert(specialtyData);
      }
      
      state = state.copyWith(isLoading: false);
      return true;
      
    } catch (e) {
      print('가이드 생성 오류: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> _updateGuide() async {
    try {
      final guideId = state.editingGuideId!;
      
      // 1. 가이드 기본 정보 업데이트
      final guideData = {
        'nickname': state.nickname,
        'gender': state.gender,
        'birth_date': state.birthDate?.toIso8601String(),
        'phone': state.phoneNumber,
        'email': state.email,
        'profile_image_url': state.profileImageUrl,
        'bio': state.bio,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      await _supabase
          .from('guides')
          .update(guideData)
          .eq('id', guideId);
      
      // 2. 기존 언어 정보 삭제 후 재생성
      await _supabase
          .from('guide_languages')
          .delete()
          .eq('guide_id', guideId);
      
      if (state.languages.isNotEmpty) {
        final languageData = state.languages.map((gl) => {
          'guide_id': guideId,
          'language_id': gl.languageId,
          'proficiency_level': gl.proficiencyLevel.value,
          'created_at': DateTime.now().toIso8601String(),
        }).toList();
        
        await _supabase.from('guide_languages').insert(languageData);
      }
      
      // 3. 기존 전문분야 정보 삭제 후 재생성
      await _supabase
          .from('guide_specialties')
          .delete()
          .eq('guide_id', guideId);
      
      if (state.selectedSpecialtyIds.isNotEmpty) {
        final specialtyData = state.selectedSpecialtyIds.map((specialtyId) => {
          'guide_id': guideId,
          'specialty_id': specialtyId,
          'created_at': DateTime.now().toIso8601String(),
        }).toList();
        
        await _supabase.from('guide_specialties').insert(specialtyData);
      }
      
      state = state.copyWith(isLoading: false);
      return true;
      
    } catch (e) {
      print('가이드 업데이트 오류: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // 편집 모드로 초기화
  void initializeForEdit(String guideId, {
    required String nickname,
    String? gender,
    DateTime? birthDate,
    required String phoneNumber,
    required String email,
    String? profileImageUrl,
    String? bio,
    List<GuideLanguageForm>? languages,
    List<String>? selectedSpecialtyIds,
  }) {
    state = GuideFormState(
      nickname: nickname,
      gender: gender,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      email: email,
      profileImageUrl: profileImageUrl,
      bio: bio,
      languages: languages ?? [],
      selectedSpecialtyIds: selectedSpecialtyIds ?? [],
      isEditing: true,
      editingGuideId: guideId,
    );
  }

  // 폼 초기화
  void resetForm() {
    state = const GuideFormState();
  }
}
