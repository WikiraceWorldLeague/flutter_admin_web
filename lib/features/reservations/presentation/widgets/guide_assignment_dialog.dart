import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/reservation_models.dart';
import '../providers/reservations_providers.dart';
import '../../../../core/theme/app_theme.dart';

class GuideAssignmentDialog extends HookConsumerWidget {
  final Reservation reservation;
  final Function(String guideId) onAssign;

  const GuideAssignmentDialog({
    super.key,
    required this.reservation,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGuideId = useState<String?>(reservation.assignedGuide?.id);
    final isAssigning = useState(false);

    final guidesAsync = ref.watch(guidesProvider);

    Future<void> assignGuide() async {
      if (selectedGuideId.value == null) return;

      isAssigning.value = true;

      try {
        onAssign(selectedGuideId.value!);
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '가이드가 ${reservation.assignedGuide != null ? '변경' : '배정'}되었습니다.',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      } finally {
        isAssigning.value = false;
      }
    }

    return AlertDialog(
      title: Text(
        '가이드 ${reservation.assignedGuide != null ? '변경' : '배정'}',
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
                    reservation.reservationNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reservation.clinic.name,
                    style: TextStyle(color: AppColors.grey600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reservation.customerNames,
                    style: TextStyle(color: AppColors.grey600, fontSize: 14),
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
                      final isSelected = selectedGuideId.value == guide.id;
                      final isCurrent =
                          reservation.assignedGuide?.id == guide.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color:
                            isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surface,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.grey400,
                            child: Icon(
                              Icons.person,
                              color:
                                  isSelected ? Colors.white : AppColors.grey600,
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
                          trailing:
                              isSelected
                                  ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  )
                                  : null,
                          onTap: () {
                            selectedGuideId.value = guide.id;
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading:
                  () => Container(
                    height: 100,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              error:
                  (error, stack) => Container(
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
          onPressed:
              isAssigning.value ? null : () => Navigator.of(context).pop(),
          child: Text('취소', style: TextStyle(color: AppColors.grey600)),
        ),
        ElevatedButton(
          onPressed:
              isAssigning.value || selectedGuideId.value == null
                  ? null
                  : assignGuide,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child:
              isAssigning.value
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text(reservation.assignedGuide != null ? '변경' : '배정'),
        ),
      ],
    );
  }
}
