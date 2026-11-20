import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/data/demo_data.dart';
import '../core/utils/date_formatter.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import 'app_surface_card.dart';
import 'doctor_profile_overview.dart';
import 'primary_button.dart';
import 'section_header.dart';

/// Opens the read-only appointment details sheet.
Future<void> showAppointmentDetails(
  BuildContext context,
  Appointment appointment,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext sheetContext) =>
        AppointmentDetailsSheet(appointment: appointment),
  );
}

/// Doctor profile and appointment details in a scrollable modal sheet.
class AppointmentDetailsSheet extends StatelessWidget {
  const AppointmentDetailsSheet({super.key, required this.appointment});

  final Appointment appointment;

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
    final DateTime when = appointment.scheduledAt;
    final Doctor doctor =
        DemoData.doctorById(appointment.doctor.id) ?? appointment.doctor;
    final String? notes = appointment.notes?.trim();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  AppStrings.doctorProfileTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              DoctorProfileOverview(doctor: doctor),
              const SizedBox(height: 20),
              const SectionHeader(
                title: AppStrings.appointmentDetailsTitle,
              ),
              const SizedBox(height: 10),
              AppSurfaceCard(
                radius: 18,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 8,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.fact_check_outlined,
                              size: 18,
                              color: AppColors.primaryDeep,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.bookingStatusLabel,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _statusBackground,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            appointment.status.label,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: _statusColor,
                                  letterSpacing: 0,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Date',
                      value: AppDateFormatter.fullDate(when),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.schedule_rounded,
                      label: 'Time',
                      value: AppDateFormatter.time(when),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: appointment.mode == AppointmentMode.inClinic
                          ? Icons.local_hospital_outlined
                          : Icons.medical_services_outlined,
                      label: 'Appointment type',
                      value: appointment.mode.label,
                    ),
                    if (notes != null && notes.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.appointmentNotesLabel,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notes,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.55),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: AppStrings.done,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryDeep),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
