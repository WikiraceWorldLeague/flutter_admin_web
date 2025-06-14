import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class GuidesPage extends StatelessWidget {
  const GuidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '가이드 관리',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '가이드 정보를 관리하고 할당 현황을 확인하세요.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new guide
              },
              icon: const Icon(Icons.person_add),
              label: const Text('가이드 등록'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Search and Status Filter
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '가이드명, 전화번호 검색...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Show status filter
              },
              icon: const Icon(Icons.tune),
              label: const Text('상태 필터'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Guide Stats
        Row(
          children: [
            Expanded(
              child: _GuideStatsCard(
                title: '전체 가이드',
                count: 24,
                color: AppColors.primary,
                icon: Icons.people,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _GuideStatsCard(
                title: '활성 가이드',
                count: 18,
                color: AppColors.success,
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _GuideStatsCard(
                title: '휴무중',
                count: 6,
                color: AppColors.warning,
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _GuideStatsCard(
                title: '평균 평점',
                count: 4.8,
                color: AppColors.info,
                icon: Icons.star,
                isRating: true,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Guides Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 8, // Placeholder count
            itemBuilder: (context, index) {
              return _GuideCard(
                name: '가이드 ${index + 1}',
                phone: '010-1234-567${index}',
                rating: 4.5 + (index % 3) * 0.1,
                totalReservations: 25 + index * 3,
                isActive: index % 3 != 0,
                imageUrl: null, // Placeholder for now
                onTap: () {
                  // TODO: Navigate to guide detail
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GuideStatsCard extends StatelessWidget {
  final String title;
  final dynamic count;
  final Color color;
  final IconData icon;
  final bool isRating;

  const _GuideStatsCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    this.isRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              isRating ? count.toString() : count.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String name;
  final String phone;
  final double rating;
  final int totalReservations;
  final bool isActive;
  final String? imageUrl;
  final VoidCallback onTap;

  const _GuideCard({
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalReservations,
    required this.isActive,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Image
              Stack(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                    child: imageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 32,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  // Status Indicator
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.success : AppColors.grey400,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Name
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 4),
              
              // Phone
              Text(
                phone,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              // Total Reservations
              Text(
                '총 ${totalReservations}건',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isActive ? AppColors.success : AppColors.grey400)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? '활성' : '휴무',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? AppColors.success : AppColors.grey600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 