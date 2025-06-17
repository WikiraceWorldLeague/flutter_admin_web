import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_admin_web/features/customers/data/models/customer_model.dart';
import 'package:flutter_admin_web/features/customers/data/providers/customers_providers.dart';
import 'package:flutter_admin_web/features/customers/presentation/widgets/customer_form_dialog.dart';

/// 고객 목록 위젯
class CustomerListWidget extends ConsumerWidget {
  final List<Customer>? customers;

  const CustomerListWidget({super.key, this.customers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync =
        customers != null
            ? AsyncValue.data(customers!)
            : ref.watch(customersListProvider());

    return customersAsync.when(
      data: (customers) {
        if (customers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '고객이 없습니다',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 32,
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('이름')),
                  DataColumn(label: Text('구분')),
                  DataColumn(label: Text('국적')),
                  DataColumn(label: Text('성별')),
                  DataColumn(label: Text('나이')),
                  DataColumn(label: Text('여권명')),
                  DataColumn(label: Text('소통채널')),
                  DataColumn(label: Text('채널계정')),
                  DataColumn(label: Text('등록일')),
                  DataColumn(label: Text('작업')),
                ],
                rows:
                    customers.map((customer) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  customer.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (customer.customerNote?.isNotEmpty == true)
                                  Text(
                                    customer.customerNote!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    customer.isBooker
                                        ? Colors.blue.shade100
                                        : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                customer.isBooker ? '예약자' : '동반자',
                                style: TextStyle(
                                  color:
                                      customer.isBooker
                                          ? Colors.blue.shade800
                                          : Colors.orange.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(customer.nationality ?? '-')),
                          DataCell(Text(customer.gender?.displayName ?? '-')),
                          DataCell(Text(customer.age?.toString() ?? '-')),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (customer.passportName?.isNotEmpty == true)
                                  Text(
                                    customer.passportName!,
                                    style: const TextStyle(fontSize: 12),
                                  )
                                else
                                  const Text(
                                    '-',
                                    style: TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (customer.communicationChannel != null) ...[
                                  Icon(
                                    _getCommunicationChannelIcon(
                                      customer.communicationChannel!,
                                    ),
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    customer.communicationChannel!.displayName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ] else
                                  const Text(
                                    '-',
                                    style: TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                          DataCell(Text(customer.channelAccount ?? '-')),
                          DataCell(
                            Text(
                              customer.createdAt != null
                                  ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(customer.createdAt!)
                                  : '-',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed:
                                      () => _showEditDialog(
                                        context,
                                        ref,
                                        customer,
                                      ),
                                  tooltip: '수정',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _showDeleteDialog(
                                        context,
                                        ref,
                                        customer,
                                      ),
                                  tooltip: '삭제',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('오류가 발생했습니다: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(customersListProvider()),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
    );
  }

  IconData _getCommunicationChannelIcon(CommunicationChannel channel) {
    switch (channel) {
      case CommunicationChannel.instagram:
        return Icons.camera_alt;
      case CommunicationChannel.whatsapp:
        return Icons.message;
      case CommunicationChannel.line:
        return Icons.send;
      case CommunicationChannel.other:
        return Icons.more_horiz;
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Customer customer) {
    showDialog(
      context: context,
      builder:
          (context) => CustomerFormDialog(
            customer: customer,
            onSaved: () => ref.refresh(customersListProvider()),
          ),
    );
  }

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
                  try {
                    await ref
                        .read(customerDeleterProvider.notifier)
                        .deleteCustomer(customer.id!);

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      // 목록 새로고침
                      ref.invalidate(customersListProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('고객이 삭제되었습니다'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('삭제 실패: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }
}
