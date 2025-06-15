import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/settlement_provider.dart';

class SettlementSummaryCards extends ConsumerWidget {
  const SettlementSummaryCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(settlementSummaryProvider);

    return summaryAsync.when(
      data:
          (summary) => Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: '총 정산 금액',
                  amount: _formatCurrency(summary['totalAmount']),
                  color: AppColors.primary,
                  icon: Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: '지급완료',
                  amount: _formatCurrency(summary['paidAmount']),
                  color: AppColors.success,
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: '승인됨',
                  amount: _formatCurrency(summary['approvedAmount']),
                  color: AppColors.info,
                  icon: Icons.verified,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: '대기중',
                  amount: _formatCurrency(summary['pendingAmount']),
                  color: AppColors.warning,
                  icon: Icons.pending,
                ),
              ),
            ],
          ),
      loading:
          () => Row(
            children: [
              Expanded(child: _LoadingSummaryCard()),
              const SizedBox(width: 16),
              Expanded(child: _LoadingSummaryCard()),
              const SizedBox(width: 16),
              Expanded(child: _LoadingSummaryCard()),
              const SizedBox(width: 16),
              Expanded(child: _LoadingSummaryCard()),
            ],
          ),
      error:
          (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.error, color: AppColors.error),
                  const SizedBox(width: 8),
                  Text(
                    '요약 데이터를 불러올 수 없습니다.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => ref.invalidate(settlementSummaryProvider),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '₩0';
    final formatter = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, color: color, size: 24), const Spacer()]),
            const SizedBox(height: 8),
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingSummaryCard extends StatelessWidget {
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
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
