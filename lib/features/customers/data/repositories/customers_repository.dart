import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';

part 'customers_repository.g.dart';

/// 고객 관리 Repository
class CustomersRepository {
  CustomersRepository({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// 고객코드 자동 생성
  /// 형식: [FullName_FirstCapital_RestLower][Nationality][YYMMDD]
  /// 예: smith_john_KR_241225
  String _generateCustomerCode({
    required String name,
    String? nationality,
    DateTime? birthDate,
  }) {
    // 이름 처리: 공백 제거하고 첫 글자만 대문자, 나머지는 소문자
    final processedName =
        name
            .trim()
            .replaceAll(RegExp(r'\s+'), '') // 모든 공백 제거
            .toLowerCase(); // 전체를 소문자로

    // 첫 글자만 대문자로 변경
    final formattedName =
        processedName.isNotEmpty
            ? processedName[0].toUpperCase() + processedName.substring(1)
            : processedName;

    // 국적 코드 (기본값: XX)
    final nationalityCode = nationality?.toUpperCase() ?? 'XX';

    // 생년월일 처리 (YYMMDD 형식)
    String birthDateStr = '000000';
    if (birthDate != null) {
      final year = (birthDate.year % 100).toString().padLeft(2, '0');
      final month = birthDate.month.toString().padLeft(2, '0');
      final day = birthDate.day.toString().padLeft(2, '0');
      birthDateStr = '$year$month$day';
    }

    return '${formattedName}_${nationalityCode}_$birthDateStr';
  }

  /// 고객 목록 조회
  Future<List<Customer>> getCustomers({
    CustomerFilters? filters,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabaseClient
          .from('customers')
          .select('*')
          .order('created_at', ascending: false);

      // 필터 적용
      if (filters != null) {
        query = _applyFilters(query, filters);
      }

      // 페이지네이션
      if (limit != null) {
        query = query.limit(limit);
      }
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 50) - 1);
      }

      final response = await query;
      print('Raw response from Supabase: $response'); // 디버깅용 로그

      if (response.isEmpty) {
        return [];
      }

      return response.map<Customer>((json) {
        try {
          print('Processing JSON: $json'); // 디버깅용 로그
          return Customer.fromJson(json);
        } catch (e) {
          print('Error parsing customer JSON: $e'); // 디버깅용 로그
          print('JSON data: $json'); // 디버깅용 로그
          rethrow;
        }
      }).toList();
    } catch (e) {
      print('Error in getCustomers: $e'); // 디버깅용 로그
      throw Exception('고객 목록 조회 실패: $e');
    }
  }

  /// 고객 상세 조회
  Future<Customer?> getCustomerById(String id) async {
    try {
      final response =
          await _supabaseClient
              .from('customers')
              .select('*')
              .eq('id', id)
              .maybeSingle();

      if (response == null) return null;

      return Customer.fromJson(response);
    } catch (e) {
      throw Exception('고객 상세 조회 실패: $e');
    }
  }

  /// 고객 코드로 조회
  Future<Customer?> getCustomerByCode(String customerCode) async {
    try {
      final response =
          await _supabaseClient
              .from('customers')
              .select('*')
              .eq('customer_code', customerCode)
              .maybeSingle();

      if (response == null) return null;

      return Customer.fromJson(response);
    } catch (e) {
      throw Exception('고객 코드 조회 실패: $e');
    }
  }

  /// 고객 생성
  Future<Customer> createCustomer(CustomerInput input) async {
    try {
      // 고객코드 자동 생성 (만약 제공되지 않았다면)
      String customerCode =
          input.customerCode ??
          _generateCustomerCode(
            name: input.name,
            nationality: input.nationality,
            birthDate: input.birthDate,
          );

      // 고객코드 중복 확인 및 유니크 코드 생성
      Customer? existingCustomer = await getCustomerByCode(customerCode);
      if (existingCustomer != null) {
        // 중복된 경우 타임스탬프 추가
        final timestamp = DateTime.now().millisecondsSinceEpoch
            .toString()
            .substring(8);
        customerCode = '${customerCode}_$timestamp';
      }

      // 수정된 입력 데이터 생성
      final modifiedInput = input.copyWith(customerCode: customerCode);

      final response =
          await _supabaseClient
              .from('customers')
              .insert(modifiedInput.toJson())
              .select()
              .single();

      return Customer.fromJson(response);
    } catch (e) {
      print('Error in createCustomer: $e'); // 디버깅용 로그
      throw Exception('고객 생성 실패: $e');
    }
  }

  /// 고객 정보 수정
  Future<Customer> updateCustomer(String id, CustomerInput input) async {
    try {
      // 고객 코드 중복 체크 (다른 고객이 사용 중인지)
      if (input.customerCode != null) {
        final existing = await getCustomerByCode(input.customerCode!);
        if (existing != null && existing.id != id) {
          throw Exception('이미 존재하는 고객 코드입니다: ${input.customerCode}');
        }
      }

      final response =
          await _supabaseClient
              .from('customers')
              .update(input.toJson())
              .eq('id', id)
              .select()
              .single();

      return Customer.fromJson(response);
    } catch (e) {
      throw Exception('고객 정보 수정 실패: $e');
    }
  }

  /// 고객 삭제
  Future<void> deleteCustomer(String id) async {
    try {
      await _supabaseClient.from('customers').delete().eq('id', id);
    } catch (e) {
      throw Exception('고객 삭제 실패: $e');
    }
  }

  /// 고객 검색
  Future<List<Customer>> searchCustomers(String searchQuery) async {
    try {
      final response = await _supabaseClient
          .from('customers')
          .select('*')
          .or(
            'name.ilike.%$searchQuery%,'
            'passport_name.ilike.%$searchQuery%,'
            'customer_code.ilike.%$searchQuery%,'
            'phone.ilike.%$searchQuery%',
          )
          .order('created_at', ascending: false);

      return response.map<Customer>((json) => Customer.fromJson(json)).toList();
    } catch (e) {
      throw Exception('고객 검색 실패: $e');
    }
  }

  /// 고객 통계 조회
  Future<CustomerStats> getCustomerStats() async {
    try {
      // 전체 고객 수
      final totalCountResponse =
          await _supabaseClient.from('customers').select().count();
      final totalCount = totalCountResponse.count;

      // 신규 고객 수 (최근 30일)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final newCustomersResponse =
          await _supabaseClient
              .from('customers')
              .select()
              .gte('created_at', thirtyDaysAgo.toIso8601String())
              .count();
      final newCustomersCount = newCustomersResponse.count;

      // 재구매 고객 수
      final returningCustomersResponse =
          await _supabaseClient
              .from('customers')
              .select()
              .gt('total_payment_amount', 0)
              .count();
      final returningCustomersCount = returningCustomersResponse.count;

      // 간단한 통계만 사용
      final totalRevenue = 0.0;
      final avgRevenue = 0.0;

      return CustomerStats(
        totalCustomers: totalCount,
        newCustomers: newCustomersCount,
        returningCustomers: returningCustomersCount,
        totalRevenue: totalRevenue,
        averageRevenuePerCustomer: avgRevenue,
        customersByNationality: {},
        customersByChannel: {},
        customersByGender: {},
      );
    } catch (e) {
      throw Exception('고객 통계 조회 실패: $e');
    }
  }

  /// 필터 적용 헬퍼 메서드
  dynamic _applyFilters(dynamic query, CustomerFilters filters) {
    if (filters.searchQuery?.isNotEmpty == true) {
      query = query.or(
        'name.ilike.%${filters.searchQuery}%,'
        'passport_name.ilike.%${filters.searchQuery}%,'
        'customer_code.ilike.%${filters.searchQuery}%,'
        'phone.ilike.%${filters.searchQuery}%',
      );
    }

    if (filters.gender != null) {
      query = query.eq('gender', filters.gender!.name);
    }

    if (filters.nationality?.isNotEmpty == true) {
      query = query.eq('nationality', filters.nationality!);
    }

    if (filters.acquisitionChannel?.isNotEmpty == true) {
      query = query.eq('acquisition_channel', filters.acquisitionChannel!);
    }

    if (filters.communicationChannel?.isNotEmpty == true) {
      query = query.eq('communication_channel', filters.communicationChannel!);
    }

    if (filters.isBooker != null) {
      query = query.eq('is_booker', filters.isBooker!);
    }

    if (filters.createdAfter != null) {
      query = query.gte('created_at', filters.createdAfter!.toIso8601String());
    }

    if (filters.createdBefore != null) {
      query = query.lte('created_at', filters.createdBefore!.toIso8601String());
    }

    if (filters.minPaymentAmount != null) {
      query = query.gte('total_payment_amount', filters.minPaymentAmount!);
    }

    if (filters.maxPaymentAmount != null) {
      query = query.lte('total_payment_amount', filters.maxPaymentAmount!);
    }

    return query;
  }

  /// 국적별 통계 조회
  Future<Map<String, int>> _getNationalityStats() async {
    final response = await _supabaseClient
        .from('customers')
        .select('nationality')
        .not('nationality', 'is', null);

    final stats = <String, int>{};
    for (final item in response) {
      final nationality = item['nationality'] as String?;
      if (nationality != null) {
        stats[nationality] = (stats[nationality] ?? 0) + 1;
      }
    }
    return stats;
  }

  /// 채널별 통계 조회
  Future<Map<String, int>> _getChannelStats() async {
    final response = await _supabaseClient
        .from('customers')
        .select('acquisition_channel')
        .not('acquisition_channel', 'is', null);

    final stats = <String, int>{};
    for (final item in response) {
      final channel = item['acquisition_channel'] as String?;
      if (channel != null) {
        stats[channel] = (stats[channel] ?? 0) + 1;
      }
    }
    return stats;
  }

  /// 성별 통계 조회
  Future<Map<CustomerGender, int>> _getGenderStats() async {
    final response = await _supabaseClient
        .from('customers')
        .select('gender')
        .not('gender', 'is', null);

    final stats = <CustomerGender, int>{};
    for (final item in response) {
      final genderStr = item['gender'] as String?;
      if (genderStr != null) {
        final gender = CustomerGender.values.firstWhere(
          (g) => g.name == genderStr,
        );
        stats[gender] = (stats[gender] ?? 0) + 1;
      }
    }
    return stats;
  }
}

/// CustomersRepository Provider
@riverpod
CustomersRepository customersRepository(CustomersRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return CustomersRepository(supabaseClient: supabase);
}
