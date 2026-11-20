import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_formatter.dart';
import '../models/lab_booking.dart';
import 'app_surface_card.dart';

/// Compact summary for a laboratory booking in either history list.
class LabBookingCard extends StatelessWidget {
  const LabBookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
    required this.keyPrefix,
  });

  final LabBooking booking;
  final VoidCallback onViewDetails;
  final String keyPrefix;

  Color get _statusColor {
    switch (booking.status) {
      case LabBookingStatus.confirmed:
        return AppColors.primaryDeep;
      case LabBookingStatus.completed:
        return AppColors.success;
      case LabBookingStatus.cancelled:
        return AppColors.danger;
    }
  }

  Color get _statusBackground {
    switch (booking.status) {
      case LabBookingStatus.confirmed:
        return AppColors.primarySoft;
      case LabBookingStatus.completed:
        return AppColors.success.withValues(alpha: 0.1);
      case LabBookingStatus.cancelled:
        return AppColors.danger.withValues(alpha: 0.08);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppSurfaceCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      onTap: onViewDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.biotech_outlined,
                  color: AppColors.primaryDeep,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      booking.laboratoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      booking.laboratoryLocation,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBackground,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  booking.status.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _statusColor,
                    fontSize: 9,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            booking.serviceName,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${booking.serviceType.label} · ${booking.priceLabel}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 12,
            runSpacing: 5,
            children: <Widget>[
              _BookingFact(
                icon: Icons.schedule_rounded,
                label:
                    '${AppDateFormatter.dayMonth(booking.scheduledAt)} · '
                    '${AppDateFormatter.time(booking.scheduledAt)}',
              ),
              _BookingFact(
                icon: booking.collectionMethod == LabCollectionMethod.labVisit
                    ? Icons.location_city_outlined
                    : Icons.home_outlined,
                label: booking.collectionMethod.label,
              ),
            ],
          ),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: Key('${keyPrefix}_details_${booking.id}'),
              onPressed: onViewDetails,
              child: const Text(AppStrings.viewDetails),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingFact extends StatelessWidget {
  const _BookingFact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: AppColors.secondary),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
