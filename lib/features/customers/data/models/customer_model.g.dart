// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerFiltersImpl _$$CustomerFiltersImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerFiltersImpl(
  name: json['name'] as String?,
  nationality: json['nationality'] as String?,
  gender: $enumDecodeNullable(_$CustomerGenderEnumMap, json['gender']),
  isBooker: json['isBooker'] as bool?,
  acquisitionChannel: json['acquisitionChannel'] as String?,
  communicationChannel: $enumDecodeNullable(
    _$CommunicationChannelEnumMap,
    json['communicationChannel'],
  ),
  createdAfter:
      json['createdAfter'] == null
          ? null
          : DateTime.parse(json['createdAfter'] as String),
  createdBefore:
      json['createdBefore'] == null
          ? null
          : DateTime.parse(json['createdBefore'] as String),
  searchQuery: json['searchQuery'] as String?,
  minPaymentAmount: (json['minPaymentAmount'] as num?)?.toDouble(),
  maxPaymentAmount: (json['maxPaymentAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$CustomerFiltersImplToJson(
  _$CustomerFiltersImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'nationality': instance.nationality,
  'gender': _$CustomerGenderEnumMap[instance.gender],
  'isBooker': instance.isBooker,
  'acquisitionChannel': instance.acquisitionChannel,
  'communicationChannel':
      _$CommunicationChannelEnumMap[instance.communicationChannel],
  'createdAfter': instance.createdAfter?.toIso8601String(),
  'createdBefore': instance.createdBefore?.toIso8601String(),
  'searchQuery': instance.searchQuery,
  'minPaymentAmount': instance.minPaymentAmount,
  'maxPaymentAmount': instance.maxPaymentAmount,
};

const _$CustomerGenderEnumMap = {
  CustomerGender.male: 'M',
  CustomerGender.female: 'F',
  CustomerGender.other: 'O',
};

const _$CommunicationChannelEnumMap = {
  CommunicationChannel.instagram: 'instagram',
  CommunicationChannel.whatsapp: 'whatsapp',
  CommunicationChannel.line: 'line',
  CommunicationChannel.other: 'other',
};

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      nationality: json['nationality'] as String?,
      gender: $enumDecodeNullable(_$CustomerGenderEnumMap, json['gender']),
      birthDate:
          json['birthDate'] == null
              ? null
              : DateTime.parse(json['birthDate'] as String),
      age: (json['age'] as num?)?.toDouble(),
      passportName: json['passportName'] as String?,
      passportLastName: json['passportLastName'] as String?,
      passportFirstName: json['passportFirstName'] as String?,
      isBooker: json['isBooker'] as bool? ?? true,
      acquisitionChannel: json['acquisitionChannel'] as String?,
      booker: json['booker'] as String?,
      customerNote: json['customerNote'] as String?,
      communicationChannel: $enumDecodeNullable(
        _$CommunicationChannelEnumMap,
        json['communicationChannel'],
      ),
      channelAccount: json['channelAccount'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nationality': instance.nationality,
      'gender': _$CustomerGenderEnumMap[instance.gender],
      'birthDate': instance.birthDate?.toIso8601String(),
      'age': instance.age,
      'passportName': instance.passportName,
      'passportLastName': instance.passportLastName,
      'passportFirstName': instance.passportFirstName,
      'isBooker': instance.isBooker,
      'acquisitionChannel': instance.acquisitionChannel,
      'booker': instance.booker,
      'customerNote': instance.customerNote,
      'communicationChannel':
          _$CommunicationChannelEnumMap[instance.communicationChannel],
      'channelAccount': instance.channelAccount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CustomerInputImpl _$$CustomerInputImplFromJson(Map<String, dynamic> json) =>
    _$CustomerInputImpl(
      name: json['name'] as String,
      nationality: json['nationality'] as String?,
      gender: $enumDecodeNullable(_$CustomerGenderEnumMap, json['gender']),
      birthDate:
          json['birthDate'] == null
              ? null
              : DateTime.parse(json['birthDate'] as String),
      age: (json['age'] as num?)?.toDouble(),
      passportName: json['passportName'] as String?,
      passportLastName: json['passportLastName'] as String?,
      passportFirstName: json['passportFirstName'] as String?,
      isBooker: json['isBooker'] as bool? ?? true,
      acquisitionChannel: json['acquisitionChannel'] as String?,
      booker: json['booker'] as String?,
      customerNote: json['customerNote'] as String?,
      communicationChannel: $enumDecodeNullable(
        _$CommunicationChannelEnumMap,
        json['communicationChannel'],
      ),
      channelAccount: json['channelAccount'] as String?,
      customerCode: json['customerCode'] as String?,
      phone: json['phone'] as String?,
      purchaseCode: json['purchaseCode'] as String?,
      reservationId: json['reservationId'] as String?,
    );

Map<String, dynamic> _$$CustomerInputImplToJson(_$CustomerInputImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nationality': instance.nationality,
      'gender': _$CustomerGenderEnumMap[instance.gender],
      'birthDate': instance.birthDate?.toIso8601String(),
      'age': instance.age,
      'passportName': instance.passportName,
      'passportLastName': instance.passportLastName,
      'passportFirstName': instance.passportFirstName,
      'isBooker': instance.isBooker,
      'acquisitionChannel': instance.acquisitionChannel,
      'booker': instance.booker,
      'customerNote': instance.customerNote,
      'communicationChannel':
          _$CommunicationChannelEnumMap[instance.communicationChannel],
      'channelAccount': instance.channelAccount,
      'customerCode': instance.customerCode,
      'phone': instance.phone,
      'purchaseCode': instance.purchaseCode,
      'reservationId': instance.reservationId,
    };

_$CustomerStatsImpl _$$CustomerStatsImplFromJson(Map<String, dynamic> json) =>
    _$CustomerStatsImpl(
      totalCustomers: (json['totalCustomers'] as num?)?.toInt() ?? 0,
      totalBookers: (json['totalBookers'] as num?)?.toInt() ?? 0,
      totalCompanions: (json['totalCompanions'] as num?)?.toInt() ?? 0,
      maleCustomers: (json['maleCustomers'] as num?)?.toInt() ?? 0,
      femaleCustomers: (json['femaleCustomers'] as num?)?.toInt() ?? 0,
      averageAge: (json['averageAge'] as num?)?.toDouble() ?? 0.0,
      newCustomers: (json['newCustomers'] as num?)?.toInt() ?? 0,
      returningCustomers: (json['returningCustomers'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$CustomerStatsImplToJson(_$CustomerStatsImpl instance) =>
    <String, dynamic>{
      'totalCustomers': instance.totalCustomers,
      'totalBookers': instance.totalBookers,
      'totalCompanions': instance.totalCompanions,
      'maleCustomers': instance.maleCustomers,
      'femaleCustomers': instance.femaleCustomers,
      'averageAge': instance.averageAge,
      'newCustomers': instance.newCustomers,
      'returningCustomers': instance.returningCustomers,
      'totalRevenue': instance.totalRevenue,
    };
