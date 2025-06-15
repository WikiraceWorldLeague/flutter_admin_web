import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/settlement_item.dart';
import '../providers/settlement_provider.dart';

class SettlementFiltersSection extends ConsumerWidget {
  const SettlementFiltersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(settlementFiltersProvider);
    final guidesAsync = ref.watch(guidesForFilterProvider);
    final actions = ref.read(settlementActionsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '필터',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                // Date Range Filter
                Expanded(
                  flex: 2,
                  child: _DateRangeFilter(
                    startDate: filters.startDate,
                    endDate: filters.endDate,
                    onDateRangeChanged: (start, end) {
                      actions.updateFilters(
                        filters.copyWith(startDate: start, endDate: end),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Guide Filter
                Expanded(
                  flex: 2,
                  child: guidesAsync.when(
                    data:
                        (guides) => _GuideFilter(
                          guides: guides,
                          selectedGuideId: filters.guideId,
                          onGuideChanged: (guideId) {
                            actions.updateFilters(
                              filters.copyWith(guideId: guideId),
                            );
                          },
                        ),
                    loading: () => const _LoadingDropdown(label: '가이드 선택'),
                    error: (_, __) => const _ErrorDropdown(label: '가이드 선택'),
                  ),
                ),

                const SizedBox(width: 16),

                // Status Filter
                Expanded(
                  flex: 1,
                  child: _StatusFilter(
                    selectedStatus: filters.status,
                    onStatusChanged: (status) {
                      actions.updateFilters(filters.copyWith(status: status));
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Search Field
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: '검색',
                      hintText: '예약번호, 고객명 검색...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      actions.updateFilters(
                        filters.copyWith(
                          searchQuery: value.isEmpty ? null : value,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Clear Filters Button
                OutlinedButton.icon(
                  onPressed: () => actions.clearFilters(),
                  icon: const Icon(Icons.clear),
                  label: const Text('초기화'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDateRangeChanged;

  const _DateRangeFilter({
    required this.startDate,
    required this.endDate,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return OutlinedButton.icon(
      onPressed: () => _showDateRangePicker(context),
      icon: const Icon(Icons.calendar_today),
      label: Text(
        startDate != null && endDate != null
            ? '${dateFormat.format(startDate!)} ~ ${dateFormat.format(endDate!)}'
            : '기간 선택',
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange:
          startDate != null && endDate != null
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
    );

    if (picked != null) {
      onDateRangeChanged(picked.start, picked.end);
    }
  }
}

class _GuideFilter extends StatelessWidget {
  final List<Map<String, dynamic>> guides;
  final String? selectedGuideId;
  final Function(String?) onGuideChanged;

  const _GuideFilter({
    required this.guides,
    required this.selectedGuideId,
    required this.onGuideChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: '가이드 선택'),
      value: selectedGuideId,
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('전체 가이드')),
        ...guides.map(
          (guide) => DropdownMenuItem<String>(
            value: guide['id'],
            child: Text(guide['name']),
          ),
        ),
      ],
      onChanged: onGuideChanged,
    );
  }
}

class _StatusFilter extends StatelessWidget {
  final SettlementStatus? selectedStatus;
  final Function(SettlementStatus?) onStatusChanged;

  const _StatusFilter({
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SettlementStatus>(
      decoration: const InputDecoration(labelText: '상태'),
      value: selectedStatus,
      items: [
        const DropdownMenuItem<SettlementStatus>(
          value: null,
          child: Text('전체 상태'),
        ),
        ...SettlementStatus.values.map(
          (status) => DropdownMenuItem<SettlementStatus>(
            value: status,
            child: Text(status.displayName),
          ),
        ),
      ],
      onChanged: onStatusChanged,
    );
  }
}

class _LoadingDropdown extends StatelessWidget {
  final String label;

  const _LoadingDropdown({required this.label});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: const [],
      onChanged: null,
      hint: const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('로딩 중...'),
        ],
      ),
    );
  }
}

class _ErrorDropdown extends StatelessWidget {
  final String label;

  const _ErrorDropdown({required this.label});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, errorText: '데이터 로드 실패'),
      items: const [],
      onChanged: null,
    );
  }
}
