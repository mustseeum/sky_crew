import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sky_crew/app/routes/app_routes.dart';
import 'package:sky_crew/presentation/controllers/logbook_controller.dart';
import 'package:sky_crew/presentation/theme/app_colors.dart';
import 'package:sky_crew/presentation/theme/app_text_styles.dart';
import 'package:sky_crew/presentation/widgets/common/custom_appbar.dart';
import 'package:sky_crew/presentation/widgets/common/responsive_content.dart';
import 'package:sky_crew/presentation/widgets/logbook/flight_record_card.dart';
import 'package:sky_crew/presentation/widgets/logbook/summary_card.dart';

/// Logbook list screen.
class LogbookView extends GetView<LogbookController> {
  const LogbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Logbook',
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export',
            onPressed: () => _showExportOptions(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.records.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flight_outlined,
                    size: 64, color: AppColors.textHint),
                const SizedBox(height: 12),
                Text('No flight records yet',
                    style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text(
                  'Tap + to log your first flight',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final useTwoColumns = constraints.maxWidth >= 1080;

            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ResponsiveContent(
                maxWidth: 1280,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: useTwoColumns
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.summary.value != null)
                            Flexible(
                              flex: 4,
                              child: SummaryCard(
                                summary: controller.summary.value!,
                              ),
                            ),
                          if (controller.summary.value != null)
                            const SizedBox(width: 20),
                          Expanded(
                            flex: 7,
                            child: _RecordsSection(
                              records: controller.records,
                              onDelete: (id) => _confirmDelete(context, id),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.summary.value != null)
                            SummaryCard(summary: controller.summary.value!),
                          if (controller.summary.value != null)
                            const SizedBox(height: 20),
                          _RecordsSection(
                            records: controller.records,
                            onDelete: (id) => _confirmDelete(context, id),
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'logbook_fab',
        onPressed: () {
          controller.clearSelectedRecord();
          Get.toNamed(AppRoutes.addFlight);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('Export as PDF'),
              onTap: () async {
                Get.back();
                final path = await controller.exportToPDF();
                if (path != null) {
                  final msg = kIsWeb
                      ? 'PDF downloaded to your browser'
                      : 'PDF saved to $path';
                  Get.snackbar('Exported', msg,
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Export as CSV'),
              onTap: () async {
                Get.back();
                final path = await controller.exportToCSV();
                if (path != null) {
                  final msg = kIsWeb
                      ? 'CSV downloaded to your browser'
                      : 'CSV saved to $path';
                  Get.snackbar('Exported', msg,
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
          ],
        ),
      ),
    );
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
            onPressed: () {
              Get.back();
              controller.deleteRecord(id);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsSection extends StatelessWidget {
  const _RecordsSection({
    required this.records,
    required this.onDelete,
  });

  final List<dynamic> records;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Flight Records', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 12),
        ...records.map(
          (record) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FlightRecordCard(
              record: record,
              onTap: () {
                final controller = Get.find<LogbookController>();
                controller.selectRecord(record);
                Get.toNamed(AppRoutes.flightDetail);
              },
              onDelete: () => onDelete(record.id),
            ),
          ),
        ),
      ],
    );
  }
}
