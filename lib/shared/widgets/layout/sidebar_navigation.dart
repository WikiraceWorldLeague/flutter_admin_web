import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: Column(
        children: [
          // Logo/Header
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: AppColors.onPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Admin Web',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavigationItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: '대시보드',
                  path: '/dashboard',
                  isActive: currentLocation == '/dashboard',
                  onTap: () => context.go('/dashboard'),
                ),
                _NavigationItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: '고객 관리',
                  path: '/customers',
                  isActive: currentLocation == '/customers',
                  onTap: () => context.go('/customers'),
                ),
                _NavigationItem(
                  icon: Icons.event_note_outlined,
                  activeIcon: Icons.event_note,
                  label: '예약 관리',
                  path: '/reservations',
                  isActive: currentLocation == '/reservations',
                  onTap: () => context.go('/reservations'),
                ),
                _NavigationItem(
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: '가이드 관리',
                  path: '/guides',
                  isActive: currentLocation == '/guides',
                  onTap: () => context.go('/guides'),
                ),
                _NavigationItem(
                  icon: Icons.account_balance_wallet_outlined,
                  activeIcon: Icons.account_balance_wallet,
                  label: '정산 관리',
                  path: '/settlements',
                  isActive: currentLocation == '/settlements',
                  onTap: () => context.go('/settlements'),
                ),
                _NavigationItem(
                  icon: Icons.rate_review_outlined,
                  activeIcon: Icons.rate_review,
                  label: '리뷰 관리',
                  path: '/reviews',
                  isActive: currentLocation == '/reviews',
                  onTap: () => context.go('/reviews'),
                ),
              ],
            ),
          ),

          // Bottom Section (Logout, etc.)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey200, width: 1),
              ),
            ),
            child: _NavigationItem(
              icon: Icons.logout_outlined,
              activeIcon: Icons.logout,
              label: '로그아웃',
              path: '/logout',
              isActive: false,
              onTap: () => context.go('/login'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
  final bool isActive;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color:
            isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.primary : AppColors.grey600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive ? AppColors.primary : AppColors.grey700,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
