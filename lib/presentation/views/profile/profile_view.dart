import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/custom_appbar.dart';

/// User profile screen.
class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign Out',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        _initials(user.name),
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user.name, style: AppTextStyles.headlineMedium),
                    Text(user.email,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppSectionCard(
                title: 'Account Details',
                child: Column(
                  children: [
                    _ProfileRow(
                      icon: Icons.badge_outlined,
                      label: 'Employee ID',
                      value: user.employeeId ?? '—',
                    ),
                    _ProfileRow(
                      icon: Icons.business_outlined,
                      label: 'Airline',
                      value: user.airline ?? '—',
                    ),
                    _ProfileRow(
                      icon: Icons.location_on_outlined,
                      label: 'Base Airport',
                      value: user.baseAirport ?? '—',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              AppSectionCard(
                title: 'App Settings',
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.palette_outlined,
                          color: AppColors.textSecondary),
                      title: const Text('Theme'),
                      trailing: const Icon(Icons.chevron_right,
                          color: AppColors.textHint),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.notifications_outlined,
                          color: AppColors.textSecondary),
                      title: const Text('Notifications'),
                      trailing: const Icon(Icons.chevron_right,
                          color: AppColors.textHint),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.info_outline,
                          color: AppColors.textSecondary),
                      title: const Text('About SkyCrew'),
                      trailing: const Icon(Icons.chevron_right,
                          color: AppColors.textHint),
                      onTap: () => _showAbout(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppDangerButton(
                label: 'Sign Out',
                onPressed: () => _confirmLogout(context),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'SC';
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'SkyCrew',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 SkyCrew',
      children: const [
        SizedBox(height: 12),
        Text(
          'Professional flight crew management application for pilots, '
          'co-pilots, flight attendants, and supervisors.',
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: AppTextStyles.titleSmall),
        ],
      ),
    );
  }
}
