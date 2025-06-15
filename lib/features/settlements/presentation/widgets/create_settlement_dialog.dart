import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';

class CreateSettlementDialog extends ConsumerStatefulWidget {
  const CreateSettlementDialog({super.key});

  @override
  ConsumerState<CreateSettlementDialog> createState() =>
      _CreateSettlementDialogState();
}

class _CreateSettlementDialogState
    extends ConsumerState<CreateSettlementDialog> {
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;

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
            Text(
              '정산 생성',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text('완료된 예약에서 정산을 생성합니다.'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 정산 생성 로직
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('생성'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
