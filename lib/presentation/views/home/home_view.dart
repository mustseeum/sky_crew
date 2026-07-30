import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sky_crew/app/routes/app_routes.dart';
import 'package:sky_crew/presentation/controllers/auth_controller.dart';
import 'package:sky_crew/presentation/controllers/license_controller.dart';
import 'package:sky_crew/presentation/controllers/logbook_controller.dart';
import 'package:sky_crew/presentation/controllers/navigation_controller.dart';
import 'package:sky_crew/presentation/theme/app_colors.dart';
import 'package:sky_crew/presentation/theme/app_text_styles.dart';
import 'package:sky_crew/presentation/widgets/common/app_card.dart';
import 'package:sky_crew/presentation/widgets/logbook/summary_card.dart';
import 'package:sky_crew/presentation/views/fatigue/fatigue_tracking_view.dart';
import 'package:sky_crew/presentation/views/licenses/licenses_view.dart';
import 'package:sky_crew/presentation/views/logbook/logbook_view.dart';
import 'package:sky_crew/presentation/views/profile/profile_view.dart';

/// Home/dashboard screen with role-specific quick stats and bottom navigation.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const double _wideLayoutBreakpoint = 960;
  static const double _contentMaxWidth = 1360;

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
      final destinations = [
        _ShellDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: 'nav_home'.tr,
        ),
        _ShellDestination(
          icon: Icons.menu_book_outlined,
          selectedIcon: Icons.menu_book,
          label: 'nav_logbook'.tr,
        ),
        _ShellDestination(
          icon: Icons.card_membership_outlined,
          selectedIcon: Icons.card_membership,
          label: 'nav_licenses'.tr,
        ),
        _ShellDestination(
          icon: Icons.monitor_heart_outlined,
          selectedIcon: Icons.monitor_heart,
          label: 'nav_wellness'.tr,
        ),
        _ShellDestination(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'nav_profile'.tr,
        ),
      ];

      final content = IndexedStack(
        index: nav.selectedIndex.value,
        children: pages,
      );

      return LayoutBuilder(
        builder: (context, constraints) {
          final useWideLayout = constraints.maxWidth >= _wideLayoutBreakpoint;
          if (!useWideLayout) {
            return Scaffold(
              body: content,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: nav.selectedIndex.value,
                onTap: nav.setIndex,
                items: destinations
                    .map(
                      (destination) => BottomNavigationBarItem(
                        icon: Icon(destination.icon),
                        activeIcon: Icon(destination.selectedIcon),
                        label: destination.label,
                      ),
                    )
                    .toList(),
              ),
            );
          }

          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: nav.selectedIndex.value,
                    onDestinationSelected: nav.setIndex,
                    labelType: NavigationRailLabelType.all,
                    minWidth: 88,
                    minExtendedWidth: 220,
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.flight,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('SkyCrew', style: AppTextStyles.titleLarge),
                        ],
                      ),
                    ),
                    destinations: destinations
                        .map(
                          (destination) => NavigationRailDestination(
                            icon: Icon(destination.icon),
                            selectedIcon: Icon(destination.selectedIcon),
                            label: Text(destination.label),
                          ),
                        )
                        .toList(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _contentMaxWidth,
                        ),
                        child: content,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  static const double _quickActionBreakpoint = 720;

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final logbook = Get.find<LogbookController>();

    return Scaffold(
      appBar: AppBar(
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
                    .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wideCards = constraints.maxWidth >= _quickActionBreakpoint;
            final cardWidth = wideCards
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

            return Column(
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: cardWidth,
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
                    SizedBox(
                      width: cardWidth,
                      child: _QuickActionCard(
                        icon: Icons.monitor_heart_outlined,
                        label: 'Log Wellness',
                        color: AppColors.tertiary,
                        onTap: () => Get.toNamed(AppRoutes.fatigueTracking),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _QuickActionCard(
                        icon: Icons.menu_book_outlined,
                        label: 'Logbook',
                        color: AppColors.primary,
                        onTap: () => Get.toNamed(AppRoutes.logbook),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
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
            );
          },
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
