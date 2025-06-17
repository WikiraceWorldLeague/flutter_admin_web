// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerImpl(
  id: json['id'] as String?,
  reservationId: json['reservation_id'] as String?,
  name: json['name'] as String,
  nationality: json['nationality'] as String?,
  gender: $enumDecodeNullable(_$CustomerGenderEnumMap, json['gender']),
  age: (json['age'] as num?)?.toDouble(),
  customerNote: json['customer_note'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  birthDate:
      json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
  isBooker: json['is_booker'] as bool? ?? false,
  booker: json['booker'] as String?,
  customerCode: json['customer_code'] as String?,
  passportName: json['passport_name'] as String?,
  phone: json['phone'] as String?,
  acquisitionChannel: json['acquisition_channel'] as String?,
  communicationChannel: json['communication_channel'] as String?,
  channelAccount: json['channel_account'] as String?,
  purchaseCode: json['purchase_code'] as String?,
  totalPaymentAmount: (json['total_payment_amount'] as num?)?.toDouble() ?? 0.0,
  companyRevenueWithTax:
      (json['company_revenue_with_tax'] as num?)?.toDouble() ?? 0.0,
  companyRevenueWithoutTax:
      (json['company_revenue_without_tax'] as num?)?.toDouble() ?? 0.0,
  guideCommission: (json['guide_commission'] as num?)?.toDouble() ?? 0.0,
  netRevenueWithTax: (json['net_revenue_with_tax'] as num?)?.toDouble() ?? 0.0,
  netRevenueWithoutTax:
      (json['net_revenue_without_tax'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reservation_id': instance.reservationId,
      'name': instance.name,
      'nationality': instance.nationality,
      'gender': _$CustomerGenderEnumMap[instance.gender],
      'age': instance.age,
      'customer_note': instance.customerNote,
      'created_at': instance.createdAt.toIso8601String(),
      'birth_date': instance.birthDate?.toIso8601String(),
      'is_booker': instance.isBooker,
      'booker': instance.booker,
      'customer_code': instance.customerCode,
      'passport_name': instance.passportName,
      'phone': instance.phone,
      'acquisition_channel': instance.acquisitionChannel,
      'communication_channel': instance.communicationChannel,
      'channel_account': instance.channelAccount,
      'purchase_code': instance.purchaseCode,
      'total_payment_amount': instance.totalPaymentAmount,
      'company_revenue_with_tax': instance.companyRevenueWithTax,
      'company_revenue_without_tax': instance.companyRevenueWithoutTax,
      'guide_commission': instance.guideCommission,
      'net_revenue_with_tax': instance.netRevenueWithTax,
      'net_revenue_without_tax': instance.netRevenueWithoutTax,
    };

const _$CustomerGenderEnumMap = {
  CustomerGender.male: 'male',
  CustomerGender.female: 'female',
  CustomerGender.other: 'other',
};

_$CustomerFiltersImpl _$$CustomerFiltersImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerFiltersImpl(
  searchQuery: json['search_query'] as String?,
  gender: $enumDecodeNullable(_$CustomerGenderEnumMap, json['gender']),
  nationality: json['nationality'] as String?,
  acquisitionChannel: json['acquisition_channel'] as String?,
  communicationChannel: json['communication_channel'] as String?,
  isBooker: json['is_booker'] as bool?,
  createdAfter:
      json['created_after'] == null
          ? null
          : DateTime.parse(json['created_after'] as String),
  createdBefore:
      json['created_before'] == null
          ? null
          : DateTime.parse(json['created_before'] as String),
  minPaymentAmount: (json['min_payment_amount'] as num?)?.toDouble(),
  maxPaymentAmount: (json['max_payment_amount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$CustomerFiltersImplToJson(
  _$CustomerFiltersImpl instance,
) => <String, dynamic>{
  'search_query': instance.searchQuery,
  'gender': _$CustomerGenderEnumMap[instance.gender],
  'nationality': instance.nationality,
  'acquisition_channel': instance.acquisitionChannel,
  'communication_channel': instance.communicationChannel,
  'is_booker': instance.isBooker,
  'created_after': instance.createdAfter?.toIso8601String(),
  'created_before': instance.createdBefore?.toIso8601String(),
  'min_payment_amount': instance.minPaymentAmount,
  'max_payment_amount': instance.maxPaymentAmount,
};

_$CustomerInputImpl _$$CustomerInputImplFromJson(Map<String, dynamic> json) =>
    _$CustomerInputImpl(
      reservationId: json['reservation_id'] as String?,
      name: json['name'] as String,
      nationality: json['nationality'] as String?,
      gender: $enumDecodeNullable(_$CustomerGenderEnumMap, json['gender']),
      age: (json['age'] as num?)?.toDouble(),
      customerNote: json['customer_note'] as String?,
      birthDate:
          json['birth_date'] == null
              ? null
              : DateTime.parse(json['birth_date'] as String),
      isBooker: json['is_booker'] as bool? ?? false,
      booker: json['booker'] as String?,
      customerCode: json['customer_code'] as String?,
      passportName: json['passport_name'] as String?,
      phone: json['phone'] as String?,
      acquisitionChannel: json['acquisition_channel'] as String?,
      communicationChannel: json['communication_channel'] as String?,
      channelAccount: json['channel_account'] as String?,
      purchaseCode: json['purchase_code'] as String?,
    );

Map<String, dynamic> _$$CustomerInputImplToJson(_$CustomerInputImpl instance) =>
    <String, dynamic>{
      'reservation_id': instance.reservationId,
      'name': instance.name,
      'nationality': instance.nationality,
      'gender': _$CustomerGenderEnumMap[instance.gender],
      'age': instance.age,
      'customer_note': instance.customerNote,
      'birth_date': instance.birthDate?.toIso8601String(),
      'is_booker': instance.isBooker,
      'booker': instance.booker,
      'customer_code': instance.customerCode,
      'passport_name': instance.passportName,
      'phone': instance.phone,
      'acquisition_channel': instance.acquisitionChannel,
      'communication_channel': instance.communicationChannel,
      'channel_account': instance.channelAccount,
      'purchase_code': instance.purchaseCode,
    };

_$CustomerStatsImpl _$$CustomerStatsImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerStatsImpl(
  totalCustomers: (json['total_customers'] as num).toInt(),
  newCustomers: (json['new_customers'] as num).toInt(),
  returningCustomers: (json['returning_customers'] as num).toInt(),
  totalRevenue: (json['total_revenue'] as num).toDouble(),
  averageRevenuePerCustomer:
      (json['average_revenue_per_customer'] as num).toDouble(),
  customersByNationality: Map<String, int>.from(
    json['customers_by_nationality'] as Map,
  ),
  customersByChannel: Map<String, int>.from(
    json['customers_by_channel'] as Map,
  ),
  customersByGender: (json['customers_by_gender'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry($enumDecode(_$CustomerGenderEnumMap, k), (e as num).toInt()),
  ),
);

Map<String, dynamic> _$$CustomerStatsImplToJson(_$CustomerStatsImpl instance) =>
    <String, dynamic>{
      'total_customers': instance.totalCustomers,
      'new_customers': instance.newCustomers,
      'returning_customers': instance.returningCustomers,
      'total_revenue': instance.totalRevenue,
      'average_revenue_per_customer': instance.averageRevenuePerCustomer,
      'customers_by_nationality': instance.customersByNationality,
      'customers_by_channel': instance.customersByChannel,
      'customers_by_gender': instance.customersByGender.map(
        (k, e) => MapEntry(_$CustomerGenderEnumMap[k]!, e),
      ),
    };
