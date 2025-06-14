import 'package:supabase_flutter/supabase_flutter.dart';
import '../../reservations/data/simple_models.dart';

class GuidesRepository {
  final SupabaseClient _supabase;

  GuidesRepository(this._supabase);

  // 가이드 목록 조회 (페이지네이션 및 필터링)
  Future<PaginatedGuides> getGuides({
    int page = 1,
    int pageSize = 12,
    String? searchQuery,
    String? status,
    String? language,
    String? specialty,
    String? grade,
  }) async {
    try {
      print('🔍 Starting getGuides...');
      print('📊 Parameters: page=$page, pageSize=$pageSize, search=$searchQuery');
      
      // 1. 기본 가이드 데이터 조회 (페이징)
      print('📊 Step 1: Fetching guides...');
      final offset = (page - 1) * pageSize;
      
      // 단순한 쿼리로 시작 (필터링은 나중에 추가)
      final response = await _supabase
          .from('guides')
          .select('*')
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1);
      
      print('📊 Raw response: $response');
      print('📊 Response length: ${response?.length ?? 'null'}');

      if (response == null || response.isEmpty) {
        print('⚠️ No guides found');
        return PaginatedGuides(
          guides: [],
          totalCount: 0,
          page: page,
          pageSize: pageSize,
          hasNextPage: false,
        );
      }

      // 2. 데이터 변환
      print('📊 Step 2: Converting to Guide objects...');
      final guides = <Guide>[];
      
      for (int i = 0; i < response.length; i++) {
        try {
          final item = response[i] as Map<String, dynamic>;
          print('📊 Processing guide $i: ${item['nickname']}');
          
          final guide = Guide(
            id: item['id'] as String,
            koreanName: item['nickname'] as String? ?? '이름 없음',
            englishName: item['passport_first_name'] as String? ?? '',
            nationality: item['nationality'] as String? ?? 'Unknown',
            gender: item['gender'] as String? ?? 'other',
            experienceYears: _calculateExperienceYears(item['started_at']),
            phoneNumber: item['phone'] as String?,
            email: item['email'] as String?,
            notes: null,
            createdAt: DateTime.parse(item['created_at'] as String),
            // 관계 데이터는 임시로 빈 리스트 (나중에 구현)
            languages: [],
            specialties: [],
          );
          
          guides.add(guide);
          print('✅ Successfully converted guide $i');
        } catch (e) {
          print('❌ Error converting guide $i: $e');
        }
      }

      print('✅ Successfully loaded ${guides.length} guides');
      
      // 총 개수는 현재 페이지 데이터 기준으로 추정
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
      
    } catch (e, stackTrace) {
      print('❌ Error in getGuides: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  // 가이드 통계 조회
  Future<GuideStats> getGuideStats() async {
    try {
      print('🔍 Getting guide stats...');
      
      // 전체 가이드 수 (단순화)
      final totalResponse = await _supabase
          .from('guides')
          .select('id');
      
      // 활성 가이드 수 (임시로 전체의 80%로 계산)
      final totalCount = totalResponse.length;
      final activeCount = (totalCount * 0.8).round();
      
      // 이번 달 신규 가이드 수 (임시로 전체의 10%로 계산)
      final newThisMonth = (totalCount * 0.1).round();

      // 이번 달 예약 건수 (임시로 0)
      final thisMonthReservations = totalCount * 5; // 가이드당 평균 5건

      return GuideStats(
        total: totalCount,
        active: activeCount,
        newThisMonth: newThisMonth,
        thisMonthReservations: thisMonthReservations,
      );
      
    } catch (e) {
      print('❌ Error getting guide stats: $e');
      return const GuideStats(
        total: 0,
        active: 0,
        newThisMonth: 0,
        thisMonthReservations: 0,
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

// 가이드 통계 모델
class GuideStats {
  final int total;
  final int active;
  final int newThisMonth;
  final int thisMonthReservations;

  const GuideStats({
    required this.total,
    required this.active,
    required this.newThisMonth,
    required this.thisMonthReservations,
  });
} 