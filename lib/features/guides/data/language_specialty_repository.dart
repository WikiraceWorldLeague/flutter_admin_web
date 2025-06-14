import 'package:supabase_flutter/supabase_flutter.dart';
import 'language_specialty_models.dart';

class LanguageSpecialtyRepository {
  final SupabaseClient _supabase;

  LanguageSpecialtyRepository(this._supabase);

  // 활성 언어 목록 조회
  Future<List<Language>> getActiveLanguages() async {
    try {
      print('🔍 Fetching active languages...');
      
      final response = await _supabase
          .from('languages')
          .select('*')
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      print('📊 Languages response: $response');

      if (response == null || response.isEmpty) {
        print('⚠️ No languages found, returning mock data');
        return _getMockLanguages();
      }

      final languages = response
          .map((item) => Language.fromJson(item as Map<String, dynamic>))
          .toList();

      print('✅ Successfully loaded ${languages.length} languages');
      return languages;
      
    } catch (e) {
      print('❌ Error fetching languages: $e');
      print('📝 Returning mock data as fallback');
      return _getMockLanguages();
    }
  }

  // 활성 전문분야 목록 조회
  Future<List<Specialty>> getActiveSpecialties() async {
    try {
      print('🔍 Fetching active specialties...');
      
      final response = await _supabase
          .from('specialties')
          .select('*')
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      print('📊 Specialties response: $response');

      if (response == null || response.isEmpty) {
        print('⚠️ No specialties found, returning mock data');
        return _getMockSpecialties();
      }

      final specialties = response
          .map((item) => Specialty.fromJson(item as Map<String, dynamic>))
          .toList();

      print('✅ Successfully loaded ${specialties.length} specialties');
      return specialties;
      
    } catch (e) {
      print('❌ Error fetching specialties: $e');
      print('📝 Returning mock data as fallback');
      return _getMockSpecialties();
    }
  }

  // 카테고리별 전문분야 조회
  Future<Map<String, List<Specialty>>> getSpecialtiesByCategory() async {
    try {
      final specialties = await getActiveSpecialties();
      final Map<String, List<Specialty>> categorizedSpecialties = {};

      for (final specialty in specialties) {
        if (!categorizedSpecialties.containsKey(specialty.category)) {
          categorizedSpecialties[specialty.category] = [];
        }
        categorizedSpecialties[specialty.category]!.add(specialty);
      }

      return categorizedSpecialties;
    } catch (e) {
      print('❌ Error categorizing specialties: $e');
      return {
        '의료': _getMockSpecialties().where((s) => s.category == '의료').toList(),
        '기타': _getMockSpecialties().where((s) => s.category == '기타').toList(),
      };
    }
  }

  // 가이드의 언어 목록 조회
  Future<List<GuideLanguage>> getGuideLanguages(String guideId) async {
    try {
      print('🔍 Fetching languages for guide: $guideId');
      
      final response = await _supabase
          .from('guide_languages')
          .select('''
            id,
            guide_id,
            language_id,
            proficiency_level,
            created_at,
            language:languages(*)
          ''')
          .eq('guide_id', guideId);

      print('📊 Guide languages response: $response');

      if (response == null || response.isEmpty) {
        print('⚠️ No languages found for guide');
        return [];
      }

      final guideLanguages = response
          .map((item) => GuideLanguage.fromJson(item as Map<String, dynamic>))
          .toList();

      print('✅ Successfully loaded ${guideLanguages.length} languages for guide');
      return guideLanguages;
      
    } catch (e) {
      print('❌ Error fetching guide languages: $e');
      return [];
    }
  }

  // 가이드의 전문분야 목록 조회
  Future<List<GuideSpecialty>> getGuideSpecialties(String guideId) async {
    try {
      print('🔍 Fetching specialties for guide: $guideId');
      
      final response = await _supabase
          .from('guide_specialties')
          .select('''
            id,
            guide_id,
            specialty_id,
            created_at,
            specialty:specialties(*)
          ''')
          .eq('guide_id', guideId);

      print('📊 Guide specialties response: $response');

      if (response == null || response.isEmpty) {
        print('⚠️ No specialties found for guide');
        return [];
      }

      final guideSpecialties = response
          .map((item) => GuideSpecialty.fromJson(item as Map<String, dynamic>))
          .toList();

      print('✅ Successfully loaded ${guideSpecialties.length} specialties for guide');
      return guideSpecialties;
      
    } catch (e) {
      print('❌ Error fetching guide specialties: $e');
      return [];
    }
  }

  // 언어 추가
  Future<Language> addLanguage({
    required String name,
    required String code,
    int sortOrder = 0,
  }) async {
    try {
      final response = await _supabase
          .from('languages')
          .insert({
            'name': name,
            'code': code,
            'sort_order': sortOrder,
          })
          .select()
          .single();

      return Language.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Error adding language: $e');
      rethrow;
    }
  }

  // 전문분야 추가
  Future<Specialty> addSpecialty({
    required String name,
    required String category,
    int sortOrder = 0,
  }) async {
    try {
      final response = await _supabase
          .from('specialties')
          .insert({
            'name': name,
            'category': category,
            'sort_order': sortOrder,
          })
          .select()
          .single();

      return Specialty.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Error adding specialty: $e');
      rethrow;
    }
  }

  // Mock 데이터 (데이터베이스 연결 실패 시 사용)
  List<Language> _getMockLanguages() {
    return [
      Language(
        id: 'mock-ko',
        name: '한국어',
        code: 'ko',
        isActive: true,
        sortOrder: 1,
        createdAt: DateTime.now(),
      ),
      Language(
        id: 'mock-en',
        name: '영어',
        code: 'en',
        isActive: true,
        sortOrder: 2,
        createdAt: DateTime.now(),
      ),
      Language(
        id: 'mock-zh-cn',
        name: '중국어(간체)',
        code: 'zh-CN',
        isActive: true,
        sortOrder: 3,
        createdAt: DateTime.now(),
      ),
      Language(
        id: 'mock-zh-tw',
        name: '중국어(번체)',
        code: 'zh-TW',
        isActive: true,
        sortOrder: 4,
        createdAt: DateTime.now(),
      ),
      Language(
        id: 'mock-ja',
        name: '일본어',
        code: 'ja',
        isActive: true,
        sortOrder: 5,
        createdAt: DateTime.now(),
      ),
    ];
  }

  List<Specialty> _getMockSpecialties() {
    return [
      Specialty(
        id: 'mock-plastic',
        name: '성형외과',
        category: '의료',
        isActive: true,
        sortOrder: 1,
        createdAt: DateTime.now(),
      ),
      Specialty(
        id: 'mock-derma',
        name: '피부과',
        category: '의료',
        isActive: true,
        sortOrder: 2,
        createdAt: DateTime.now(),
      ),
      Specialty(
        id: 'mock-dental',
        name: '치과',
        category: '의료',
        isActive: true,
        sortOrder: 3,
        createdAt: DateTime.now(),
      ),
      Specialty(
        id: 'mock-eye',
        name: '안과',
        category: '의료',
        isActive: true,
        sortOrder: 4,
        createdAt: DateTime.now(),
      ),
      Specialty(
        id: 'mock-checkup',
        name: '건강검진',
        category: '의료',
        isActive: true,
        sortOrder: 5,
        createdAt: DateTime.now(),
      ),
      Specialty(
        id: 'mock-other',
        name: '기타',
        category: '기타',
        isActive: true,
        sortOrder: 8,
        createdAt: DateTime.now(),
      ),
    ];
  }
} 