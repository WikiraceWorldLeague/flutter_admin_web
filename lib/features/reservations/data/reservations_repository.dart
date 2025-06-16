import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/reservation_models.dart';
import 'dart:developer' as dev;

class ReservationsRepository {
  final SupabaseClient _supabase;

  ReservationsRepository(this._supabase);

  // 예약 목록 조회 (페이지네이션 + 필터링)
  Future<PaginatedReservations> getReservations({
    int page = 1,
    int pageSize = 20,
    ReservationFilter? filters,
    String orderBy = 'reservation_date',
    bool ascending = false, // 최신순이 기본
  }) async {
    try {
      // 기본 쿼리 구성 - 실제 스키마에 맞게 수정
      var query = _supabase.from('reservations').select('''
            *,
            clinic:clinics(*),
            customers!customers_reservation_id_fkey(*),
            assigned_guide:guides(id, nickname, phone, email)
          ''');

      // 필터 적용
      if (filters != null) {
        if (filters.startDate != null) {
          query = query.gte(
            'reservation_date',
            filters.startDate!.toIso8601String().split('T')[0],
          );
        }
        if (filters.endDate != null) {
          query = query.lte(
            'reservation_date',
            filters.endDate!.toIso8601String().split('T')[0],
          );
        }
        if (filters.status != null) {
          query = query.eq('status', filters.status!.dbValue);
        }
        if (filters.clinicId != null) {
          query = query.eq('clinic_id', filters.clinicId!);
        }
        if (filters.guideId != null) {
          query = query.eq('guide_id', filters.guideId!);
        }
        if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
          // 검색은 예약번호로 검색 (간단화)
          query = query.ilike('reservation_number', '%${filters.searchQuery}%');
        }
      }

      // 정렬 및 페이지네이션
      final paginatedQuery = query
          .order(orderBy, ascending: ascending)
          .range((page - 1) * pageSize, page * pageSize - 1);

      final response = await paginatedQuery;
      final data = response as List<dynamic>;

      // 전체 개수 조회 (별도 쿼리 - 간단화)
      final totalCount =
          data.length < pageSize
              ? (page - 1) * pageSize + data.length
              : page * pageSize + 1;

      // 데이터 변환
      final reservations =
          data.map((json) => Reservation.fromJson(json)).toList();

      return PaginatedReservations(
        reservations: reservations,
        totalCount: totalCount,
        page: page,
        pageSize: pageSize,
        hasNextPage: data.length == pageSize,
      );
    } catch (e) {
      throw Exception('예약 목록 조회 실패: $e');
    }
  }

  // 단일 예약 조회
  Future<Reservation?> getReservation(String id) async {
    try {
      final response =
          await _supabase
              .from('reservations')
              .select('''
            *,
            clinic:clinics(*),
            customers!customers_reservation_id_fkey(*),
            assigned_guide:guides(id, nickname, phone, email)
          ''')
              .eq('id', id)
              .maybeSingle();

      if (response == null) return null;
      return Reservation.fromJson(response);
    } catch (e) {
      throw Exception('예약 조회 실패: $e');
    }
  }

  // 예약 상태 변경
  Future<Reservation> updateReservationStatus(
    String id,
    ReservationStatus status,
  ) async {
    try {
      await _supabase
          .from('reservations')
          .update({
            'status': status.dbValue,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select('''
            *,
            clinic:clinics(*),
            customers!customers_reservation_id_fkey(*),
            assigned_guide:guides(id, nickname, phone, email)
          ''')
          .single();

      final updatedReservation = await getReservation(id);
      if (updatedReservation == null) {
        throw Exception('예약 상태 변경 후 데이터 조회에 실패했습니다.');
      }
      return updatedReservation;
    } catch (e) {
      throw Exception('예약 상태 변경 실패: $e');
    }
  }

  // 가이드 배정
  Future<Reservation> assignGuide(String reservationId, String guideId) async {
    try {
      await _supabase
          .from('reservations')
          .update({
            'guide_id': guideId,
            'status': ReservationStatus.assigned.dbValue,
            'assigned_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', reservationId);

      final updatedReservation = await getReservation(reservationId);
      if (updatedReservation == null) {
        throw Exception('가이드 배정 후 데이터 조회에 실패했습니다.');
      }
      return updatedReservation;
    } catch (e) {
      throw Exception('가이드 배정 실패: $e');
    }
  }

  // 클리닉 목록 조회 (드롭다운용)
  Future<List<Clinic>> getClinics() async {
    try {
      final response = await _supabase
          .from('clinics')
          .select('*')
          .order('clinic_name');

      return (response as List<dynamic>)
          .map((json) => Clinic.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('클리닉 목록 조회 실패: $e');
    }
  }

  // 가이드 목록 조회 (드롭다운용)
  Future<List<ReservationGuide>> getGuides() async {
    try {
      final response = await _supabase
          .from('guides')
          .select('id, nickname, phone, email')
          .eq('status', 'active')
          .order('nickname');

      return (response as List<dynamic>)
          .map((json) => ReservationGuide.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('가이드 목록 조회 실패: $e');
    }
  }

  // 가이드 추천 (기본 알고리즘)
  Future<List<ReservationGuide>> getRecommendedGuides({
    required DateTime reservationDate,
    required DateTime startTime,
    required DateTime endTime,
    required List<String> requiredLanguages,
    required List<String> requiredSpecialties,
    String? clinicRegion,
    int limit = 5,
  }) async {
    try {
      // 1. 기본 조건: 활성 상태, 언어 매칭
      var query = _supabase
          .from('guides')
          .select('''
            id, nickname, phone, email,
            guide_languages!inner(language_code),
            guide_specialties!inner(specialty_id)
          ''')
          .eq('status', 'active');

      // 2. 언어 조건 (간단화 - 복잡한 필터링은 나중에 구현)
      // if (requiredLanguages.isNotEmpty) {
      //   query = query.in_('guide_languages.language_code', requiredLanguages);
      // }

      // 3. 전문분야 조건 (간단화 - 복잡한 필터링은 나중에 구현)
      // if (requiredSpecialties.isNotEmpty) {
      //   query = query.in_('guide_specialties.specialty_id', requiredSpecialties);
      // }

      // 4. 가용성 체크 (해당 시간대에 다른 예약이 없는지)
      // 이 부분은 복잡한 쿼리가 필요하므로 일단 기본 구현

      final response = await query.limit(limit);

      return (response as List<dynamic>)
          .map(
            (json) => ReservationGuide.fromJson({
              'id': json['id'],
              'nickname': json['nickname'],
              'phone': json['phone'],
              'email': json['email'],
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('가이드 추천 실패: $e');
    }
  }

  // 예약 생성
  Future<Reservation> createReservation(
    CreateReservationRequestNew request,
  ) async {
    try {
      // 1. 예약 번호 생성
      final reservationNumber = await _generateReservationNumber();

      // 2. 예약자 정보 확인 및 처리
      final booker = request.booker;
      final bookerName = booker?.name ?? '';

      // 예약자가 없으면 에러
      if (booker == null) {
        throw Exception('예약자를 선택해주세요.');
      }

      // 3. 고객 데이터 먼저 생성 (booker_id를 얻기 위해)
      final List<Map<String, dynamic>> customerDataList =
          request.customers
              .map(
                (customer) => {
                  'name': customer.name,
                  'nationality': customer.nationality,
                  'birth_date':
                      customer.birthDate?.toIso8601String().split('T')[0],
                  'gender': customer.gender,
                  'customer_note': customer.notes,
                  'is_booker': customer.isBooker,
                  'booker':
                      customer.isBooker
                          ? customer.name
                          : bookerName, // 예약자는 자기 이름, 다른 사람은 예약자 이름
                  'age': customer.calculateAge(
                    request.reservationDate,
                  ), // 나이 계산하여 저장
                },
              )
              .toList();

      final customerResponse = await _supabase
          .from('customers')
          .insert(customerDataList)
          .select('id, is_booker')
          .order('is_booker', ascending: false); // 예약자가 먼저 오도록

      // 4. 예약자의 ID 찾기
      String? bookerId;
      for (final customer in customerResponse) {
        if (customer['is_booker'] == true) {
          bookerId = customer['id'] as String;
          break;
        }
      }

      // 5. 예약 데이터 생성
      final reservationData = {
        'reservation_number': reservationNumber,
        'reservation_date':
            request.reservationDate.toIso8601String().split('T')[0],
        'start_time': request.startTime,
        'end_time': request.endTime,
        'duration_minutes': request.durationMinutes,
        'clinic_id': request.clinicId,
        'service_type': request.serviceType?.code,
        'status': 'pending_assignment', // guide_id가 없으므로 배정 대기 상태
        'special_notes': request.notes,
        'contact_info': request.contactInfo,
        'booker_id': bookerId,
        'group_size': request.customers.length, // 실제 고객 수로 설정
        'total_amount': 0,
        'commission_rate': 4.5,
        'commission_amount': 0,
        'payment_amount': 0,
        'settlement_status': 'pending',
      };

      final reservationResponse =
          await _supabase
              .from('reservations')
              .insert(reservationData)
              .select()
              .single();

      final reservationId = reservationResponse['id'] as String;

      // 6. 고객 데이터에 reservation_id 업데이트
      final customerIds =
          customerResponse.map((c) => c['id'] as String).toList();
      await _supabase
          .from('customers')
          .update({'reservation_id': reservationId})
          .inFilter('id', customerIds);

      // 7. 완성된 예약 데이터 조회
      final reservation = await getReservation(reservationId);
      if (reservation == null) {
        throw Exception('예약 생성 후 데이터 조회에 실패했습니다.');
      }
      return reservation;
    } on PostgrestException catch (error) {
      dev.log(
        'PostgrestException in createReservation: ${error.message}',
        error: error,
      );
      throw Exception('예약 생성 중 데이터베이스 오류가 발생했습니다. 입력 정보를 확인해 주세요.');
    } catch (e) {
      dev.log('Unexpected error in createReservation: $e', error: e);
      throw Exception('예약 생성 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 예약 수정
  Future<Reservation> updateReservation(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _supabase.from('reservations').update(updates).eq('id', id);

      final reservation = await getReservation(id);
      if (reservation == null) {
        throw Exception('예약 수정 후 데이터 조회에 실패했습니다.');
      }
      return reservation;
    } on PostgrestException catch (error) {
      dev.log(
        'PostgrestException in updateReservation: ${error.message}',
        error: error,
      );
      throw Exception('예약 수정 중 데이터베이스 오류가 발생했습니다. 입력 정보를 확인해 주세요.');
    } catch (e) {
      dev.log('Unexpected error in updateReservation: $e', error: e);
      throw Exception('예약 수정 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 예약 통계 조회
  Future<ReservationStats> getReservationStats() async {
    try {
      final response = await _supabase.from('reservations').select('status');

      final data = response as List<dynamic>;

      int pending = 0;
      int assigned = 0;
      int inProgress = 0;
      int completed = 0;
      int cancelled = 0;

      for (final item in data) {
        final status = item['status'] as String?;
        switch (status) {
          case 'pending':
            pending++;
            break;
          case 'assigned':
            assigned++;
            break;
          case 'in_progress':
            inProgress++;
            break;
          case 'completed':
            completed++;
            break;
          case 'cancelled':
            cancelled++;
            break;
        }
      }

      return ReservationStats(
        totalReservations: data.length,
        pendingReservations: pending,
        assignedReservations: assigned,
        inProgressReservations: inProgress,
        completedReservations: completed,
        cancelledReservations: cancelled,
      );
    } on PostgrestException catch (error) {
      dev.log(
        'PostgrestException in getReservationStats: ${error.message}',
        error: error,
      );
      throw Exception('통계 조회 중 데이터베이스 오류가 발생했습니다.');
    } catch (e) {
      dev.log('Unexpected error in getReservationStats: $e', error: e);
      throw Exception('통계 조회 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 서비스 타입 목록 조회 (더 이상 DB 조회 불필요 - enum 사용)
  List<ServiceTypeEnum> getServiceTypes() {
    return ServiceTypeEnum.values;
  }

  // 가이드 목록 조회 (배정용) - 간단화
  Future<List<ReservationGuide>> getAvailableGuides({
    DateTime? startTime,
    int? durationMinutes,
    List<String>? requiredLanguages,
    List<String>? requiredSpecialties,
    int limit = 10,
  }) async {
    try {
      // 기본 가이드 쿼리 (간단화)
      final response = await _supabase
          .from('guides')
          .select('id, nickname, phone, email')
          .eq('is_active', true)
          .limit(limit);

      return (response as List<dynamic>)
          .map(
            (json) => ReservationGuide.fromJson({
              'id': json['id'],
              'nickname': json['nickname'],
              'phone': json['phone'],
              'email': json['email'],
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('가이드 목록 조회 실패: $e');
    }
  }

  // 가이드 추천 목록 조회
  Future<List<GuideRecommendation>> getGuideRecommendations(
    String reservationId,
  ) async {
    try {
      log(
        '🔍 Starting getGuideRecommendations for reservation: $reservationId',
        name: 'ReservationsRepository',
      );

      // 예약 정보 조회
      final reservation = await getReservation(reservationId);
      if (reservation == null) {
        throw Exception('예약을 찾을 수 없습니다');
      }
      log(
        '📊 Found reservation: ${reservation.reservationNumber}',
        name: 'ReservationsRepository',
      );

      // 모든 가이드 조회 (단순화)
      log('📊 Fetching guides...', name: 'ReservationsRepository');
      final guidesResponse = await _supabase
          .from('guides')
          .select('*')
          .eq('is_active', true);

      log(
        '📊 Raw guides response: $guidesResponse',
        name: 'ReservationsRepository',
      );
      log(
        '📊 Guides count: ${guidesResponse?.length ?? 0}',
        name: 'ReservationsRepository',
      );

      if (guidesResponse == null || guidesResponse.isEmpty) {
        log('⚠️ No guides found', name: 'ReservationsRepository');
        return [];
      }

      // 가이드 데이터 변환
      final recommendations = <GuideRecommendation>[];

      for (int i = 0; i < guidesResponse.length; i++) {
        try {
          final guideData = guidesResponse[i] as Map<String, dynamic>;
          print('📊 Processing guide $i: ${guideData['nickname']}');

          // ReservationGuide 객체 생성
          final guide = ReservationGuide(
            id: guideData['id'] as String,
            nickname: guideData['nickname'] as String? ?? '이름 없음',
            phoneNumber:
                guideData['phone'] as String? ??
                guideData['phone_number'] as String?,
            email: guideData['email'] as String?,
          );

          // 기본 추천 정보 생성
          recommendations.add(
            GuideRecommendation(
              guide: guide,
              matchScore: 80.0, // 임시 점수
              matchReasons: ['언어 매칭', '전문분야 매칭'], // 임시 이유
              isAvailable: true, // 임시로 모든 가이드 사용 가능으로 설정
            ),
          );

          print('✅ Successfully processed guide $i');
        } catch (e) {
          print('❌ Error processing guide $i: $e');
        }
      }

      print(
        '✅ Successfully loaded ${recommendations.length} guide recommendations',
      );
      return recommendations;
    } catch (e, stackTrace) {
      print('❌ Error in getGuideRecommendations: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  // 예약 번호 생성
  Future<String> _generateReservationNumber() async {
    final now = DateTime.now();
    final datePrefix =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    // 오늘 날짜의 예약 개수 조회
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final response = await _supabase
        .from('reservations')
        .select('id')
        .gte('created_at', today.toIso8601String())
        .lt('created_at', tomorrow.toIso8601String());

    final count = (response as List).length + 1;
    final sequence = count.toString().padLeft(3, '0');

    return 'R$datePrefix$sequence';
  }

  // 가이드 가용성 확인 (간소화)
  Future<bool> _checkGuideAvailability(
    String guideId,
    DateTime startTime,
    int durationMinutes,
  ) async {
    final endTime = startTime.add(Duration(minutes: durationMinutes));

    final conflictingReservations = await _supabase
        .from('reservations')
        .select('*')
        .eq('guide_id', guideId)
        .neq('status', 'cancelled')
        .gte('start_time', startTime.toIso8601String())
        .lte('start_time', endTime.toIso8601String());

    return (conflictingReservations as List).isEmpty;
  }

  // 국적에서 언어 코드 추출 (간단한 매핑)
  String _getLanguageCodeFromNationality(String nationality) {
    switch (nationality.toLowerCase()) {
      case 'china':
      case '중국':
        return 'zh';
      case 'japan':
      case '일본':
        return 'ja';
      case 'usa':
      case 'america':
      case '미국':
        return 'en';
      case 'korea':
      case '한국':
        return 'ko';
      default:
        return 'en'; // 기본값
    }
  }

  DateTime _parseDateTime(String reservationDateStr, String startTimeStr) {
    try {
      final reservationDate = DateTime.parse(reservationDateStr);

      // start_time이 "10:00:00" 형식인 경우 파싱
      final timeParts = startTimeStr.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(
        reservationDate.year,
        reservationDate.month,
        reservationDate.day,
        hour,
        minute,
      );
    } catch (e) {
      print(
        '❌ Error parsing datetime: $reservationDateStr + $startTimeStr, error: $e',
      );
      // 기본값으로 예약 날짜만 반환
      return DateTime.parse(reservationDateStr);
    }
  }

  // 예약 상태 업데이트 메서드 추가
  Future<Reservation> updateStatus(
    String reservationId,
    ReservationStatus status,
  ) async {
    return updateReservationStatus(reservationId, status);
  }
}
