import 'package:json_annotation/json_annotation.dart';

part 'settlement_item.g.dart';

@JsonSerializable()
class SettlementItem {
  final String id;
  final String guideId;
  final String reservationId;
  final double paymentAmount;
  final double commissionRate;
  final double settlementAmount;
  final SettlementStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? paidAt;
  final String? processedBy;
  // Related data
  final String? guideName;
  final String? reservationNumber;
  final DateTime? reservationDate;
  final String? clinicName;
  final String? customerName;

  const SettlementItem({
    required this.id,
    required this.guideId,
    required this.reservationId,
    required this.paymentAmount,
    required this.commissionRate,
    required this.settlementAmount,
    required this.status,
    this.notes,
    required this.createdAt,
    this.approvedAt,
    this.paidAt,
    this.processedBy,
    this.guideName,
    this.reservationNumber,
    this.reservationDate,
    this.clinicName,
    this.customerName,
  });

  factory SettlementItem.fromJson(Map<String, dynamic> json) =>
      _$SettlementItemFromJson(json);

  Map<String, dynamic> toJson() => _$SettlementItemToJson(this);

  SettlementItem copyWith({
    String? id,
    String? guideId,
    String? reservationId,
    double? paymentAmount,
    double? commissionRate,
    double? settlementAmount,
    SettlementStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? approvedAt,
    DateTime? paidAt,
    String? processedBy,
    String? guideName,
    String? reservationNumber,
    DateTime? reservationDate,
    String? clinicName,
    String? customerName,
  }) {
    return SettlementItem(
      id: id ?? this.id,
      guideId: guideId ?? this.guideId,
      reservationId: reservationId ?? this.reservationId,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      commissionRate: commissionRate ?? this.commissionRate,
      settlementAmount: settlementAmount ?? this.settlementAmount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      paidAt: paidAt ?? this.paidAt,
      processedBy: processedBy ?? this.processedBy,
      guideName: guideName ?? this.guideName,
      reservationNumber: reservationNumber ?? this.reservationNumber,
      reservationDate: reservationDate ?? this.reservationDate,
      clinicName: clinicName ?? this.clinicName,
      customerName: customerName ?? this.customerName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettlementItem &&
        other.id == id &&
        other.guideId == guideId &&
        other.reservationId == reservationId &&
        other.paymentAmount == paymentAmount &&
        other.commissionRate == commissionRate &&
        other.settlementAmount == settlementAmount &&
        other.status == status &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.approvedAt == approvedAt &&
        other.paidAt == paidAt &&
        other.processedBy == processedBy &&
        other.guideName == guideName &&
        other.reservationNumber == reservationNumber &&
        other.reservationDate == reservationDate &&
        other.clinicName == clinicName &&
        other.customerName == customerName;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      guideId,
      reservationId,
      paymentAmount,
      commissionRate,
      settlementAmount,
      status,
      notes,
      createdAt,
      approvedAt,
      paidAt,
      processedBy,
      guideName,
      reservationNumber,
      reservationDate,
      clinicName,
      customerName,
    );
  }

  @override
  String toString() {
    return 'SettlementItem(id: $id, guideId: $guideId, reservationId: $reservationId, paymentAmount: $paymentAmount, commissionRate: $commissionRate, settlementAmount: $settlementAmount, status: $status, notes: $notes, createdAt: $createdAt, approvedAt: $approvedAt, paidAt: $paidAt, processedBy: $processedBy, guideName: $guideName, reservationNumber: $reservationNumber, reservationDate: $reservationDate, clinicName: $clinicName, customerName: $customerName)';
  }
}

enum SettlementStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('paid')
  paid,
}

extension SettlementStatusExtension on SettlementStatus {
  String get displayName {
    switch (this) {
      case SettlementStatus.pending:
        return '대기중';
      case SettlementStatus.approved:
        return '승인됨';
      case SettlementStatus.paid:
        return '지급완료';
    }
  }

  String get colorName {
    switch (this) {
      case SettlementStatus.pending:
        return 'warning';
      case SettlementStatus.approved:
        return 'info';
      case SettlementStatus.paid:
        return 'success';
    }
  }
}
