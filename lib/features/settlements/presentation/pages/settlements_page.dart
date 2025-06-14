import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SettlementsPage extends StatelessWidget {
  const SettlementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '정산 관리',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '가이드별 정산 내역을 관리하고 현황을 확인하세요.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Export settlements
              },
              icon: const Icon(Icons.download),
              label: const Text('정산 내보내기'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Period Selection and Search
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Show date picker
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('2024년 1월'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '가이드명 검색...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Settlement Summary Cards
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: '총 정산 금액',
                amount: '₩2,450,000',
                color: AppColors.primary,
                icon: Icons.account_balance_wallet,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: '완료된 정산',
                amount: '₩1,890,000',
                color: AppColors.success,
                icon: Icons.check_circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: '대기중 정산',
                amount: '₩560,000',
                color: AppColors.warning,
                icon: Icons.pending,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: '평균 정산액',
                amount: '₩102,000',
                color: AppColors.info,
                icon: Icons.trending_up,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Settlements Table
        Expanded(
          child: Card(
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: Text('가이드')),
                      const Expanded(flex: 1, child: Text('예약 건수')),
                      const Expanded(flex: 2, child: Text('총 매출')),
                      const Expanded(flex: 2, child: Text('정산 금액')),
                      const Expanded(flex: 1, child: Text('상태')),
                      const SizedBox(width: 100, child: Text('작업')),
                    ],
                  ),
                ),
                
                // Table Content
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Placeholder count
                    itemBuilder: (context, index) {
                      return _SettlementRow(
                        guideName: '가이드 ${index + 1}',
                        reservationCount: 8 + index,
                        totalRevenue: (180000 + index * 15000),
                        settlementAmount: (144000 + index * 12000),
                        status: index % 3 == 0 ? '완료' : (index % 3 == 1 ? '대기' : '진행중'),
                        onViewDetails: () {
                          // TODO: Show settlement details
                        },
                        onProcess: () {
                          // TODO: Process settlement
                        },
                      );
                    },
                  ),
                ),
                
                // Pagination (Placeholder)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.grey200, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('이전'),
                      ),
                      const SizedBox(width: 16),
                      const Text('1 / 3'),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {},
                        child: const Text('다음'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const Spacer(),
              ],
            ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettlementRow extends StatelessWidget {
  final String guideName;
  final int reservationCount;
  final int totalRevenue;
  final int settlementAmount;
  final String status;
  final VoidCallback onViewDetails;
  final VoidCallback onProcess;

  const _SettlementRow({
    required this.guideName,
    required this.reservationCount,
    required this.totalRevenue,
    required this.settlementAmount,
    required this.status,
    required this.onViewDetails,
    required this.onProcess,
  });

  Color get statusColor {
    switch (status) {
      case '완료':
        return AppColors.success;
      case '대기':
        return AppColors.warning;
      case '진행중':
        return AppColors.info;
      default:
        return AppColors.grey400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Guide Name
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guideName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Reservation Count
          Expanded(
            flex: 1,
            child: Text('${reservationCount}건'),
          ),
          
          // Total Revenue
          Expanded(
            flex: 2,
            child: Text('₩${totalRevenue.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )}'),
          ),
          
          // Settlement Amount
          Expanded(
            flex: 2,
            child: Text(
              '₩${settlementAmount.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              )}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Status
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Actions
          SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.visibility_outlined),
                  tooltip: '상세보기',
                ),
                IconButton(
                  onPressed: status != '완료' ? onProcess : null,
                  icon: const Icon(Icons.payment_outlined),
                  tooltip: '정산처리',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 