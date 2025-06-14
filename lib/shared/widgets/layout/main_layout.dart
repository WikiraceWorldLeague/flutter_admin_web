import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import 'sidebar_navigation.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar Navigation
          const SidebarNavigation(),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top AppBar
                Container(
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      bottom: BorderSide(color: AppColors.grey200, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        _getPageTitle(context),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      // User Profile or Settings can go here
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                
                // Page Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case '/dashboard':
        return '대시보드';
      case '/reservations':
        return '예약 관리';
      case '/guides':
        return '가이드 관리';
      case '/settlements':
        return '정산 관리';
      case '/reviews':
        return '리뷰 관리';
      default:
        return 'Admin Dashboard';
    }
  }
} 