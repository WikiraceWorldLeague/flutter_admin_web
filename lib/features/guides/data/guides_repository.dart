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
      var query = _supabase
          .from('guides')
          .select('*');

      // 필터 적용
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('nickname.ilike.%$searchQuery%,korean_name.ilike.%$searchQuery%');
      }

      if (status != null && status != 'all') {
        query = query.eq('is_active', status == 'active');
      }

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
      final totalCount = guides.length < pageSize ? 
          (page - 1) * pageSize + guides.length : 
          page * pageSize + 1;

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

  // 가이드 상세 조회
  Future<Guide?> getGuide(String id) async {
    try {
      final response = await _supabase
          .from('guides')
          .select('*')
          .eq('id', id)
          .single();

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
      final response = await _supabase
          .from('guides')
          .insert(guideData)
          .select()
          .single();

      return Guide.fromJson(response);
    } catch (e) {
      dev.log('Error creating guide: $e', error: e);
      throw Exception('가이드 생성 실패: $e');
    }
  }

  // 가이드 수정
  Future<Guide> updateGuide(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
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

  // 가이드 삭제 (비활성화)
  Future<void> deleteGuide(String id) async {
    try {
      await _supabase
          .from('guides')
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      dev.log('Error deleting guide: $e', error: e);
      throw Exception('가이드 삭제 실패: $e');
    }
  }

  // 가이드 통계 조회 (임시)
  Future<GuideStats> getGuideStats() async {
    return const GuideStats(
      totalGuides: 0,
      activeGuides: 0,
      inactiveGuides: 0,
      averageRating: 0.0,
    );
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