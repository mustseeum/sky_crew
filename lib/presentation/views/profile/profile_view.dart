import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sky_crew/presentation/controllers/auth_controller.dart';
import 'package:sky_crew/presentation/controllers/settings_controller.dart';
import 'package:sky_crew/presentation/theme/app_colors.dart';
import 'package:sky_crew/presentation/theme/app_text_styles.dart';
import 'package:sky_crew/presentation/widgets/common/app_button.dart';
import 'package:sky_crew/presentation/widgets/common/app_card.dart';
import 'package:sky_crew/presentation/widgets/common/custom_appbar.dart';
import 'package:sky_crew/presentation/widgets/common/responsive_content.dart';

/// User profile screen.
class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'profile_title'.tr,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'sign_out'.tr,
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final useWideLayout = constraints.maxWidth >= 960;

            return SingleChildScrollView(
              child: ResponsiveContent(
                maxWidth: 1200,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: useWideLayout
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: _ProfileSummaryCard(user: user),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                _AccountDetailsCard(user: user),
                                const SizedBox(height: 16),
                                _SettingsCard(onShowAbout: () => _showAbout(context)),
                                const SizedBox(height: 24),
                                AppDangerButton(
                                  label: 'Sign Out',
                                  onPressed: () => _confirmLogout(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProfileSummaryCard(user: user),
                          const SizedBox(height: 24),
                          _AccountDetailsCard(user: user),
                          const SizedBox(height: 16),
                          _SettingsCard(onShowAbout: () => _showAbout(context)),
                          const SizedBox(height: 24),
                          AppDangerButton(
                            label: 'Sign Out',
                            onPressed: () => _confirmLogout(context),
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      }),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('sign_out'.tr),
        content: Text('sign_out_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              'sign_out'.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
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

String _profileInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
  return name.isNotEmpty ? name[0].toUpperCase() : 'SC';
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primary,
            child: Text(
              _profileInitials(user.name),
              style: AppTextStyles.headlineLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(user.name, style: AppTextStyles.headlineMedium),
          Text(
            user.email,
            style: AppTextStyles.bodyMedium
                .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role.displayName,
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDetailsCard extends StatelessWidget {
  const _AccountDetailsCard({required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'account_details'.tr,
      child: Column(
        children: [
          _ProfileRow(
            icon: Icons.badge_outlined,
            label: 'employee_id'.tr,
            value: user.employeeId ?? '—',
          ),
          _ProfileRow(
            icon: Icons.business_outlined,
            label: 'airline'.tr,
            value: user.airline ?? '—',
          ),
          _ProfileRow(
            icon: Icons.location_on_outlined,
            label: 'base_airport'.tr,
            value: user.baseAirport ?? '—',
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.onShowAbout});

  final VoidCallback onShowAbout;

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return AppSectionCard(
      title: 'app_settings'.tr,
      child: Column(
        children: [
          // ── Theme picker
          Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.palette_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                title: Text('theme'.tr),
                trailing: Text(
                  settings.themeModeLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                ),
                onTap: () => _showThemePicker(context, settings),
              )),
          // ── Language picker
          Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.language_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                title: Text('language'.tr),
                trailing: Text(
                  settings.localeLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                ),
                onTap: () => _showLanguagePicker(context, settings),
              )),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.info_outline,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: Text('about'.tr),
            trailing: Icon(Icons.chevron_right,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withAlpha(153)),
            onTap: onShowAbout,
          ),
        ],
      ),
    );
  }

  void _showThemePicker(
      BuildContext context, SettingsController settings) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text('theme'.tr, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 8),
                // Use RadioGroup (Flutter 3.32+) to avoid deprecated groupValue.
                RadioGroup<ThemeMode>(
                  groupValue: settings.themeMode.value,
                  onChanged: (v) {
                    if (v != null) {
                      settings.setThemeMode(v);
                      Get.back();
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final entry in [
                        (ThemeMode.system, 'theme_system'),
                        (ThemeMode.light, 'theme_light'),
                        (ThemeMode.dark, 'theme_dark'),
                      ])
                        RadioListTile<ThemeMode>(
                          value: entry.$1,
                          title: Text(entry.$2.tr),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            )),
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, SettingsController settings) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text('language'.tr, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 8),
                RadioGroup<Locale>(
                  groupValue: settings.locale.value,
                  onChanged: (v) {
                    if (v != null) {
                      settings.setLocale(v);
                      Get.back();
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final entry in [
                        (const Locale('en', 'US'), 'lang_english'),
                        (const Locale('id', 'ID'), 'lang_indonesian'),
                      ])
                        RadioListTile<Locale>(
                          value: entry.$1,
                          title: Text(entry.$2.tr),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            )),
      ),
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
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(value, style: AppTextStyles.titleSmall),
        ],
      ),
    );
  }
}
