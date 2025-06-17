import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_admin_web/core/config/supabase_config.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';

part 'customers_repository.g.dart';

/// 고객 저장소
@riverpod
CustomersRepository customersRepository(CustomersRepositoryRef ref) {
  final supabase = ref.read(supabaseProvider);
  return CustomersRepository(supabase);
}

/// 고객 데이터 저장소
class CustomersRepository {
  final SupabaseClient _supabase;

  CustomersRepository(this._supabase);

  /// 고객 목록 조회
  Future<List<Customer>> getCustomers({
    CustomerFilters? filters,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic queryBuilder = _supabase.from('customers').select('*');

      // 필터 적용
      if (filters != null) {
        if (filters.name != null && filters.name!.isNotEmpty) {
          queryBuilder = queryBuilder.ilike('name', '%${filters.name}%');
        }
        if (filters.nationality != null && filters.nationality!.isNotEmpty) {
          queryBuilder = queryBuilder.eq('nationality', filters.nationality!);
        }
        if (filters.gender != null) {
          queryBuilder = queryBuilder.eq('gender', filters.gender!.value);
        }
        if (filters.isBooker != null) {
          queryBuilder = queryBuilder.eq('is_booker', filters.isBooker!);
        }
        if (filters.acquisitionChannel != null &&
            filters.acquisitionChannel!.isNotEmpty) {
          queryBuilder = queryBuilder.eq(
            'acquisition_channel',
            filters.acquisitionChannel!,
          );
        }
        if (filters.communicationChannel != null) {
          queryBuilder = queryBuilder.eq(
            'communication_channel',
            filters.communicationChannel!.value,
          );
        }
        if (filters.createdAfter != null) {
          queryBuilder = queryBuilder.gte(
            'created_at',
            filters.createdAfter!.toIso8601String(),
          );
        }
        if (filters.createdBefore != null) {
          queryBuilder = queryBuilder.lte(
            'created_at',
            filters.createdBefore!.toIso8601String(),
          );
        }
      }

      // 정렬
      queryBuilder = queryBuilder.order('created_at', ascending: false);

      // 페이지네이션
      if (limit != null) {
        queryBuilder = queryBuilder.limit(limit);
      }
      if (offset != null) {
        queryBuilder = queryBuilder.range(offset, offset + (limit ?? 50) - 1);
      }

      final response = await queryBuilder;

      if (response is! List) {
        throw Exception('Expected List but got ${response.runtimeType}');
      }

      return response.cast<Map<String, dynamic>>().map((json) {
        try {
          return Customer.fromJson(_mapFromDatabase(json));
        } catch (e) {
          print('Error mapping customer: $json, error: $e');
          rethrow;
        }
      }).toList();
    } catch (e) {
      throw Exception('고객 목록 조회 실패: $e');
    }
  }

  /// 고객 검색
  Future<List<Customer>> searchCustomers(String query) async {
    try {
      final response = await _supabase
          .from('customers')
          .select('*')
          .or(
            'name.ilike.%$query%,nationality.ilike.%$query%,passport_name.ilike.%$query%',
          )
          .order('created_at', ascending: false)
          .limit(50);

      if (response is! List) {
        throw Exception('Expected List but got ${response.runtimeType}');
      }

      return response.cast<Map<String, dynamic>>().map((json) {
        try {
          return Customer.fromJson(_mapFromDatabase(json));
        } catch (e) {
          print('Error mapping customer during search: $json, error: $e');
          rethrow;
        }
      }).toList();
    } catch (e) {
      throw Exception('고객 검색 실패: $e');
    }
  }

  /// 고객 상세 조회
  Future<Customer?> getCustomerById(String id) async {
    try {
      final response =
          await _supabase
              .from('customers')
              .select('*')
              .eq('id', id)
              .maybeSingle();

      if (response == null) return null;

      return Customer.fromJson(_mapFromDatabase(response));
    } catch (e) {
      throw Exception('고객 상세 조회 실패: $e');
    }
  }

  /// 고객 생성
  Future<Customer> createCustomer(CustomerInput input) async {
    try {
      final data = _mapToDatabase(input);
      print('Creating customer with data: $data');

      final response =
          await _supabase.from('customers').insert(data).select().single();

      print('Customer creation response: $response');
      return Customer.fromJson(_mapFromDatabase(response));
    } catch (e) {
      print('Customer creation error: $e');
      throw Exception('고객 생성 실패: $e');
    }
  }

  /// 고객 수정
  Future<Customer> updateCustomer(String id, CustomerInput input) async {
    try {
      final data = _mapToDatabase(input);
      final response =
          await _supabase
              .from('customers')
              .update(data)
              .eq('id', id)
              .select()
              .single();

      return Customer.fromJson(_mapFromDatabase(response));
    } catch (e) {
      throw Exception('고객 수정 실패: $e');
    }
  }

  /// 고객 삭제
  Future<void> deleteCustomer(String id) async {
    try {
      await _supabase.from('customers').delete().eq('id', id);
    } catch (e) {
      throw Exception('고객 삭제 실패: $e');
    }
  }

  /// 고객 통계 조회
  Future<CustomerStats> getCustomerStats() async {
    try {
      final response = await _supabase
          .from('customers')
          .select('gender, is_booker, age, created_at');

      final customers = response as List;
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      int totalCustomers = customers.length;
      int totalBookers = customers.where((c) => c['is_booker'] == true).length;
      int totalCompanions = totalCustomers - totalBookers;
      int maleCustomers = customers.where((c) => c['gender'] == 'M').length;
      int femaleCustomers = customers.where((c) => c['gender'] == 'F').length;

      double averageAge = 0.0;
      final agesWithValues =
          customers
              .where((c) => c['age'] != null)
              .map((c) => (c['age'] as num).toDouble())
              .toList();
      if (agesWithValues.isNotEmpty) {
        averageAge =
            agesWithValues.reduce((a, b) => a + b) / agesWithValues.length;
      }

      int newCustomers =
          customers.where((c) {
            final createdAt = _parseDateTime(c['created_at']);
            return createdAt != null && createdAt.isAfter(thirtyDaysAgo);
          }).length;

      int returningCustomers = totalCustomers - newCustomers;

      return CustomerStats(
        totalCustomers: totalCustomers,
        totalBookers: totalBookers,
        totalCompanions: totalCompanions,
        maleCustomers: maleCustomers,
        femaleCustomers: femaleCustomers,
        averageAge: averageAge,
        newCustomers: newCustomers,
        returningCustomers: returningCustomers,
        totalRevenue: 0.0, // TODO: 실제 매출 계산 로직 추가
      );
    } catch (e) {
      throw Exception('고객 통계 조회 실패: $e');
    }
  }

  /// 성별 파싱 (안전한 처리)
  CustomerGender? _parseGender(dynamic genderValue) {
    if (genderValue == null) return null;

    try {
      // 데이터베이스에서 full name으로 반환되는 경우 처리
      if (genderValue is String) {
        switch (genderValue.toLowerCase()) {
          case 'male':
          case 'm':
            return CustomerGender.male;
          case 'female':
          case 'f':
            return CustomerGender.female;
          case 'other':
          case 'o':
            return CustomerGender.other;
          default:
            return null;
        }
      }

      return CustomerGender.values.firstWhere((g) => g.value == genderValue);
    } catch (e) {
      print('Error parsing gender: $genderValue, error: $e');
      return null;
    }
  }

  /// 성별 값 파싱 (JSON 직렬화용)
  String? _parseGenderValue(dynamic genderValue) {
    if (genderValue == null) return null;

    try {
      // 데이터베이스에서 full name으로 반환되는 경우를 JSON 값으로 변환
      if (genderValue is String) {
        switch (genderValue.toLowerCase()) {
          case 'male':
          case 'm':
            return 'M';
          case 'female':
          case 'f':
            return 'F';
          case 'other':
          case 'o':
            return 'O';
          default:
            return null;
        }
      }

      return genderValue.toString();
    } catch (e) {
      print('Error parsing gender value: $genderValue, error: $e');
      return null;
    }
  }

  /// 날짜 파싱 (안전한 처리)
  DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is DateTime) {
        return dateValue;
      }
      // 디버깅을 위한 로그 추가
      print(
        'Unexpected date type: ${dateValue.runtimeType}, value: $dateValue',
      );
      return null;
    } catch (e) {
      // 파싱 실패 시 null 반환 및 로그
      print('DateTime parsing failed for value: $dateValue, error: $e');
      return null;
    }
  }

  /// 날짜 값 파싱 (JSON 직렬화용)
  String? _parseDateTimeValue(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      if (dateValue is String) {
        // 이미 문자열이면 그대로 반환
        return dateValue;
      } else if (dateValue is DateTime) {
        // DateTime 객체면 ISO 문자열로 변환
        return dateValue.toIso8601String();
      }

      // 다른 타입이면 문자열로 변환 시도
      return dateValue.toString();
    } catch (e) {
      print('DateTime value parsing failed for value: $dateValue, error: $e');
      return null;
    }
  }

  /// 데이터베이스에서 모델로 매핑
  Map<String, dynamic> _mapFromDatabase(Map<String, dynamic> data) {
    try {
      return {
        'id': data['id'],
        'name': data['name'],
        'nationality': data['nationality'],
        'gender': _parseGenderValue(data['gender']),
        'birthDate': _parseDateTimeValue(data['birth_date']),
        'age': _parseAge(data['age']),
        'passportName': data['passport_name'],
        'passportLastName': data['passport_last_name'],
        'passportFirstName': data['passport_first_name'],
        'isBooker': data['is_booker'] ?? true,
        'acquisitionChannel': data['acquisition_channel'],
        'booker': data['booker'],
        'customerNote': data['customer_note'],
        'communicationChannel': _parseCommunicationChannelValue(
          data['communication_channel'],
        ),
        'channelAccount': data['channel_account'],
        'createdAt': _parseDateTimeValue(data['created_at']),
        'updatedAt': _parseDateTimeValue(data['updated_at']),
      };
    } catch (e) {
      print('Error in _mapFromDatabase: $e');
      print('Raw data: $data');
      rethrow;
    }
  }

  /// 나이 파싱 (안전한 처리)
  double? _parseAge(dynamic ageValue) {
    if (ageValue == null) return null;

    try {
      if (ageValue is String) {
        return double.parse(ageValue);
      } else if (ageValue is num) {
        return ageValue.toDouble();
      }
      return null;
    } catch (e) {
      print('Error parsing age: $ageValue, error: $e');
      return null;
    }
  }

  /// 소통 채널 파싱 (안전한 처리)
  CommunicationChannel? _parseCommunicationChannel(dynamic channelValue) {
    if (channelValue == null) return null;

    try {
      return CommunicationChannel.values.firstWhere(
        (c) => c.value == channelValue,
        orElse: () => CommunicationChannel.other,
      );
    } catch (e) {
      print('Error parsing communication channel: $channelValue, error: $e');
      return CommunicationChannel.other;
    }
  }

  /// 소통 채널 값 파싱 (JSON 직렬화용)
  String? _parseCommunicationChannelValue(dynamic channelValue) {
    if (channelValue == null) return null;

    try {
      // 데이터베이스에서 다양한 형태로 반환되는 값을 JSON 값으로 변환
      if (channelValue is String) {
        switch (channelValue.toLowerCase()) {
          case 'instagram':
            return 'instagram';
          case 'whatsapp':
            return 'whatsapp';
          case 'line':
          case 'telegram':
            return 'line';
          case 'other':
          default:
            return 'other';
        }
      }

      return channelValue.toString();
    } catch (e) {
      print(
        'Error parsing communication channel value: $channelValue, error: $e',
      );
      return 'other';
    }
  }

  /// 성별을 데이터베이스 값으로 매핑
  String? _mapGenderToDatabase(CustomerGender? gender) {
    if (gender == null) return null;

    switch (gender) {
      case CustomerGender.male:
        return 'male';
      case CustomerGender.female:
        return 'female';
      case CustomerGender.other:
        return 'other';
    }
  }

  /// 소통 채널을 데이터베이스 값으로 매핑
  String? _mapCommunicationChannelToDatabase(CommunicationChannel? channel) {
    if (channel == null) return null;

    switch (channel) {
      case CommunicationChannel.instagram:
        return 'instagram';
      case CommunicationChannel.whatsapp:
        return 'whatsapp';
      case CommunicationChannel.line:
        return 'line';
      case CommunicationChannel.other:
        return 'other';
    }
  }

  /// 모델에서 데이터베이스로 매핑
  Map<String, dynamic> _mapToDatabase(CustomerInput input) {
    return {
      'name': input.name,
      'nationality': input.nationality,
      'gender': _mapGenderToDatabase(input.gender),
      'birth_date': input.birthDate?.toIso8601String(),
      'passport_name': input.passportName,
      'passport_last_name': input.passportLastName,
      'passport_first_name': input.passportFirstName,
      'is_booker': input.isBooker,
      'acquisition_channel': input.acquisitionChannel,
      'booker': input.booker,
      'customer_note': input.customerNote,
      'communication_channel': _mapCommunicationChannelToDatabase(
        input.communicationChannel,
      ),
      'channel_account': input.channelAccount,
    };
  }
}
