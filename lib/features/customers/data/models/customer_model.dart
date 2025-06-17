import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

/// 고객 성별 enum
@JsonEnum(fieldRename: FieldRename.snake)
enum CustomerGender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other,
}

/// 고객 정보 모델
@freezed
class Customer with _$Customer {
  const factory Customer({
    String? id,
    @JsonKey(name: 'reservation_id') String? reservationId,
    required String name,
    String? nationality,
    CustomerGender? gender,
    double? age,
    @JsonKey(name: 'customer_note') String? customerNote,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'is_booker') @Default(false) bool isBooker,
    String? booker,
    @JsonKey(name: 'customer_code') String? customerCode,
    @JsonKey(name: 'passport_name') String? passportName,
    String? phone,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'channel_account') String? channelAccount,
    @JsonKey(name: 'purchase_code') String? purchaseCode,
    @JsonKey(name: 'total_payment_amount')
    @Default(0.0)
    double totalPaymentAmount,
    @JsonKey(name: 'company_revenue_with_tax')
    @Default(0.0)
    double companyRevenueWithTax,
    @JsonKey(name: 'company_revenue_without_tax')
    @Default(0.0)
    double companyRevenueWithoutTax,
    @JsonKey(name: 'guide_commission') @Default(0.0) double guideCommission,
    @JsonKey(name: 'net_revenue_with_tax')
    @Default(0.0)
    double netRevenueWithTax,
    @JsonKey(name: 'net_revenue_without_tax')
    @Default(0.0)
    double netRevenueWithoutTax,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

/// 고객 필터링을 위한 모델
@freezed
class CustomerFilters with _$CustomerFilters {
  const factory CustomerFilters({
    @JsonKey(name: 'search_query') String? searchQuery,
    CustomerGender? gender,
    String? nationality,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'is_booker') bool? isBooker,
    @JsonKey(name: 'created_after') DateTime? createdAfter,
    @JsonKey(name: 'created_before') DateTime? createdBefore,
    @JsonKey(name: 'min_payment_amount') double? minPaymentAmount,
    @JsonKey(name: 'max_payment_amount') double? maxPaymentAmount,
  }) = _CustomerFilters;

  factory CustomerFilters.fromJson(Map<String, dynamic> json) =>
      _$CustomerFiltersFromJson(json);
}

/// 고객 생성/수정을 위한 입력 모델
@freezed
class CustomerInput with _$CustomerInput {
  const factory CustomerInput({
    @JsonKey(name: 'reservation_id') String? reservationId,
    required String name,
    String? nationality,
    CustomerGender? gender,
    double? age,
    @JsonKey(name: 'customer_note') String? customerNote,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'is_booker') @Default(false) bool isBooker,
    String? booker,
    @JsonKey(name: 'customer_code') String? customerCode,
    @JsonKey(name: 'passport_name') String? passportName,
    String? phone,
    @JsonKey(name: 'acquisition_channel') String? acquisitionChannel,
    @JsonKey(name: 'communication_channel') String? communicationChannel,
    @JsonKey(name: 'channel_account') String? channelAccount,
    @JsonKey(name: 'purchase_code') String? purchaseCode,
  }) = _CustomerInput;

  factory CustomerInput.fromJson(Map<String, dynamic> json) =>
      _$CustomerInputFromJson(json);
}

/// 고객 통계 정보 모델
@freezed
class CustomerStats with _$CustomerStats {
  const factory CustomerStats({
    @JsonKey(name: 'total_customers') required int totalCustomers,
    @JsonKey(name: 'new_customers') required int newCustomers,
    @JsonKey(name: 'returning_customers') required int returningCustomers,
    @JsonKey(name: 'total_revenue') required double totalRevenue,
    @JsonKey(name: 'average_revenue_per_customer')
    required double averageRevenuePerCustomer,
    @JsonKey(name: 'customers_by_nationality')
    required Map<String, int> customersByNationality,
    @JsonKey(name: 'customers_by_channel')
    required Map<String, int> customersByChannel,
    @JsonKey(name: 'customers_by_gender')
    required Map<CustomerGender, int> customersByGender,
  }) = _CustomerStats;

  factory CustomerStats.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatsFromJson(json);
}
