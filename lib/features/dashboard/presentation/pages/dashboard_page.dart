import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Section
        Text(
          'Welcome to Admin Dashboard',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '가이드 관리 시스템에 오신 것을 환영합니다.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.grey600,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Stats Cards Row
        Row(
          children: [
            Expanded(
              child: _StatsCard(
                title: '총 예약',
                value: '128',
                change: '+12%',
                isPositive: true,
                icon: Icons.event_note,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatsCard(
                title: '활성 가이드',
                value: '24',
                change: '+3',
                isPositive: true,
                icon: Icons.people,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatsCard(
                title: '총 정산',
                value: '₩2,450,000',
                change: '+8.5%',
                isPositive: true,
                icon: Icons.account_balance_wallet,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatsCard(
                title: '평균 리뷰',
                value: '4.8',
                change: '+0.2',
                isPositive: true,
                icon: Icons.star,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Quick Actions Section
        Text(
          '빠른 작업',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: '새 예약 추가',
                description: '새로운 예약을 등록합니다',
                icon: Icons.add_circle_outline,
                onTap: () {
                  // TODO: Navigate to add reservation
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickActionCard(
                title: '가이드 관리',
                description: '가이드 정보를 관리합니다',
                icon: Icons.person_add_outlined,
                onTap: () {
                  // TODO: Navigate to guides
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickActionCard(
                title: '정산 처리',
                description: '정산 내역을 확인합니다',
                icon: Icons.receipt_long_outlined,
                onTap: () {
                  // TODO: Navigate to settlements
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Recent Activity Section
        Text(
          '최근 활동',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '최근 예약 현황',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        '데이터가 로드되면 여기에 표시됩니다.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.success : AppColors.error)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isPositive ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.description,
    required this.icon,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 