import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/reservations/presentation/pages/reservations_page.dart';
import '../../features/guides/presentation/pages/guides_page.dart';
import '../../features/guides/presentation/pages/guide_form_page.dart';
import '../../features/settlements/presentation/pages/settlements_page.dart';
import '../../features/reviews/presentation/pages/reviews_page.dart';
import '../../shared/widgets/layout/main_layout.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Main App Routes with Layout
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/reservations',
            name: 'reservations',
            builder: (context, state) => const ReservationsPage(),
          ),
          GoRoute(
            path: '/guides',
            name: 'guides',
            builder: (context, state) => const GuidesPage(),
            routes: [
              GoRoute(
                path: '/new',
                name: 'guide-new',
                builder: (context, state) => const GuideFormPage(),
              ),
              GoRoute(
                path: '/edit/:id',
                name: 'guide-edit',
                builder: (context, state) {
                  final guideId = state.pathParameters['id']!;
                  return GuideFormPage(guideId: guideId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settlements',
            name: 'settlements',
            builder: (context, state) => const SettlementsPage(),
          ),
          GoRoute(
            path: '/reviews',
            name: 'reviews',
            builder: (context, state) => const ReviewsPage(),
          ),
        ],
      ),
    ],
  );
});

// Router Extensions for Easy Navigation
extension AppRouterExtension on GoRouter {
  void goToLogin() => go('/login');
  void goToDashboard() => go('/dashboard');
  void goToReservations() => go('/reservations');
  void goToGuides() => go('/guides');
  void goToGuideNew() => go('/guides/new');
  void goToGuideEdit(String guideId) => go('/guides/edit/$guideId');
  void goToSettlements() => go('/settlements');
  void goToReviews() => go('/reviews');
} 