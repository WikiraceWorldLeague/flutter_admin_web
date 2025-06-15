import 'package:supabase_flutter/supabase_flutter.dart';
import '../../reservations/domain/reservation_models.dart';
import 'dart:developer' as dev;

class GuidesRepository {
  final SupabaseClient _supabase;

  GuidesRepository(this._supabase);

  // 가이드 목록 조회
  Future<PaginatedGuides> getGuides({
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
    String? status,
    String? language,
    String? specialty,
    String? grade,
  }) async {
    try {
      // 기본 쿼리
      var query = _supabase.from('guides').select('*');

      // 필터 적용
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
          'nickname.ilike.%$searchQuery%,korean_name.ilike.%$searchQuery%',
        );
      }

      // status 필터 적용
      if (status != null) {
        if (status == 'active') {
          query = query.eq('is_active', true);
        } else if (status == 'inactive') {
          query = query.eq('is_active', false);
        }
        // 'all'인 경우 필터 없음 (모든 가이드 조회)
      }
      // status가 null인 경우도 필터 없음 (모든 가이드 조회)

      // 페이지네이션
      final response = await query
          .order('created_at', ascending: false)
          .range((page - 1) * pageSize, page * pageSize - 1);

      final data = response as List<dynamic>;

      final guides = <Guide>[];
      for (final item in data) {
        try {
          final guide = Guide.fromJson(item);
          guides.add(guide);
        } catch (e) {
          dev.log('Error parsing guide: $e', error: e);
        }
      }

      // 총 개수는 현재 결과 기반으로 추정 (간단화)
      final totalCount =
          guides.length < pageSize
              ? (page - 1) * pageSize + guides.length
              : page * pageSize + 1;

      return PaginatedGuides(
        guides: guides,
        totalCount: totalCount,
        page: page,
        pageSize: pageSize,
        hasNextPage: guides.length == pageSize,
      );
    } catch (e) {
      dev.log('Error fetching guides: $e', error: e);
      throw Exception('가이드 목록 조회 실패: $e');
    }
  }

  // 가이드 상세 조회 (모든 가이드)
  Future<Guide?> getGuide(String id) async {
    try {
      final response =
          await _supabase.from('guides').select('*').eq('id', id).single();

      return Guide.fromJson(response);
    } catch (e) {
      if (e.toString().contains('No rows found')) {
        return null;
      }
      dev.log('Error fetching guide: $e', error: e);
      throw Exception('가이드 조회 실패: $e');
    }
  }

  // 가이드 생성
  Future<Guide> createGuide(Map<String, dynamic> guideData) async {
    try {
      final response =
          await _supabase.from('guides').insert(guideData).select().single();

      return Guide.fromJson(response);
    } catch (e) {
      dev.log('Error creating guide: $e', error: e);
      throw Exception('가이드 생성 실패: $e');
    }
  }

  // 가이드 수정
  Future<Guide> updateGuide(String id, Map<String, dynamic> updates) async {
    try {
      final response =
          await _supabase
              .from('guides')
              .update(updates)
              .eq('id', id)
              .select()
              .single();

      return Guide.fromJson(response);
    } catch (e) {
      dev.log('Error updating guide: $e', error: e);
      throw Exception('가이드 수정 실패: $e');
    }
  }

  // 가이드 비활성화
  Future<void> deactivateGuide(String id) async {
    try {
      await _supabase.from('guides').update({'is_active': false}).eq('id', id);
    } catch (e) {
      dev.log('Error deactivating guide: $e', error: e);
      throw Exception('가이드 비활성화 실패: $e');
    }
  }

  // 가이드 완전 삭제
  Future<void> deleteGuide(String id) async {
    try {
      // 1. 연관된 settlement_items 삭제
      await _supabase.from('settlement_items').delete().eq('guide_id', id);

      // 2. 연관된 settlements 삭제
      await _supabase.from('settlements').delete().eq('guide_id', id);

      // 3. 연관된 reviews 삭제 (guide_id가 NOT NULL이므로 삭제해야 함)
      await _supabase.from('reviews').delete().eq('guide_id', id);

      // 4. 연관된 guide_languages 삭제
      await _supabase.from('guide_languages').delete().eq('guide_id', id);

      // 5. 연관된 guide_specialties 삭제
      await _supabase.from('guide_specialties').delete().eq('guide_id', id);

      // 6. 연관된 reservations의 guide_id를 null로 설정
      await _supabase
          .from('reservations')
          .update({'guide_id': null})
          .eq('guide_id', id);

      // 7. 마지막으로 가이드 삭제
      await _supabase.from('guides').delete().eq('id', id);
    } catch (e) {
      dev.log('Error deleting guide: $e', error: e);
      throw Exception('가이드 삭제 실패: $e');
    }
  }

  // 가이드 상태 토글
  Future<void> toggleGuideStatus(String id, bool isActive) async {
    try {
      await _supabase
          .from('guides')
          .update({'is_active': isActive})
          .eq('id', id);
    } catch (e) {
      dev.log('Error toggling guide status: $e', error: e);
      throw Exception('가이드 상태 변경 실패: $e');
    }
  }

  // 가이드 통계 조회
  Future<GuideStats> getGuideStats() async {
    try {
      // 전체 가이드 수
      final totalResponse = await _supabase.from('guides').select('id');
      final totalGuides = (totalResponse as List).length;

      // 활성 가이드 수
      final activeResponse = await _supabase
          .from('guides')
          .select('id')
          .eq('is_active', true);
      final activeGuides = (activeResponse as List).length;

      // 비활성 가이드 수
      final inactiveGuides = totalGuides - activeGuides;

      return GuideStats(
        totalGuides: totalGuides,
        activeGuides: activeGuides,
        inactiveGuides: inactiveGuides,
        averageRating: 4.5, // 임시값 - 나중에 실제 평점 계산 추가
      );
    } catch (e) {
      dev.log('Error fetching guide stats: $e', error: e);
      return const GuideStats(
        totalGuides: 0,
        activeGuides: 0,
        inactiveGuides: 0,
        averageRating: 0.0,
      );
    }
  }

  // 경력 년수 계산
  int _calculateExperienceYears(dynamic startedAt) {
    if (startedAt == null) return 1;
    try {
      final startDate = DateTime.parse(startedAt.toString());
      final now = DateTime.now();
      final difference = now.difference(startDate);
      return (difference.inDays / 365).floor().clamp(1, 50);
    } catch (e) {
      return 1;
    }
  }
}

// 페이지네이션된 가이드 목록 모델
class PaginatedGuides {
  final List<Guide> guides;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  const PaginatedGuides({
    required this.guides,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });
}

// 가이드 검색 결과 모델
class GuideSearchResult {
  final List<Guide> guides;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  const GuideSearchResult({
    required this.guides,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });
}

// 가이드 통계 모델
class GuideStats {
  final int totalGuides;
  final int activeGuides;
  final int inactiveGuides;
  final double averageRating;

  const GuideStats({
    required this.totalGuides,
    required this.activeGuides,
    required this.inactiveGuides,
    required this.averageRating,
  });

  // UI에서 사용하는 getter들
  int get total => totalGuides;
  int get active => activeGuides;
  int get newThisMonth => 0; // 임시값
  int get thisMonthReservations => 0; // 임시값
}
