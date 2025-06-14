import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSkillsSection extends ConsumerWidget {
  const LanguageSkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.language_outlined,
              size: 48,
              color: Color(0xFF6C757D),
            ),
            SizedBox(height: 12),
            Text(
              '언어 능력 섹션',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF495057),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '인라인 추가 방식: [언어 ▼] [숙련도 ▼] [+ 추가]',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 