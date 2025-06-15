import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/settlement_item.dart';

class SettlementDetailDialog extends StatelessWidget {
  final SettlementItem item;

  const SettlementDetailDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormat = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );

    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  '정산 상세 정보',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Status Badge
            Row(
              children: [
                _StatusBadge(status: item.status),
                const Spacer(),
                Text(
                  '생성일: ${dateFormat.format(item.createdAt)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Guide Information
                    _SectionCard(
                      title: '가이드 정보',
                      icon: Icons.person,
                      children: [
                        _InfoRow('가이드명', item.guideName ?? 'Unknown'),
                        _InfoRow('가이드 ID', item.guideId),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Reservation Information
                    _SectionCard(
                      title: '예약 정보',
                      icon: Icons.event,
                      children: [
                        _InfoRow('예약번호', item.reservationNumber ?? 'N/A'),
                        _InfoRow('고객명', item.customerName ?? 'N/A'),
                        _InfoRow('클리닉', item.clinicName ?? 'N/A'),
                        if (item.reservationDate != null)
                          _InfoRow(
                            '예약일',
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(item.reservationDate!),
                          ),
                        _InfoRow('예약 ID', item.reservationId),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Settlement Information
                    _SectionCard(
                      title: '정산 정보',
                      icon: Icons.calculate,
                      children: [
                        _InfoRow(
                          '결제 금액',
                          currencyFormat.format(item.paymentAmount),
                        ),
                        _InfoRow(
                          '수수료율',
                          '${item.commissionRate.toStringAsFixed(1)}%',
                        ),
                        _InfoRow(
                          '정산 금액',
                          currencyFormat.format(item.settlementAmount),
                          isHighlighted: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Status History
                    _SectionCard(
                      title: '상태 이력',
                      icon: Icons.history,
                      children: [
                        _StatusHistoryItem(
                          status: '생성됨',
                          date: item.createdAt,
                          isCompleted: true,
                        ),
                        if (item.approvedAt != null)
                          _StatusHistoryItem(
                            status: '승인됨',
                            date: item.approvedAt!,
                            isCompleted: true,
                          ),
                        if (item.paidAt != null)
                          _StatusHistoryItem(
                            status: '지급완료',
                            date: item.paidAt!,
                            isCompleted: true,
                          ),
                      ],
                    ),

                    // Notes (if any)
                    if (item.notes != null && item.notes!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: '메모',
                        icon: Icons.note,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.grey50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.notes!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('닫기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final SettlementStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status) {
      case SettlementStatus.pending:
        color = AppColors.warning;
        icon = Icons.pending;
        break;
      case SettlementStatus.approved:
        color = AppColors.info;
        icon = Icons.verified;
        break;
      case SettlementStatus.paid:
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _InfoRow(this.label, this.value, {this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlighted ? FontWeight.w600 : null,
                color: isHighlighted ? AppColors.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusHistoryItem extends StatelessWidget {
  final String status;
  final DateTime date;
  final bool isCompleted;

  const _StatusHistoryItem({
    required this.status,
    required this.date,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : AppColors.grey300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              status,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            dateFormat.format(date),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}
