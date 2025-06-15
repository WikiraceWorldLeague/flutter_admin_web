import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/settlement_item.dart';

class SettlementStatusDialog extends StatefulWidget {
  final SettlementItem item;
  final Function(SettlementStatus, String?) onStatusUpdate;

  const SettlementStatusDialog({
    super.key,
    required this.item,
    required this.onStatusUpdate,
  });

  @override
  State<SettlementStatusDialog> createState() => _SettlementStatusDialogState();
}

class _SettlementStatusDialogState extends State<SettlementStatusDialog> {
  late SettlementStatus selectedStatus;
  late TextEditingController notesController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.item.status;
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  '정산 상태 변경',
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

            // Current Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '현재 상태',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 4),
                  _StatusBadge(status: widget.item.status),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // New Status Selection
            Text(
              '변경할 상태',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Column(
              children:
                  SettlementStatus.values.map((status) {
                    final isEnabled = _isStatusChangeAllowed(
                      widget.item.status,
                      status,
                    );

                    return RadioListTile<SettlementStatus>(
                      title: Row(
                        children: [
                          _StatusBadge(status: status),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getStatusDescription(status),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: isEnabled ? null : AppColors.grey400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      value: status,
                      groupValue: selectedStatus,
                      onChanged:
                          isEnabled
                              ? (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedStatus = value;
                                  });
                                }
                              }
                              : null,
                      activeColor: AppColors.primary,
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            // Notes
            Text(
              '메모 (선택사항)',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '상태 변경 사유나 추가 정보를 입력하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            Navigator.of(context).pop();
                          },
                  child: const Text('취소'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed:
                      isLoading || selectedStatus == widget.item.status
                          ? null
                          : () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await widget.onStatusUpdate(
                                selectedStatus,
                                notesController.text.trim().isEmpty
                                    ? null
                                    : notesController.text.trim(),
                              );
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('상태 변경 실패: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('변경'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isStatusChangeAllowed(
    SettlementStatus current,
    SettlementStatus target,
  ) {
    // 같은 상태로는 변경 불가
    if (current == target) return false;

    switch (current) {
      case SettlementStatus.pending:
        // pending에서는 approved나 paid로 변경 가능
        return target == SettlementStatus.approved ||
            target == SettlementStatus.paid;
      case SettlementStatus.approved:
        // approved에서는 paid로만 변경 가능 (또는 pending으로 되돌리기)
        return target == SettlementStatus.paid ||
            target == SettlementStatus.pending;
      case SettlementStatus.paid:
        // paid에서는 approved로만 되돌리기 가능
        return target == SettlementStatus.approved;
    }
  }

  String _getStatusDescription(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.pending:
        return '승인 대기 중인 정산';
      case SettlementStatus.approved:
        return '승인되어 지급 대기 중인 정산';
      case SettlementStatus.paid:
        return '지급 완료된 정산';
    }
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
