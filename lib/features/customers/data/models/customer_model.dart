import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

/// 고객 성별
enum CustomerGender {
  @JsonValue('M')
  male('M', '남성'),
  @JsonValue('F')
  female('F', '여성'),
  @JsonValue('O')
  other('O', '기타');

  const CustomerGender(this.value, this.displayName);
  final String value;
  final String displayName;
}

/// 소통 채널 타입
enum CommunicationChannel {
  @JsonValue('instagram')
  instagram('instagram', '인스타그램'),
  @JsonValue('whatsapp')
  whatsapp('whatsapp', '왓츠앱'),
  @JsonValue('line')
  line('line', 'LINE'),
  @JsonValue('other')
  other('other', '기타');

  const CommunicationChannel(this.value, this.displayName);
  final String value;
  final String displayName;
}

/// 고객 필터 모델
@freezed
class CustomerFilters with _$CustomerFilters {
  const factory CustomerFilters({
    String? name,
    String? nationality,
    CustomerGender? gender,
    bool? isBooker,
    String? acquisitionChannel,
    CommunicationChannel? communicationChannel,
    DateTime? createdAfter,
    DateTime? createdBefore,
    String? searchQuery,
    double? minPaymentAmount,
    double? maxPaymentAmount,
  }) = _CustomerFilters;

  factory CustomerFilters.fromJson(Map<String, dynamic> json) =>
      _$CustomerFiltersFromJson(json);
}

/// 고객 모델
@freezed
class Customer with _$Customer {
  const factory Customer({
    String? id,
    required String name,
    String? nationality,
    CustomerGender? gender,
    DateTime? birthDate,
    double? age,
    String? passportName,
    String? passportLastName,
    String? passportFirstName,
    @Default(true) bool isBooker,
    String? acquisitionChannel,
    String? booker,
    String? customerNote,
    CommunicationChannel? communicationChannel,
    String? channelAccount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

/// 고객 입력 모델
@freezed
class CustomerInput with _$CustomerInput {
  const factory CustomerInput({
    required String name,
    String? nationality,
    CustomerGender? gender,
    DateTime? birthDate,
    double? age,
    String? passportName,
    String? passportLastName,
    String? passportFirstName,
    @Default(true) bool isBooker,
    String? acquisitionChannel,
    String? booker,
    String? customerNote,
    CommunicationChannel? communicationChannel,
    String? channelAccount,
    String? customerCode,
    String? phone,
    String? purchaseCode,
    String? reservationId,
  }) = _CustomerInput;

  factory CustomerInput.fromJson(Map<String, dynamic> json) =>
      _$CustomerInputFromJson(json);
}

/// 고객 통계 모델
@freezed
class CustomerStats with _$CustomerStats {
  const factory CustomerStats({
    @Default(0) int totalCustomers,
    @Default(0) int totalBookers,
    @Default(0) int totalCompanions,
    @Default(0) int maleCustomers,
    @Default(0) int femaleCustomers,
    @Default(0.0) double averageAge,
    @Default(0) int newCustomers,
    @Default(0) int returningCustomers,
    @Default(0.0) double totalRevenue,
  }) = _CustomerStats;

  factory CustomerStats.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatsFromJson(json);
}
