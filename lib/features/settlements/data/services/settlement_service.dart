import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/settlement_item.dart';

class SettlementService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get settlement items with filters
  Future<List<SettlementItem>> getSettlementItems({
    String? guideId,
    SettlementStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    dynamic queryBuilder = _supabase.from('settlement_items').select('''
          *,
          guides!inner(
            passport_first_name,
            passport_last_name,
            nickname
          ),
          reservations!inner(
            reservation_number,
            reservation_date,
            clinics!inner(clinic_name),
            customers!inner(name)
          )
        ''');

    if (guideId != null) {
      queryBuilder = queryBuilder.eq('guide_id', guideId);
    }

    if (status != null) {
      queryBuilder = queryBuilder.eq('status', status.name);
    }

    if (startDate != null) {
      queryBuilder = queryBuilder.gte(
        'created_at',
        startDate.toIso8601String(),
      );
    }

    if (endDate != null) {
      queryBuilder = queryBuilder.lte('created_at', endDate.toIso8601String());
    }

    queryBuilder = queryBuilder.order('created_at', ascending: false);

    if (limit != null) {
      queryBuilder = queryBuilder.limit(limit);
    }

    if (offset != null) {
      queryBuilder = queryBuilder.range(offset, offset + (limit ?? 50) - 1);
    }

    final response = await queryBuilder;

    return (response as List).map((item) {
      final guide = item['guides'];
      final reservation = item['reservations'];
      final clinic = reservation['clinics'];
      final customer = reservation['customers'];

      return SettlementItem.fromJson({
        ...item,
        'guideName':
            guide['nickname'] ??
            '${guide['passport_first_name']} ${guide['passport_last_name']}',
        'reservationNumber': reservation['reservation_number'],
        'reservationDate': reservation['reservation_date'],
        'clinicName': clinic['clinic_name'],
        'customerName': customer['name'],
      });
    }).toList();
  }

  // Get settlement summary statistics
  Future<Map<String, dynamic>> getSettlementSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    dynamic queryBuilder = _supabase
        .from('settlement_items')
        .select('status, settlement_amount');

    if (startDate != null) {
      queryBuilder = queryBuilder.gte(
        'created_at',
        startDate.toIso8601String(),
      );
    }

    if (endDate != null) {
      queryBuilder = queryBuilder.lte('created_at', endDate.toIso8601String());
    }

    final response = await queryBuilder;
    final items = response as List;

    double totalAmount = 0;
    double pendingAmount = 0;
    double approvedAmount = 0;
    double paidAmount = 0;
    int totalCount = items.length;

    for (final item in items) {
      final amount = (item['settlement_amount'] as num).toDouble();
      totalAmount += amount;

      switch (item['status']) {
        case 'pending':
          pendingAmount += amount;
          break;
        case 'approved':
          approvedAmount += amount;
          break;
        case 'paid':
          paidAmount += amount;
          break;
      }
    }

    return {
      'totalAmount': totalAmount,
      'pendingAmount': pendingAmount,
      'approvedAmount': approvedAmount,
      'paidAmount': paidAmount,
      'totalCount': totalCount,
      'averageAmount': totalCount > 0 ? totalAmount / totalCount : 0,
    };
  }

  // Update settlement status
  Future<void> updateSettlementStatus(
    String settlementId,
    SettlementStatus status, {
    String? notes,
  }) async {
    final updateData = <String, dynamic>{'status': status.name};

    if (notes != null) {
      updateData['notes'] = notes;
    }

    switch (status) {
      case SettlementStatus.approved:
        updateData['approved_at'] = DateTime.now().toIso8601String();
        break;
      case SettlementStatus.paid:
        updateData['paid_at'] = DateTime.now().toIso8601String();
        break;
      case SettlementStatus.pending:
        // Reset timestamps when reverting to pending
        updateData['approved_at'] = null;
        updateData['paid_at'] = null;
        break;
    }

    await _supabase
        .from('settlement_items')
        .update(updateData)
        .eq('id', settlementId);
  }

  // Bulk update settlement status
  Future<void> bulkUpdateSettlementStatus(
    List<String> settlementIds,
    SettlementStatus status, {
    String? notes,
  }) async {
    final updateData = <String, dynamic>{'status': status.name};

    if (notes != null) {
      updateData['notes'] = notes;
    }

    switch (status) {
      case SettlementStatus.approved:
        updateData['approved_at'] = DateTime.now().toIso8601String();
        break;
      case SettlementStatus.paid:
        updateData['paid_at'] = DateTime.now().toIso8601String();
        break;
      case SettlementStatus.pending:
        updateData['approved_at'] = null;
        updateData['paid_at'] = null;
        break;
    }

    // Use individual updates for bulk operation
    for (final id in settlementIds) {
      await _supabase.from('settlement_items').update(updateData).eq('id', id);
    }
  }

  // Get guides for filter dropdown
  Future<List<Map<String, dynamic>>> getGuidesForFilter() async {
    final response = await _supabase
        .from('guides')
        .select('id, passport_first_name, passport_last_name, nickname')
        .eq('is_active', true)
        .order('passport_first_name');

    return (response as List)
        .map(
          (guide) => {
            'id': guide['id'],
            'name':
                guide['nickname'] ??
                '${guide['passport_first_name']} ${guide['passport_last_name']}',
          },
        )
        .toList();
  }

  // Create settlement item manually (if needed)
  Future<void> createSettlementItem({
    required String guideId,
    required String reservationId,
    required double paymentAmount,
    required double commissionRate,
    String? notes,
  }) async {
    final settlementAmount = paymentAmount * (commissionRate / 100);

    await _supabase.from('settlement_items').insert({
      'guide_id': guideId,
      'reservation_id': reservationId,
      'payment_amount': paymentAmount,
      'commission_rate': commissionRate,
      'settlement_amount': settlementAmount,
      'status': 'pending',
      'notes': notes,
    });
  }
}
