import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/settlement_item.dart';
import '../providers/settlement_provider.dart';

class SettlementTable extends ConsumerWidget {
  final ValueNotifier<Set<String>> selectedItems;
  final Function(SettlementItem) onItemTap;
  final Function(SettlementItem, SettlementStatus) onStatusUpdate;

  const SettlementTable({
    super.key,
    required this.selectedItems,
    required this.onItemTap,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlementItemsAsync = ref.watch(settlementItemsProvider);

    return Card(
      child: Column(
        children: [
          // Table Header
          _buildTableHeader(context),

          // Table Content
          Expanded(
            child: settlementItemsAsync.when(
              data:
                  (items) =>
                      items.isEmpty
                          ? _buildEmptyState(context)
                          : _buildTableContent(context, items),
              loading: () => _buildLoadingState(context),
              error: (error, stack) => _buildErrorState(context, ref, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
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
          // Select All Checkbox
          ValueListenableBuilder<Set<String>>(
            valueListenable: selectedItems,
            builder: (context, selected, _) {
              return Checkbox(
                value: selected.isNotEmpty,
                tristate: true,
                onChanged: (value) => _toggleSelectAll(),
              );
            },
          ),
          const SizedBox(width: 8),

          const Expanded(flex: 2, child: Text('가이드')),
          const Expanded(flex: 2, child: Text('예약 정보')),
          const Expanded(flex: 1, child: Text('결제 금액')),
          const Expanded(flex: 1, child: Text('수수료율')),
          const Expanded(flex: 1, child: Text('정산 금액')),
          const Expanded(flex: 1, child: Text('상태')),
          const Expanded(flex: 1, child: Text('생성일')),
          const SizedBox(width: 100, child: Text('작업')),
        ],
      ),
    );
  }

  Widget _buildTableContent(BuildContext context, List<SettlementItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _SettlementRow(
          item: item,
          isSelected: selectedItems.value.contains(item.id),
          onSelectionChanged:
              (selected) => _toggleItemSelection(item.id, selected),
          onTap: () => onItemTap(item),
          onStatusUpdate: (status) => onStatusUpdate(item, status),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          Text(
            '정산 내역이 없습니다',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 8),
          Text(
            '필터 조건을 변경하거나 새로운 정산을 생성해보세요.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            '데이터를 불러올 수 없습니다',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(settlementItemsProvider),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  void _toggleSelectAll() {
    // TODO: Implement select all functionality
    // This would require access to all items
  }

  void _toggleItemSelection(String itemId, bool selected) {
    final current = Set<String>.from(selectedItems.value);
    if (selected) {
      current.add(itemId);
    } else {
      current.remove(itemId);
    }
    selectedItems.value = current;
  }
}

class _SettlementRow extends StatelessWidget {
  final SettlementItem item;
  final bool isSelected;
  final Function(bool) onSelectionChanged;
  final VoidCallback onTap;
  final Function(SettlementStatus) onStatusUpdate;

  const _SettlementRow({
    required this.item,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onTap,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final currencyFormat = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : null,
          border: const Border(
            bottom: BorderSide(color: AppColors.grey200, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Selection Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (value) => onSelectionChanged(value ?? false),
            ),
            const SizedBox(width: 8),

            // Guide Name
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.guideName ?? 'Unknown Guide',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Reservation Info
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.reservationNumber ?? 'N/A',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item.customerName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.customerName!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ],
              ),
            ),

            // Payment Amount
            Expanded(
              flex: 1,
              child: Text(currencyFormat.format(item.paymentAmount)),
            ),

            // Commission Rate
            Expanded(
              flex: 1,
              child: Text('${item.commissionRate.toStringAsFixed(1)}%'),
            ),

            // Settlement Amount
            Expanded(
              flex: 1,
              child: Text(
                currencyFormat.format(item.settlementAmount),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),

            // Status
            Expanded(flex: 1, child: _StatusChip(status: item.status)),

            // Created Date
            Expanded(flex: 1, child: Text(dateFormat.format(item.createdAt))),

            // Actions
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onTap,
                    icon: const Icon(Icons.visibility_outlined),
                    tooltip: '상세보기',
                  ),
                  PopupMenuButton<SettlementStatus>(
                    icon: const Icon(Icons.more_vert),
                    tooltip: '상태 변경',
                    onSelected: onStatusUpdate,
                    itemBuilder:
                        (context) => [
                          if (item.status != SettlementStatus.approved)
                            PopupMenuItem(
                              value: SettlementStatus.approved,
                              child: Row(
                                children: [
                                  const Icon(Icons.check, size: 16),
                                  const SizedBox(width: 8),
                                  Text(SettlementStatus.approved.displayName),
                                ],
                              ),
                            ),
                          if (item.status != SettlementStatus.paid)
                            PopupMenuItem(
                              value: SettlementStatus.paid,
                              child: Row(
                                children: [
                                  const Icon(Icons.payment, size: 16),
                                  const SizedBox(width: 8),
                                  Text(SettlementStatus.paid.displayName),
                                ],
                              ),
                            ),
                          if (item.status != SettlementStatus.pending)
                            PopupMenuItem(
                              value: SettlementStatus.pending,
                              child: Row(
                                children: [
                                  const Icon(Icons.pending, size: 16),
                                  const SizedBox(width: 8),
                                  Text(SettlementStatus.pending.displayName),
                                ],
                              ),
                            ),
                        ],
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

class _StatusChip extends StatelessWidget {
  final SettlementStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case SettlementStatus.pending:
        color = AppColors.warning;
        break;
      case SettlementStatus.approved:
        color = AppColors.info;
        break;
      case SettlementStatus.paid:
        color = AppColors.success;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
