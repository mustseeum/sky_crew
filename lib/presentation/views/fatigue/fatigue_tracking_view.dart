import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/date_time_helper.dart';
import '../../controllers/fatigue_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/custom_appbar.dart';

/// Fatigue & wellness tracking screen.
class FatigueTrackingView extends GetView<FatigueController> {
  const FatigueTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Wellness & Fatigue'),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick stats row
                Obx(() => Row(
                      children: [
                        _StatTile(
                          label: 'Avg Fatigue',
                          value: controller.averageFatigue
                              .toStringAsFixed(1),
                          icon: Icons.psychology_outlined,
                          color: _fatigueColor(
                              controller.averageFatigue.round()),
                        ),
                        const SizedBox(width: 10),
                        _StatTile(
                          label: 'Avg Sleep',
                          value:
                              '${controller.averageSleep.toStringAsFixed(1)}h',
                          icon: Icons.bedtime_outlined,
                          color: controller.averageSleep < 6
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                        const SizedBox(width: 10),
                        _StatTile(
                          label: 'High Fatigue',
                          value: controller.highFatigueCount.toString(),
                          icon: Icons.warning_amber_outlined,
                          color: AppColors.error,
                        ),
                      ],
                    )),
                const SizedBox(height: 16),

                // Chart
                Obx(() {
                  if (controller.entries.length < 2) {
                    return const SizedBox.shrink();
                  }
                  return AppSectionCard(
                    title: 'Fatigue Trend (Last 14 days)',
                    child: SizedBox(
                      height: 160,
                      child: _FatigueChart(
                        entries: controller.entries.take(14).toList(),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Add entry button
                AppFullWidthButton(
                  label: 'Log Today\'s Wellness',
                  icon: Icons.add,
                  onPressed: () => _showAddSheet(context),
                ),
                const SizedBox(height: 16),

                Text('History', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 10),
              ]),
            ),
          ),
          Obx(() {
            if (controller.entries.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No entries yet. Log your first wellness check-in.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textHint),
                    ),
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList.separated(
                itemCount: controller.entries.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = controller.entries[index];
                  return _EntryCard(
                    entry: entry,
                    onDelete: () => controller.deleteEntry(entry.id),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _fatigueColor(int score) {
    if (score <= 3) return AppColors.success;
    if (score <= 6) return AppColors.warning;
    return AppColors.error;
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Log Wellness', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),

            // Fatigue score
            Text('Fatigue Level', style: AppTextStyles.titleMedium),
            const SizedBox(height: 4),
            Text('1 = Fully Rested  |  10 = Extremely Fatigued',
                style: AppTextStyles.caption),
            Obx(() => Slider(
                  min: 1,
                  max: 10,
                  divisions: 9,
                  value: controller.formFatigueScore.value.toDouble(),
                  label: controller.formFatigueScore.value.toString(),
                  activeColor: _fatigueColor(
                      controller.formFatigueScore.value),
                  onChanged: (v) =>
                      controller.formFatigueScore.value = v.round(),
                )),

            // Sleep hours
            const SizedBox(height: 8),
            Text('Sleep Hours', style: AppTextStyles.titleMedium),
            Obx(() => Slider(
                  min: 0,
                  max: 12,
                  divisions: 24,
                  value: controller.formSleepHours.value,
                  label:
                      '${controller.formSleepHours.value.toStringAsFixed(1)}h',
                  activeColor: controller.formSleepHours.value < 6
                      ? AppColors.warning
                      : AppColors.primary,
                  onChanged: (v) => controller.formSleepHours.value = v,
                )),

            const SizedBox(height: 16),
            Obx(() => AppFullWidthButton(
                  label: 'Save Entry',
                  isLoading: controller.isLoading.value,
                  onPressed: () async {
                    final success = await controller.addEntry();
                    if (success) Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value,
                style: AppTextStyles.titleMedium.copyWith(color: color)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, this.onDelete});

  final dynamic entry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final score = entry.fatigueScore as int;
    Color scoreColor;
    if (score <= 3) {
      scoreColor = AppColors.success;
    } else if (score <= 6) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }

    return AppCard(
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: scoreColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                score.toString(),
                style: AppTextStyles.headlineMedium
                    .copyWith(color: scoreColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateTimeHelper.formatDate(entry.date as DateTime),
                  style: AppTextStyles.titleMedium,
                ),
                Text(
                  'Sleep: ${(entry.sleepHours as double).toStringAsFixed(1)}h  •  Fatigue: $score/10',
                  style: AppTextStyles.bodySmall,
                ),
                if (entry.notes != null)
                  Text(
                    entry.notes as String,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: AppColors.error,
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}

class _FatigueChart extends StatelessWidget {
  const _FatigueChart({required this.entries});

  final List<dynamic> entries;

  @override
  Widget build(BuildContext context) {
    final reversed = entries.reversed.toList();
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (v) => FlLine(
            color: AppColors.outline,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (v, _) => Text(
                v.toInt().toString(),
                style: AppTextStyles.caption,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < reversed.length; i++)
                FlSpot(
                  i.toDouble(),
                  (reversed[i].fatigueScore as int).toDouble(),
                ),
            ],
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: 3,
                color: AppColors.primary,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withAlpha(30),
            ),
          ),
        ],
      ),
    );
  }
}
