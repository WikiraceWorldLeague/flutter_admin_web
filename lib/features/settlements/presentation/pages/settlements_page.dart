import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/settlement_item.dart';
import '../providers/settlement_provider.dart';
import '../widgets/create_settlement_dialog.dart';

class SettlementsPage extends ConsumerStatefulWidget {
  const SettlementsPage({super.key});

  @override
  ConsumerState<SettlementsPage> createState() => _SettlementsPageState();
}

class _SettlementsPageState extends ConsumerState<SettlementsPage> {
  Set<String> selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Text(
                '정산 관리',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showCreateSettlementDialog(),
                icon: const Icon(Icons.add),
                label: const Text('정산 생성'),
              ),
            ],
          ),
        ),

        // Summary Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: '총 정산 금액',
                  amount: '₩12,500,000',
                  color: AppColors.primary,
                  icon: Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: '승인 대기',
                  amount: '₩3,200,000',
                  color: AppColors.warning,
                  icon: Icons.pending_actions,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: '지급 완료',
                  amount: '₩9,300,000',
                  color: AppColors.success,
                  icon: Icons.check_circle,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<SettlementStatus?>(
                      decoration: const InputDecoration(
                        labelText: '상태',
                        border: OutlineInputBorder(),
                      ),
                      value: null,
                      items: [
                        const DropdownMenuItem(value: null, child: Text('전체')),
                        ...SettlementStatus.values.map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(_getStatusText(status)),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        // TODO: 필터 적용
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: '가이드 검색',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        // TODO: 검색 적용
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Settlement Table
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.grey200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {
                            // TODO: 전체 선택
                          },
                        ),
                        const SizedBox(width: 8),
                        const Expanded(flex: 2, child: Text('예약번호')),
                        const Expanded(flex: 2, child: Text('가이드')),
                        const Expanded(flex: 2, child: Text('고객')),
                        const Expanded(flex: 2, child: Text('결제금액')),
                        const Expanded(flex: 2, child: Text('정산금액')),
                        const Expanded(flex: 2, child: Text('상태')),
                        const Expanded(flex: 1, child: Text('작업')),
                      ],
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final settlementItemsAsync = ref.watch(
                          settlementItemsProvider,
                        );

                        return settlementItemsAsync.when(
                          data: (items) {
                            if (items.isEmpty) {
                              return const Center(child: Text('정산 데이터가 없습니다.'));
                            }

                            return ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return _SettlementItemRow(
                                  item: item,
                                  isSelected: selectedItems.contains(item.id),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedItems.add(item.id);
                                      } else {
                                        selectedItems.remove(item.id);
                                      }
                                    });
                                  },
                                  onStatusUpdate: (status) {
                                    _updateSettlementStatus(item.id, status);
                                  },
                                );
                              },
                            );
                          },
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          error:
                              (error, stack) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      size: 48,
                                      color: AppColors.error,
                                    ),
                                    const SizedBox(height: 16),
                                    Text('데이터 로딩 실패: $error'),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed:
                                          () => ref.refresh(
                                            settlementItemsProvider,
                                          ),
                                      child: const Text('다시 시도'),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _showCreateSettlementDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateSettlementDialog(),
    );

    if (result == true) {
      // TODO: 목록 새로고침
      setState(() {});
    }
  }

  void _updateSettlementStatus(String id, SettlementStatus status) {
    // TODO: 상태 업데이트 API 호출
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('정산 상태가 ${_getStatusText(status)}(으)로 변경되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _getStatusText(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.pending:
        return '승인 대기';
      case SettlementStatus.approved:
        return '승인됨';
      case SettlementStatus.paid:
        return '지급 완료';
    }
  }

  List<Map<String, dynamic>> _getDummySettlements() {
    return [
      {
        'id': '1',
        'reservation_number': 'RES-2024-001',
        'guide_name': '김가이드',
        'customer_name': '홍길동',
        'payment_amount': 1000000.0,
        'settlement_amount': 100000.0,
        'status': SettlementStatus.pending,
      },
      {
        'id': '2',
        'reservation_number': 'RES-2024-002',
        'guide_name': '이가이드',
        'customer_name': '김철수',
        'payment_amount': 800000.0,
        'settlement_amount': 96000.0,
        'status': SettlementStatus.approved,
      },
      {
        'id': '3',
        'reservation_number': 'RES-2024-003',
        'guide_name': '박가이드',
        'customer_name': '이영희',
        'payment_amount': 1200000.0,
        'settlement_amount': 144000.0,
        'status': SettlementStatus.paid,
      },
    ];
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.grey600),
                ),
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
          ],
        ),
      ),
    );
  }
}

class _SettlementItemRow extends StatelessWidget {
  final SettlementItem item;
  final bool isSelected;
  final Function(bool) onSelected;
  final Function(SettlementStatus) onStatusUpdate;

  const _SettlementItemRow({
    required this.item,
    required this.isSelected,
    required this.onSelected,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey200.withOpacity(0.5)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) => onSelected(value ?? false),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Text(
                item.reservationNumber ?? 'N/A',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(flex: 2, child: Text(item.guideName ?? 'N/A')),
            Expanded(flex: 2, child: Text(item.customerName ?? 'N/A')),
            Expanded(
              flex: 2,
              child: Text(currencyFormat.format(item.paymentAmount)),
            ),
            Expanded(
              flex: 2,
              child: Text(
                currencyFormat.format(item.settlementAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(flex: 2, child: _StatusBadge(status: item.status)),
            Expanded(
              flex: 1,
              child: PopupMenuButton<SettlementStatus>(
                icon: const Icon(Icons.more_vert),
                onSelected: onStatusUpdate,
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: SettlementStatus.pending,
                        child: Text('승인 대기'),
                      ),
                      const PopupMenuItem(
                        value: SettlementStatus.approved,
                        child: Text('승인'),
                      ),
                      const PopupMenuItem(
                        value: SettlementStatus.paid,
                        child: Text('지급 완료'),
                      ),
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettlementRow extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final Function(bool) onSelected;
  final Function(SettlementStatus) onStatusUpdate;

  const _SettlementRow({
    required this.item,
    required this.isSelected,
    required this.onSelected,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey200.withOpacity(0.5)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) => onSelected(value ?? false),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Text(
                item['reservation_number'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(flex: 2, child: Text(item['guide_name'])),
            Expanded(flex: 2, child: Text(item['customer_name'])),
            Expanded(
              flex: 2,
              child: Text(currencyFormat.format(item['payment_amount'])),
            ),
            Expanded(
              flex: 2,
              child: Text(
                currencyFormat.format(item['settlement_amount']),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(flex: 2, child: _StatusBadge(status: item['status'])),
            Expanded(
              flex: 1,
              child: PopupMenuButton<SettlementStatus>(
                icon: const Icon(Icons.more_vert),
                onSelected: onStatusUpdate,
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: SettlementStatus.pending,
                        child: Text('승인 대기'),
                      ),
                      const PopupMenuItem(
                        value: SettlementStatus.approved,
                        child: Text('승인'),
                      ),
                      const PopupMenuItem(
                        value: SettlementStatus.paid,
                        child: Text('지급 완료'),
                      ),
                    ],
              ),
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
    String text;

    switch (status) {
      case SettlementStatus.pending:
        color = AppColors.warning;
        text = '승인 대기';
        break;
      case SettlementStatus.approved:
        color = AppColors.info;
        text = '승인됨';
        break;
      case SettlementStatus.paid:
        color = AppColors.success;
        text = '지급 완료';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
