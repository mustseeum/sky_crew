import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../utils/helpers/date_time_helper.dart';
import '../../controllers/logbook_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/custom_appbar.dart';

/// Detailed view for a single flight record.
class FlightDetailView extends GetView<LogbookController> {
  const FlightDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final record = controller.selectedRecord.value;
      if (record == null) {
        return const Scaffold(
          body: Center(child: Text('No record selected.')),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: record.flightNumber,
          subtitle: DateTimeHelper.formatDate(record.date),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Get.toNamed(AppRoutes.addFlight),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _confirmDelete(context, record.id),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route header
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(record.departureAirport,
                                style: AppTextStyles.displayMedium
                                    .copyWith(color: AppColors.primary)),
                            Text('Departure',
                                style: AppTextStyles.caption),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Icon(Icons.flight,
                                  color: AppColors.textHint),
                              Text(
                                DateTimeHelper.formatMinutes(
                                    record.blockTimeMinutes),
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(record.arrivalAirport,
                                style: AppTextStyles.displayMedium),
                            Text('Arrival', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Details
              AppSectionCard(
                title: 'Flight Details',
                child: Column(
                  children: [
                    _DetailRow('Aircraft Type', record.aircraftType),
                    _DetailRow('Registration', record.aircraftRegistration),
                    _DetailRow('Role', record.role),
                    _DetailRow(
                        'Date', DateTimeHelper.formatDate(record.date)),
                    if (record.isOffDuty)
                      _DetailRow('Status', 'Off Duty'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              AppSectionCard(
                title: 'Time Summary',
                child: Column(
                  children: [
                    _DetailRow('Block Time',
                        DateTimeHelper.formatMinutes(record.blockTimeMinutes)),
                    _DetailRow('Duty Time',
                        DateTimeHelper.formatMinutes(record.dutyTimeMinutes)),
                    _DetailRow('Night Time',
                        DateTimeHelper.formatMinutes(record.nightTimeMinutes)),
                    _DetailRow('Landings', record.landings.toString()),
                  ],
                ),
              ),

              if (record.remarks != null) ...[
                const SizedBox(height: 12),
                AppSectionCard(
                  title: 'Remarks',
                  child: Text(record.remarks!,
                      style: AppTextStyles.bodyMedium),
                ),
              ],
              const SizedBox(height: 24),
              AppFullWidthButton(
                label: 'Edit Flight',
                isOutlined: true,
                icon: Icons.edit_outlined,
                onPressed: () => Get.toNamed(AppRoutes.addFlight),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    });
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content:
            const Text('Are you sure you want to delete this flight record?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await controller.deleteRecord(id);
              if (success) Get.until((r) => r.settings.name == AppRoutes.logbook);
            },
            child: Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.titleSmall),
        ],
      ),
    );
  }
}
