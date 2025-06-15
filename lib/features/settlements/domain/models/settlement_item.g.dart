// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettlementItem _$SettlementItemFromJson(Map<String, dynamic> json) =>
    SettlementItem(
      id: json['id'] as String,
      guideId: json['guideId'] as String,
      reservationId: json['reservationId'] as String,
      paymentAmount: (json['paymentAmount'] as num).toDouble(),
      commissionRate: (json['commissionRate'] as num).toDouble(),
      settlementAmount: (json['settlementAmount'] as num).toDouble(),
      status: $enumDecode(_$SettlementStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      approvedAt:
          json['approvedAt'] == null
              ? null
              : DateTime.parse(json['approvedAt'] as String),
      paidAt:
          json['paidAt'] == null
              ? null
              : DateTime.parse(json['paidAt'] as String),
      processedBy: json['processedBy'] as String?,
      guideName: json['guideName'] as String?,
      reservationNumber: json['reservationNumber'] as String?,
      reservationDate:
          json['reservationDate'] == null
              ? null
              : DateTime.parse(json['reservationDate'] as String),
      clinicName: json['clinicName'] as String?,
      customerName: json['customerName'] as String?,
    );

Map<String, dynamic> _$SettlementItemToJson(SettlementItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guideId': instance.guideId,
      'reservationId': instance.reservationId,
      'paymentAmount': instance.paymentAmount,
      'commissionRate': instance.commissionRate,
      'settlementAmount': instance.settlementAmount,
      'status': _$SettlementStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'processedBy': instance.processedBy,
      'guideName': instance.guideName,
      'reservationNumber': instance.reservationNumber,
      'reservationDate': instance.reservationDate?.toIso8601String(),
      'clinicName': instance.clinicName,
      'customerName': instance.customerName,
    };

const _$SettlementStatusEnumMap = {
  SettlementStatus.pending: 'pending',
  SettlementStatus.approved: 'approved',
  SettlementStatus.paid: 'paid',
};
