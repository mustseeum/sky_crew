import 'package:flutter/material.dart';

import '../../../domain/entities/flight_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../utils/helpers/date_time_helper.dart';

/// Displays a single flight record in a list tile.
class FlightRecordCard extends StatelessWidget {
  const FlightRecordCard({
    super.key,
    required this.record,
    this.onTap,
    this.onDelete,
  });

  final FlightRecord record;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Route badge
                  _RouteBadge(
                    from: record.departureAirport,
                    to: record.arrivalAirport,
                  ),
                  const Spacer(),
                  Text(
                    DateTimeHelper.formatDate(record.date),
                    style: AppTextStyles.bodySmall,
                  ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: AppColors.error,
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.airplanemode_active,
                    label: record.flightNumber,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.flight_class,
                    label: record.aircraftType,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.access_time,
                    label: DateTimeHelper.formatMinutes(record.blockTimeMinutes),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    record.role,
                    style: AppTextStyles.labelMedium,
                  ),
                  if (record.landings > 0) ...[
                    const SizedBox(width: 12),
                    Text(
                      '${record.landings} ldg',
                      style: AppTextStyles.labelMedium,
                    ),
                  ],
                  if (record.isOffDuty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'OFF DUTY',
                        style: AppTextStyles.labelSmall,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteBadge extends StatelessWidget {
  const _RouteBadge({required this.from, required this.to});

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(from,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.primary,
            )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.arrow_forward, size: 14, color: AppColors.textHint),
        ),
        Text(to,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            )),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
