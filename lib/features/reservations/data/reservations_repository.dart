import 'package:supabase_flutter/supabase_flutter.dart';
import 'simple_models.dart';
import 'dart:developer' as dev;

class ReservationsRepository {
  final SupabaseClient _supabase;

  ReservationsRepository(this._supabase);

  // 예약 목록 조회 (페이지네이션 및 필터링)
  Future<PaginatedReservations> getReservations({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? clinicId,
    String? guideId,
  }) async {
    try {
      print('🔍 Starting getReservations...');
      print('📊 Parameters: page=$page, pageSize=$pageSize, status=$status');
      
      // 1. 기본 예약 데이터 조회 (페이징)
      print('📊 Step 1: Fetching reservations...');
      final offset = (page - 1) * pageSize;
      
      final response = await _supabase
          .from('reservations')
          .select('*')
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1);
      
      print('📊 Raw response: $response');
      print('📊 Response type: ${response.runtimeType}');
      print('📊 Response length: ${response?.length ?? 'null'}');

      if (response == null || response.isEmpty) {
        print('⚠️ No data found');
        return PaginatedReservations(
          reservations: [],
          totalCount: 0,
          page: page,
          pageSize: pageSize,
          hasNextPage: false,
        );
      }

      // 2. 데이터 변환
      print('📊 Step 2: Converting to Reservation objects...');
      final reservations = <Reservation>[];
      
      for (int i = 0; i < response.length; i++) {
        try {
          final item = response[i] as Map<String, dynamic>;
          print('📊 Processing item $i: ${item.keys.toList()}');
          
          final reservation = Reservation(
            id: item['id'] as String,
            reservationNumber: item['reservation_number'] as String,
            reservationDate: DateTime.parse(item['reservation_date'] as String),
            startTime: _parseDateTime(item['reservation_date'] as String, item['start_time'] as String),
            durationMinutes: item['duration_minutes'] as int? ?? 180,
            clinicId: item['clinic_id'] as String,
            status: ReservationStatus.fromDbValue(item['status'] as String),
            guideId: item['guide_id'] as String?,
            notes: item['special_notes'] as String?,
            createdAt: DateTime.parse(item['created_at'] as String),
            updatedAt: item['updated_at'] != null ? DateTime.parse(item['updated_at'] as String) : null,
            // 관계 데이터는 임시로 null/빈 리스트
            clinic: null,
            guide: null,
            customers: [],
            serviceTypes: [],
          );
          
          reservations.add(reservation);
          print('✅ Successfully converted item $i');
        } catch (e) {
          print('❌ Error converting item $i: $e');
          print('❌ Item data: ${response[i]}');
        }
      }

      print('✅ Successfully loaded ${reservations.length} reservations');
      
      // 총 개수는 현재 페이지 데이터 기준으로 추정
      final totalCount = reservations.length < pageSize ? 
          (page - 1) * pageSize + reservations.length : 
          page * pageSize + 1; // 다음 페이지가 있을 수 있음을 표시
      
      return PaginatedReservations(
        reservations: reservations,
        totalCount: totalCount,
        page: page,
        pageSize: pageSize,
        hasNextPage: reservations.length == pageSize,
      );
      
    } catch (e, stackTrace) {
      print('❌ Error in getReservations: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  // 예약 상세 조회
  Future<Reservation?> getReservation(String id) async {
    try {
      print('🔍 Starting getReservation for id: $id');
      
      final response = await _supabase
          .from('reservations')
          .select('*')
          .eq('id', id)
          .single();

      print('📊 Found reservation: ${response['reservation_number']}');
      
      // 단순한 Reservation 객체 생성
      final reservation = Reservation(
        id: response['id'] as String,
        reservationNumber: response['reservation_number'] as String,
        reservationDate: DateTime.parse(response['reservation_date'] as String),
        startTime: _parseDateTime(response['reservation_date'] as String, response['start_time'] as String),
        durationMinutes: response['duration_minutes'] as int? ?? 180,
        clinicId: response['clinic_id'] as String,
        status: ReservationStatus.fromDbValue(response['status'] as String),
        guideId: response['guide_id'] as String?,
        notes: response['special_notes'] as String?,
        createdAt: DateTime.parse(response['created_at'] as String),
        updatedAt: response['updated_at'] != null ? DateTime.parse(response['updated_at'] as String) : null,
        // 관계 데이터는 임시로 null/빈 리스트
        clinic: null,
        guide: null,
        customers: [],
        serviceTypes: [],
      );
      
      print('✅ Successfully loaded reservation: ${reservation.reservationNumber}');
      return reservation;
      
    } catch (e, stackTrace) {
      print('❌ Error in getReservation: $e');
      print('❌ Stack trace: $stackTrace');
      return null;
    }
  }

  // 예약 생성
  Future<Reservation> createReservation(CreateReservationRequest request) async {
    try {
      // 1. 예약 번호 생성
      final reservationNumber = await _generateReservationNumber();

      // 2. 예약 데이터 생성
      final reservationData = {
        'reservation_number': reservationNumber,
        'reservation_date': request.reservationDate.toIso8601String(),
        'start_time': request.startTime.toIso8601String(),
        'duration_minutes': request.durationMinutes,
        'clinic_id': request.clinicId,
        'guide_id': request.guideId,
        'status': ReservationStatus.pendingAssignment.dbValue,
        'notes': request.notes,
      };

      final reservationResponse = await _supabase
          .from('reservations')
          .insert(reservationData)
          .select()
          .single();

      final reservationId = reservationResponse['id'] as String;

      // 3. 고객 데이터 생성 및 연결
      for (final customerRequest in request.customers) {
        final customerData = {
          'name': customerRequest.name,
          'phone_number': customerRequest.phoneNumber,
          'nationality': customerRequest.nationality,
          'email': customerRequest.email,
          'notes': customerRequest.notes,
        };

        final customerResponse = await _supabase
            .from('customers')
            .insert(customerData)
            .select()
            .single();

        // 예약-고객 연결
        await _supabase.from('reservation_customers').insert({
          'reservation_id': reservationId,
          'customer_id': customerResponse['id'],
        });
      }

      // 4. 서비스 타입 연결
      for (final serviceTypeId in request.serviceTypeIds) {
        await _supabase.from('reservation_service_types').insert({
          'reservation_id': reservationId,
          'service_type_id': serviceTypeId,
        });
      }

      // 5. 완성된 예약 데이터 조회
      final reservation = await getReservation(reservationId);
      if (reservation == null) {
        throw Exception('예약 생성 후 데이터 조회에 실패했습니다.');
      }
      return reservation;
    } on PostgrestException catch (error) {
      dev.log('PostgrestException in createReservation: ${error.message}', error: error);
      throw Exception('예약 생성 중 데이터베이스 오류가 발생했습니다. 입력 정보를 확인해 주세요.');
    } catch (e) {
      dev.log('Unexpected error in createReservation: $e', error: e);
      throw Exception('예약 생성 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 예약 수정
  Future<Reservation> updateReservation(String id, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('reservations')
          .update(updates)
          .eq('id', id);

      final reservation = await getReservation(id);
      if (reservation == null) {
        throw Exception('예약 수정 후 데이터 조회에 실패했습니다.');
      }
      return reservation;
    } on PostgrestException catch (error) {
      dev.log('PostgrestException in updateReservation: ${error.message}', error: error);
      throw Exception('예약 수정 중 데이터베이스 오류가 발생했습니다. 입력 정보를 확인해 주세요.');
    } catch (e) {
      dev.log('Unexpected error in updateReservation: $e', error: e);
      throw Exception('예약 수정 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 가이드 할당
  Future<Reservation> assignGuide(String reservationId, String guideId) async {
    try {
      final updates = {
        'guide_id': guideId,
        'status': ReservationStatus.assigned.dbValue,
        'updated_at': DateTime.now().toIso8601String(),
      };

      return await updateReservation(reservationId, updates);
    } on PostgrestException catch (error) {
      dev.log('PostgrestException in assignGuide: ${error.message}', error: error);
      throw Exception('가이드 할당 중 데이터베이스 오류가 발생했습니다.');
    } catch (e) {
      dev.log('Unexpected error in assignGuide: $e', error: e);
      throw Exception('가이드 할당 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 예약 상태 변경
  Future<Reservation> updateStatus(String reservationId, ReservationStatus status) async {
    try {
      final updates = {
        'status': status.dbValue,
        'updated_at': DateTime.now().toIso8601String(),
      };

      return await updateReservation(reservationId, updates);
    } on PostgrestException catch (error) {
      dev.log('PostgrestException in updateStatus: ${error.message}', error: error);
      throw Exception('상태 변경 중 데이터베이스 오류가 발생했습니다.');
    } catch (e) {
      dev.log('Unexpected error in updateStatus: $e', error: e);
      throw Exception('상태 변경 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 예약 통계 조회
  Future<ReservationStats> getReservationStats() async {
    try {
      final response = await _supabase
          .from('reservations')
          .select('status');

      final data = response as List<dynamic>;
      
      int pendingAssignment = 0;
      int assigned = 0;
      int inProgress = 0;
      int completed = 0;
      int cancelled = 0;

      for (final item in data) {
        final status = item['status'] as String?;
        switch (status) {
          case 'pending_assignment':
            pendingAssignment++;
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
        pendingAssignment: pendingAssignment,
        assigned: assigned,
        inProgress: inProgress,
        completed: completed,
        cancelled: cancelled,
        total: data.length,
      );
    } on PostgrestException catch (error) {
      dev.log('PostgrestException in getReservationStats: ${error.message}', error: error);
      throw Exception('통계 조회 중 데이터베이스 오류가 발생했습니다.');
    } catch (e) {
      dev.log('Unexpected error in getReservationStats: $e', error: e);
      throw Exception('통계 조회 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 병원 목록 조회
  Future<List<Clinic>> getClinics() async {
    try {
      final response = await _supabase
          .from('clinics')
          .select('*')
          .order('name');

      final data = response as List<dynamic>;
      return data.map((json) => Clinic.fromJson(json)).toList();
    } on PostgrestException catch (error) {
      dev.log('PostgrestException in getClinics: ${error.message}', error: error);
      throw Exception('병원 목록 조회 중 데이터베이스 오류가 발생했습니다.');
    } catch (e) {
      dev.log('Unexpected error in getClinics: $e', error: e);
      throw Exception('병원 목록 조회 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 서비스 타입 목록 조회
  Future<List<ServiceType>> getServiceTypes() async {
    try {
      final response = await _supabase
          .from('service_types')
          .select('*')
          .order('name');

      final data = response as List<dynamic>;
      return data.map((json) => ServiceType.fromJson(json)).toList();
    } on PostgrestException catch (error) {
      dev.log('PostgrestException in getServiceTypes: ${error.message}', error: error);
      throw Exception('서비스 타입 조회 중 데이터베이스 오류가 발생했습니다.');
    } catch (e) {
      dev.log('Unexpected error in getServiceTypes: $e', error: e);
      throw Exception('서비스 타입 조회 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }

  // 가이드 추천 목록 조회
  Future<List<GuideRecommendation>> getGuideRecommendations(String reservationId) async {
    try {
      print('🔍 Starting getGuideRecommendations for reservation: $reservationId');
      
      // 예약 정보 조회
      final reservation = await getReservation(reservationId);
      if (reservation == null) {
        throw Exception('예약을 찾을 수 없습니다');
      }
      print('📊 Found reservation: ${reservation.reservationNumber}');

      // 모든 가이드 조회 (단순화)
      print('📊 Fetching guides...');
      final guidesResponse = await _supabase
          .from('guides')
          .select('*')
          .eq('is_active', true);

      print('📊 Raw guides response: $guidesResponse');
      print('📊 Guides count: ${guidesResponse?.length ?? 0}');

      if (guidesResponse == null || guidesResponse.isEmpty) {
        print('⚠️ No guides found');
        return [];
      }

      // 가이드 데이터 변환
      final recommendations = <GuideRecommendation>[];
      
      for (int i = 0; i < guidesResponse.length; i++) {
        try {
          final guideData = guidesResponse[i] as Map<String, dynamic>;
          print('📊 Processing guide $i: ${guideData['nickname']}');
          
          // 임시 Guide 객체 생성 (단순화)
          final guide = Guide(
            id: guideData['id'] as String,
            koreanName: guideData['nickname'] as String? ?? '이름 없음',
            englishName: guideData['passport_first_name'] as String? ?? '',
            nationality: guideData['nationality'] as String? ?? 'Unknown',
            gender: guideData['gender'] as String? ?? 'other',
            experienceYears: 1, // 임시값
            phoneNumber: guideData['phone'] as String?,
            email: guideData['email'] as String?,
            notes: null,
            createdAt: DateTime.parse(guideData['created_at'] as String),
            // 관계 데이터는 임시로 빈 리스트
            languages: [],
            specialties: [],
          );

          // 기본 추천 정보 생성
          recommendations.add(GuideRecommendation(
            guide: guide,
            isAvailable: true, // 임시로 모든 가이드 사용 가능으로 설정
            hasMatchingLanguage: true, // 임시로 모든 언어 매칭으로 설정
            hasMatchingSpecialty: true, // 임시로 모든 전문분야 매칭으로 설정
            matchScore: 80, // 임시 점수
            unavailabilityReason: null,
          ));
          
          print('✅ Successfully processed guide $i');
        } catch (e) {
          print('❌ Error processing guide $i: $e');
        }
      }

      print('✅ Successfully loaded ${recommendations.length} guide recommendations');
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
    final datePrefix = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    
    // 오늘 날짜의 예약 개수 조회
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    final response = await _supabase
        .from('reservations')
        .select('id')
        .gte('created_at', today.toIso8601String())
        .lt('created_at', tomorrow.toIso8601String())
        .count();

    final count = (response.count ?? 0) + 1;
    final sequence = count.toString().padLeft(3, '0');
    
    return 'R$datePrefix$sequence';
  }

  // 가이드 가용성 확인
  Future<({bool isAvailable, String? reason})> _checkGuideAvailability(
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
        .or(
          'start_time.lte.${startTime.toIso8601String()}.and.start_time.add.interval.${durationMinutes}minutes.gt.${startTime.toIso8601String()},'
          'start_time.lt.${endTime.toIso8601String()}.and.start_time.gte.${startTime.toIso8601String()}'
        );

    if (conflictingReservations.isNotEmpty) {
      return (isAvailable: false, reason: '해당 시간대에 다른 예약이 있습니다');
    }

    return (isAvailable: true, reason: null);
  }

  // 언어 매칭 확인
  bool _checkLanguageMatch(Guide guide, List<Customer> customers) {
    final guideLanguageCodes = guide.languages.map((l) => l.code.toLowerCase()).toSet();
    
    for (final customer in customers) {
      final customerLanguage = _getLanguageCodeFromNationality(customer.nationality);
      if (guideLanguageCodes.contains(customerLanguage)) {
        return true;
      }
    }
    
    return false;
  }

  // 전문 분야 매칭 확인
  bool _checkSpecialtyMatch(Guide guide, List<ServiceType> serviceTypes) {
    // 가이드의 전문 분야와 서비스 타입의 연관성 확인
    // 실제로는 서비스 타입과 전문 분야의 매핑 테이블이 필요할 수 있음
    return guide.specialties.isNotEmpty;
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
      case 'russia':
      case '러시아':
        return 'ru';
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
        minute
      );
    } catch (e) {
      print('❌ Error parsing datetime: $reservationDateStr + $startTimeStr, error: $e');
      // 기본값으로 예약 날짜만 반환
      return DateTime.parse(reservationDateStr);
    }
  }
} 