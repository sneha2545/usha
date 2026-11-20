import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_formatter.dart';
import '../models/appointment.dart';
import 'app_surface_card.dart';
import 'doctor_avatar.dart';

/// Appointment summary with a working details action.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onViewDetails,
    this.showMode = true,
  });

  final Appointment appointment;
  final VoidCallback onViewDetails;
  final bool showMode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime when = appointment.scheduledAt;

    return AppSurfaceCard(
      onTap: onViewDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              DoctorAvatar(doctor: appointment.doctor, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appointment.doctor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      appointment.doctor.specialty,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${AppDateFormatter.dayMonth(when)} · '
                            '${AppDateFormatter.time(when)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10.5,
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
            ],
          ),
          if (showMode) ...<Widget>[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: appointment.mode == AppointmentMode.inClinic
                    ? AppColors.surfaceMuted
                    : AppColors.primarySoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    appointment.mode == AppointmentMode.inClinic
                        ? Icons.local_hospital_outlined
                        : Icons.medical_services_outlined,
                    size: 13,
                    color: appointment.mode == AppointmentMode.inClinic
                        ? AppColors.secondary
                        : AppColors.primaryDeep,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      appointment.mode.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10.5,
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              key: Key('appointment_details_${appointment.id}'),
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: const Text(AppStrings.viewDetails),
            ),
          ),
        ],
      ),
    );
  }
}
