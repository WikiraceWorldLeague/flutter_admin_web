import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '리뷰 관리',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '고객 리뷰를 관리하고 응답하세요.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.grey600,
          ),
        ),
        
        const SizedBox(height: 32),
        
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 64,
                  color: AppColors.grey400,
                ),
                const SizedBox(height: 16),
                Text(
                  '리뷰 관리 기능',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Phase 3에서 구현될 예정입니다.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 