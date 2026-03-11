import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../utils/helpers/calculation_engine.dart';
import '../../../utils/helpers/date_time_helper.dart';

/// Displays aggregated logbook totals.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.summary,
  });

  final LogbookSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Logbook Summary', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total Flights',
                    value: summary.totalFlights.toString(),
                    icon: Icons.flight,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Total Block',
                    value: DateTimeHelper.formatMinutes(
                        summary.totalBlockMinutes),
                    icon: Icons.access_time,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Landings',
                    value: summary.totalLandings.toString(),
                    icon: Icons.flight_land,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: _PeriodStat(
                    label: 'This Month',
                    value: DateTimeHelper.formatMinutes(
                        summary.monthBlockMinutes),
                    compliant: summary.isMonthlyCompliant,
                  ),
                ),
                Expanded(
                  child: _PeriodStat(
                    label: 'This Year',
                    value: DateTimeHelper.formatMinutes(
                        summary.yearBlockMinutes),
                    compliant: summary.isYearlyCompliant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleMedium),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _PeriodStat extends StatelessWidget {
  const _PeriodStat({
    required this.label,
    required this.value,
    required this.compliant,
  });

  final String label;
  final String value;
  final bool compliant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(value, style: AppTextStyles.titleMedium),
            const SizedBox(width: 6),
            Icon(
              compliant ? Icons.check_circle_outline : Icons.warning_amber,
              size: 14,
              color: compliant ? AppColors.success : AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }
}
