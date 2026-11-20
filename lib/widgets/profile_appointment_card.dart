import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_formatter.dart';
import '../models/appointment.dart';
import 'app_surface_card.dart';
import 'doctor_avatar.dart';

/// Appointment card used inside the profile history tabs.
class ProfileAppointmentCard extends StatelessWidget {
  const ProfileAppointmentCard({
    super.key,
    required this.appointment,
    required this.onViewDetails,
    this.onCancel,
  });

  final Appointment appointment;
  final VoidCallback onViewDetails;
  final VoidCallback? onCancel;

  Color get _statusColor {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return AppColors.primaryDeep;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.cancelled:
        return AppColors.danger;
    }
  }

  Color get _statusBackground {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return AppColors.primarySoft;
      case AppointmentStatus.completed:
        return AppColors.success.withValues(alpha: 0.1);
      case AppointmentStatus.cancelled:
        return AppColors.danger.withValues(alpha: 0.08);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime when = appointment.scheduledAt;

    return AppSurfaceCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DoctorAvatar(
                doctor: appointment.doctor,
                size: 48,
                showBadge: false,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appointment.doctor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appointment.doctor.specialty,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '${AppDateFormatter.dayMonth(when)} · '
                            '${AppDateFormatter.time(when)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusBackground,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  appointment.status.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              OutlinedButton(
                key: Key('profile_view_details_${appointment.id}'),
                onPressed: onViewDetails,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: const Text(AppStrings.viewDetails),
              ),
              if (onCancel != null && appointment.canCancel)
                TextButton(
                  key: Key('profile_cancel_${appointment.id}'),
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    minimumSize: const Size(0, 34),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text(AppStrings.cancelAppointment),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
