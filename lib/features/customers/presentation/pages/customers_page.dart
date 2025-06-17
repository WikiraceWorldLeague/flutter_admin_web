import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';
import 'package:flutter_admin_web/features/customers/data/providers/customers_providers.dart';
import 'package:flutter_admin_web/features/customers/presentation/providers/customers_ui_providers.dart';
import 'package:flutter_admin_web/features/customers/presentation/widgets/customer_list_widget.dart';
import 'package:flutter_admin_web/features/customers/presentation/widgets/customer_search_widget.dart';
import 'package:flutter_admin_web/features/customers/presentation/widgets/customer_form_dialog.dart';
import 'package:flutter_admin_web/shared/widgets/common/error_display_widget.dart';

/// 고객 관리 페이지
class CustomersPage extends HookConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 필터와 페이지네이션 상태
    final filters = ref.watch(customerFiltersNotifierProvider);
    final pagination = ref.watch(customerPaginationNotifierProvider);

    // 고객 목록 조회
    final customersAsync = ref.watch(
      customersListProvider(
        filters: filters,
        limit: pagination.pageSize,
        offset: pagination.offset,
      ),
    );

    // 고객 통계 조회
    final statsAsync = ref.watch(customerStatsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 페이지 헤더
            _buildPageHeader(context, ref, statsAsync),
            const SizedBox(height: 24),

            // 검색 및 필터 영역
            const CustomerSearchWidget(),
            const SizedBox(height: 16),

            // 고객 목록
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    // 목록 헤더
                    _buildListHeader(context, ref),
                    const Divider(height: 1),

                    // 고객 목록 내용
                    Expanded(
                      child: customersAsync.when(
                        data:
                            (customers) => CustomerListWidget(
                              customers: customers,
                              pagination: pagination,
                              onPageChanged: (page) {
                                ref
                                    .read(
                                      customerPaginationNotifierProvider
                                          .notifier,
                                    )
                                    .setPage(page);
                              },
                            ),
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error:
                            (error, stackTrace) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ErrorDisplayWidget(
                                    message:
                                        '고객 목록을 불러오는데 실패했습니다.\n${error.toString()}',
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed:
                                        () => ref.refresh(
                                          customersListProvider(
                                            filters: filters,
                                            limit: pagination.pageSize,
                                            offset: pagination.offset,
                                          ),
                                        ),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('다시 시도'),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 페이지 헤더 위젯
  Widget _buildPageHeader(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<CustomerStats> statsAsync,
  ) {
    return Column(
      children: [
        // 상단 타이틀과 버튼 행
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 페이지 제목
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '고객 관리',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '고객 정보를 등록하고 관리합니다.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // 고객 등록 버튼
            ElevatedButton.icon(
              onPressed: () => _showCustomerFormDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('고객 등록'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),

        // 통계 카드들
        if (statsAsync.hasValue) ...[
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: _buildStatsCards(context, statsAsync.value!),
          ),
        ],
      ],
    );
  }

  /// 통계 카드 위젯들
  Widget _buildStatsCards(BuildContext context, CustomerStats stats) {
    return Row(
      children: [
        _buildStatCard(
          context,
          '전체 고객',
          stats.totalCustomers.toString(),
          Icons.people,
          Colors.blue,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          context,
          '신규 고객',
          stats.newCustomers.toString(),
          Icons.person_add,
          Colors.green,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          context,
          '재구매 고객',
          stats.returningCustomers.toString(),
          Icons.repeat,
          Colors.orange,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          context,
          '총 매출',
          '${stats.totalRevenue.toStringAsFixed(0)}원',
          Icons.attach_money,
          Colors.purple,
        ),
      ],
    );
  }

  /// 개별 통계 카드
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 목록 헤더 위젯
  Widget _buildListHeader(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(customerFiltersNotifierProvider);
    final hasActiveFilters =
        filters.searchQuery?.isNotEmpty == true ||
        filters.gender != null ||
        filters.nationality?.isNotEmpty == true ||
        filters.acquisitionChannel?.isNotEmpty == true ||
        filters.communicationChannel?.isNotEmpty == true ||
        filters.isBooker != null ||
        filters.createdAfter != null ||
        filters.createdBefore != null ||
        filters.minPaymentAmount != null ||
        filters.maxPaymentAmount != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            '고객 목록',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (hasActiveFilters) ...[
            TextButton.icon(
              onPressed: () {
                ref
                    .read(customerFiltersNotifierProvider.notifier)
                    .clearFilters();
                ref
                    .read(customerPaginationNotifierProvider.notifier)
                    .setPage(0);
              },
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('필터 초기화'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            onPressed: () {
              // 새로고침
              ref.invalidate(customersListProvider);
              ref.invalidate(customerStatsProvider);
            },
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
          ),
        ],
      ),
    );
  }

  /// 고객 등록/수정 다이얼로그 표시
  void _showCustomerFormDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => CustomerFormDialog(
            onSaved: () {
              // 고객 목록 새로고침
              ref.invalidate(customersListProvider);
              ref.invalidate(customerStatsProvider);
            },
          ),
    );
  }
}
