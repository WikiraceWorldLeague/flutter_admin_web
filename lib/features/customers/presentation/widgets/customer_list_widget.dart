import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';
import 'package:flutter_admin_web/features/customers/data/providers/customers_providers.dart';
import 'package:flutter_admin_web/features/customers/presentation/providers/customers_ui_providers.dart';
import 'package:flutter_admin_web/features/customers/presentation/widgets/customer_form_dialog.dart';

/// 고객 목록 위젯
class CustomerListWidget extends ConsumerWidget {
  const CustomerListWidget({
    super.key,
    required this.customers,
    required this.pagination,
    required this.onPageChanged,
  });

  final List<Customer> customers;
  final CustomerPaginationState pagination;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (customers.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // 테이블
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 100,
              ),
              child: _buildDataTable(context, ref),
            ),
          ),
        ),

        // 페이지네이션
        if (customers.isNotEmpty) ...[
          const Divider(height: 1),
          _buildPagination(context),
        ],
      ],
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            '등록된 고객이 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새 고객을 등록해보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 데이터 테이블 위젯
  Widget _buildDataTable(BuildContext context, WidgetRef ref) {
    return DataTable(
      columnSpacing: 16,
      horizontalMargin: 16,
      columns: const [
        DataColumn(label: Text('고객명')),
        DataColumn(label: Text('여권명')),
        DataColumn(label: Text('고객코드')),
        DataColumn(label: Text('국적')),
        DataColumn(label: Text('성별')),
        DataColumn(label: Text('예약자')),
        DataColumn(label: Text('총 결제금액')),
        DataColumn(label: Text('등록일')),
        DataColumn(label: Text('액션')),
      ],
      rows:
          customers.map((customer) {
            return DataRow(
              cells: [
                // 고객명
                DataCell(
                  Text(
                    customer.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

                // 여권명
                DataCell(Text(customer.passportName ?? '-')),

                // 고객코드
                DataCell(
                  customer.customerCode != null
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          customer.customerCode!,
                          style: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                      : const Text('-'),
                ),

                // 국적
                DataCell(Text(customer.nationality ?? '-')),

                // 성별
                DataCell(
                  customer.gender != null
                      ? _buildGenderChip(context, customer.gender!)
                      : const Text('-'),
                ),

                // 예약자 여부
                DataCell(_buildBookerChip(context, customer.isBooker)),

                // 총 결제금액
                DataCell(
                  Text(
                    NumberFormat('#,###').format(customer.totalPaymentAmount) +
                        '원',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          customer.totalPaymentAmount > 0
                              ? Theme.of(context).colorScheme.primary
                              : null,
                    ),
                  ),
                ),

                // 등록일
                DataCell(
                  Text(DateFormat('yyyy-MM-dd').format(customer.createdAt)),
                ),

                // 액션 버튼들
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 상세보기 버튼
                      IconButton(
                        onPressed:
                            () => _showCustomerDetail(context, ref, customer),
                        icon: const Icon(Icons.visibility),
                        tooltip: '상세보기',
                        iconSize: 20,
                      ),

                      // 수정 버튼
                      IconButton(
                        onPressed:
                            () => _showEditDialog(context, ref, customer),
                        icon: const Icon(Icons.edit),
                        tooltip: '수정',
                        iconSize: 20,
                      ),

                      // 삭제 버튼
                      IconButton(
                        onPressed:
                            () => _showDeleteDialog(context, ref, customer),
                        icon: const Icon(Icons.delete),
                        tooltip: '삭제',
                        iconSize: 20,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  /// 성별 칩 위젯
  Widget _buildGenderChip(BuildContext context, CustomerGender gender) {
    final (text, color) = switch (gender) {
      CustomerGender.male => ('남성', Colors.blue),
      CustomerGender.female => ('여성', Colors.pink),
      CustomerGender.other => ('기타', Colors.grey),
    };

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
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 예약자 칩 위젯
  Widget _buildBookerChip(BuildContext context, bool isBooker) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isBooker
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isBooker ? '예약자' : '비예약자',
        style: TextStyle(
          color:
              isBooker
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 페이지네이션 위젯
  Widget _buildPagination(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 페이지 정보
          Text(
            '페이지 ${pagination.currentPage + 1} • ${customers.length}개 항목',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),

          // 페이지네이션 버튼들
          Row(
            children: [
              // 이전 페이지 버튼
              IconButton(
                onPressed:
                    pagination.currentPage > 0
                        ? () => onPageChanged(pagination.currentPage - 1)
                        : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: '이전 페이지',
              ),

              // 페이지 번호들 (간단히 현재 페이지만 표시)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${pagination.currentPage + 1}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // 다음 페이지 버튼
              IconButton(
                onPressed:
                    customers.length >= pagination.pageSize
                        ? () => onPageChanged(pagination.currentPage + 1)
                        : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: '다음 페이지',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 고객 상세보기
  void _showCustomerDetail(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) {
    ref
        .read(selectedCustomerNotifierProvider.notifier)
        .selectCustomer(customer);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${customer.name} 상세 정보'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('고객명', customer.name),
                  _buildDetailRow('여권명', customer.passportName ?? '-'),
                  _buildDetailRow('고객코드', customer.customerCode ?? '-'),
                  _buildDetailRow('국적', customer.nationality ?? '-'),
                  _buildDetailRow('성별', customer.gender?.name ?? '-'),
                  _buildDetailRow('나이', customer.age?.toString() ?? '-'),
                  _buildDetailRow('전화번호', customer.phone ?? '-'),
                  _buildDetailRow('예약자 여부', customer.isBooker ? '예' : '아니오'),
                  _buildDetailRow('유입채널', customer.acquisitionChannel ?? '-'),
                  _buildDetailRow('소통채널', customer.communicationChannel ?? '-'),
                  _buildDetailRow(
                    '총 결제금액',
                    NumberFormat('#,###').format(customer.totalPaymentAmount) +
                        '원',
                  ),
                  _buildDetailRow(
                    '등록일',
                    DateFormat('yyyy-MM-dd HH:mm').format(customer.createdAt),
                  ),
                  if (customer.customerNote?.isNotEmpty == true) ...[
                    const SizedBox(height: 8),
                    Text(
                      '고객 메모',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(customer.customerNote!),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('닫기'),
              ),
            ],
          ),
    );
  }

  /// 상세 정보 행 위젯
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// 수정 다이얼로그 표시
  void _showEditDialog(BuildContext context, WidgetRef ref, Customer customer) {
    showDialog(
      context: context,
      builder:
          (context) => CustomerFormDialog(
            customer: customer,
            onSaved: () {
              // 목록 새로고침은 부모에서 처리
            },
          ),
    );
  }

  /// 삭제 확인 다이얼로그 표시
  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('고객 삭제'),
            content: Text('${customer.name} 고객을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  try {
                    await ref
                        .read(customerDeleterProvider.notifier)
                        .deleteCustomer(customer.id!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('고객이 삭제되었습니다.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('삭제 실패: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }
}
