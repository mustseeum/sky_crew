import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sky_crew/domain/entities/license.dart';
import 'package:sky_crew/utils/helpers/date_time_helper.dart';
import 'package:sky_crew/presentation/controllers/license_controller.dart';
import 'package:sky_crew/presentation/theme/app_colors.dart';
import 'package:sky_crew/presentation/theme/app_text_styles.dart';
import 'package:sky_crew/presentation/widgets/common/app_button.dart';
import 'package:sky_crew/presentation/widgets/common/app_card.dart';
import 'package:sky_crew/presentation/widgets/common/app_text_field.dart';
import 'package:sky_crew/presentation/widgets/common/custom_appbar.dart';
import 'package:sky_crew/presentation/widgets/common/responsive_content.dart';

/// Licenses & currency tracking screen.
class LicensesView extends GetView<LicenseController> {
  const LicensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Licenses & Currency'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.licenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.card_membership_outlined,
                    size: 64, color: AppColors.textHint),
                const SizedBox(height: 12),
                Text('licenses_empty'.tr,
                    style: AppTextStyles.headlineSmall
                        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text(
                  'licenses_empty_hint'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withAlpha(153)),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final useGrid = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              child: ResponsiveContent(
                maxWidth: 1200,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: useGrid
                    ? Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: controller.licenses.map((license) {
                          final cardWidth = (constraints.maxWidth > 1200
                                  ? 1200
                                  : constraints.maxWidth) /
                              2 - 22;
                          return SizedBox(
                            width: cardWidth,
                            child: _LicenseCard(
                              license: license,
                              onDelete: () =>
                                  _confirmDelete(context, license.id),
                            ),
                          );
                        }).toList(),
                      )
                    : Column(
                        children: controller.licenses
                            .map(
                              (license) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _LicenseCard(
                                  license: license,
                                  onDelete: () =>
                                      _confirmDelete(context, license.id),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'licenses_fab',
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete License'),
        content: const Text('Remove this license from your records?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteLicense(id);
            },
            child: Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final typeCtrl = TextEditingController();
    final numberCtrl = TextEditingController();
    final authorityCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Text('Add License', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              AppTextField(
                label: 'License Type',
                hint: 'e.g. ATPL, CPL, Medical',
                controller: typeCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v?.isEmpty == true ? 'Required' : null,
                onChanged: (v) => controller.formType.value = v,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'License Number',
                controller: numberCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v?.isEmpty == true ? 'Required' : null,
                onChanged: (v) => controller.formNumber.value = v,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Issuing Authority',
                hint: 'e.g. CAAV, EASA',
                controller: authorityCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v?.isEmpty == true ? 'Required' : null,
                onChanged: (v) =>
                    controller.formIssuingAuthority.value = v,
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final useWideDates = constraints.maxWidth >= 520;
                  final issueField = Obx(() => AppTextField(
                        label: 'Issue Date',
                        readOnly: true,
                        initialValue: controller.formIssueDate.value,
                        prefixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 16),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            controller.formIssueDate.value =
                                picked.toIso8601String().substring(0, 10);
                          }
                        },
                      ));
                  final expiryField = Obx(() => AppTextField(
                        label: 'Expiry Date',
                        readOnly: true,
                        initialValue: controller.formExpiryDate.value,
                        prefixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 16),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 365)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.formExpiryDate.value =
                                picked.toIso8601String().substring(0, 10);
                          }
                        },
                      ));

                  if (useWideDates) {
                    return Row(
                      children: [
                        Expanded(child: issueField),
                        const SizedBox(width: 12),
                        Expanded(child: expiryField),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      issueField,
                      const SizedBox(height: 12),
                      expiryField,
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Obx(() => AppFullWidthButton(
                    label: 'Add License',
                    isLoading: controller.isLoading.value,
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        if (controller.formIssueDate.value.isEmpty ||
                            controller.formExpiryDate.value.isEmpty) {
                          Get.snackbar('Error', 'Please select dates.',
                              snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        final success = await controller.addLicense();
                        if (success) Get.back();
                      }
                    },
                  )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LicenseCard extends StatelessWidget {
  const _LicenseCard({required this.license, this.onDelete});

  final License license;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;

    switch (license.status) {
      case LicenseStatus.expired:
        statusColor = AppColors.error;
        statusLabel = 'Expired';
        break;
      case LicenseStatus.expiringSoon:
        statusColor = AppColors.warning;
        statusLabel = '${license.daysUntilExpiry}d left';
        break;
      case LicenseStatus.valid:
        statusColor = AppColors.success;
        statusLabel = 'Valid';
        break;
    }

    return AppCard(
      borderColor: statusColor.withAlpha(80),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: statusColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.card_membership,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(license.type, style: AppTextStyles.titleMedium),
                Text(license.number, style: AppTextStyles.bodySmall),
                Text(
                  'Expires ${DateTimeHelper.formatDate(license.expiryDate)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: statusColor),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 16),
                  color: AppColors.error,
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
