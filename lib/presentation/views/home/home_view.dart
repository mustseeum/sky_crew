import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/license_controller.dart';
import '../../controllers/logbook_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/logbook/summary_card.dart';
import '../fatigue/fatigue_tracking_view.dart';
import '../licenses/licenses_view.dart';
import '../logbook/logbook_view.dart';
import '../profile/profile_view.dart';

/// Home/dashboard screen with role-specific quick stats and bottom navigation.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    return Obx(() {
      final pages = [
        const _DashboardTab(),
        const LogbookView(),
        const LicensesView(),
        const FatigueTrackingView(),
        const ProfileView(),
      ];

      return Scaffold(
        body: IndexedStack(
          index: nav.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.selectedIndex.value,
          onTap: nav.setIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Logbook',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_membership_outlined),
              activeIcon: Icon(Icons.card_membership),
              label: 'Licenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor_heart_outlined),
              activeIcon: Icon(Icons.monitor_heart),
              label: 'Wellness',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final logbook = Get.find<LogbookController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Obx(() {
          final user = auth.currentUser.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Good ${_greeting()},',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
              Text(
                user?.name ?? 'Crew Member',
                style: AppTextStyles.headlineMedium,
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role badge
            Obx(() {
              final user = auth.currentUser.value;
              if (user == null) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role.displayName,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),

            // Logbook summary
            Obx(() {
              final s = logbook.summary.value;
              if (s == null) return const SizedBox.shrink();
              return Column(
                children: [
                  SummaryCard(summary: s),
                  const SizedBox(height: 16),
                ],
              );
            }),

            Text('Quick Actions', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.add_circle_outline,
                    label: 'Log Flight',
                    color: AppColors.primary,
                    onTap: () {
                      logbook.clearSelectedRecord();
                      Get.toNamed(AppRoutes.addFlight);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.monitor_heart_outlined,
                    label: 'Log Wellness',
                    color: AppColors.tertiary,
                    onTap: () => Get.toNamed(AppRoutes.fatigueTracking),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.menu_book_outlined,
                    label: 'Logbook',
                    color: AppColors.textSecondary,
                    onTap: () => Get.toNamed(AppRoutes.logbook),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.card_membership_outlined,
                    label: 'Licenses',
                    color: AppColors.warning,
                    onTap: () => Get.toNamed(AppRoutes.licenses),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _LicenseAlerts(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

class _LicenseAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final licCtrl = Get.find<LicenseController>();
    return Obx(() {
      final expiring = licCtrl.expiringLicenses;
      final expired = licCtrl.expiredLicenses;
      if (expiring.isEmpty && expired.isEmpty) {
        return const SizedBox.shrink();
      }
      return AppSectionCard(
        title: 'License Alerts',
        child: Column(
          children: [
            ...expired.map(
              (l) => _AlertTile(
                label: '${l.type} — ${l.number}',
                status: 'EXPIRED',
                color: AppColors.error,
              ),
            ),
            ...expiring.map(
              (l) => _AlertTile(
                label: '${l.type} — ${l.number}',
                status: '${l.daysUntilExpiry} days left',
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({
    required this.label,
    required this.status,
    required this.color,
  });
  final String label;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(label, style: AppTextStyles.titleSmall),
          ),
        ],
      ),
    );
  }
}
