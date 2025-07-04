import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/reservation_models.dart';
import '../providers/reservations_providers.dart';
import '../../../../core/theme/app_theme.dart';

class GuideAssignmentDialog extends ConsumerStatefulWidget {
  final Reservation reservation;
  final Function(String guideId) onAssign;

  const GuideAssignmentDialog({
    super.key,
    required this.reservation,
    required this.onAssign,
  });

  @override
  ConsumerState<GuideAssignmentDialog> createState() => _GuideAssignmentDialogState();
}

class _GuideAssignmentDialogState extends ConsumerState<GuideAssignmentDialog> {
  String? _selectedGuideId;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    _selectedGuideId = widget.reservation.assignedGuide?.id;
  }

  @override
  Widget build(BuildContext context) {
    final guidesAsync = ref.watch(guidesProvider);

    return AlertDialog(
      title: Text(
        '가이드 ${widget.reservation.assignedGuide != null ? '변경' : '배정'}',
        style: TextStyle(
          color: AppColors.onBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 예약 정보 요약
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.reservation.reservationNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.reservation.clinic.name,
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.reservation.customerNames,
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 가이드 목록
            Text(
              '가이드 선택',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 8),

            guidesAsync.when(
              data: (guides) {
                if (guides.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '사용 가능한 가이드가 없습니다.',
                      style: TextStyle(color: AppColors.grey600),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: guides.length,
                    itemBuilder: (context, index) {
                      final guide = guides[index];
                      final isSelected = _selectedGuideId == guide.id;
                      final isCurrent = widget.reservation.assignedGuide?.id == guide.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isSelected 
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.surface,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isSelected 
                                ? AppColors.primary 
                                : AppColors.grey400,
                            child: Icon(
                              Icons.person,
                              color: isSelected 
                                  ? Colors.white 
                                  : AppColors.grey600,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                guide.nickname,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              if (isCurrent) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.info.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.info.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '현재',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.info,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (guide.phoneNumber != null)
                                Text(
                                  guide.phoneNumber!,
                                  style: TextStyle(
                                    color: AppColors.grey600,
                                    fontSize: 12,
                                  ),
                                ),
                              if (guide.email != null)
                                Text(
                                  guide.email!,
                                  style: TextStyle(
                                    color: AppColors.grey600,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedGuideId = guide.id;
                            });
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => Container(
                height: 100,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '가이드 목록을 불러올 수 없습니다.',
                      style: TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAssigning ? null : () => Navigator.of(context).pop(),
          child: Text(
            '취소',
            style: TextStyle(color: AppColors.grey600),
          ),
        ),
        ElevatedButton(
          onPressed: _isAssigning || _selectedGuideId == null
              ? null
              : () => _assignGuide(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isAssigning
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(widget.reservation.assignedGuide != null ? '변경' : '배정'),
        ),
      ],
    );
  }

  Future<void> _assignGuide() async {
    if (_selectedGuideId == null) return;

    setState(() {
      _isAssigning = true;
    });

    try {
      widget.onAssign(_selectedGuideId!);
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '가이드가 ${widget.reservation.assignedGuide != null ? '변경' : '배정'}되었습니다.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('가이드 배정에 실패했습니다: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAssigning = false;
        });
      }
    }
  }
} 