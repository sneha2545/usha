import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/state/appointment_scope.dart';
import '../../../core/state/lab_booking_scope.dart';
import '../../../core/state/lab_booking_store.dart';
import '../../../models/appointment.dart';
import '../../../models/lab_booking.dart';
import '../../../widgets/appointment_card.dart';
import '../../../widgets/appointment_details_sheet.dart';
import '../../../widgets/booking_sheet.dart';
import '../../../widgets/empty_state_card.dart';
import '../../../widgets/lab_booking_card.dart';
import '../../../widgets/lab_booking_details_sheet.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/section_header.dart';

/// Appointments overview with upcoming and past consultations.
class AppointmentsTab extends StatelessWidget {
  const AppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Appointment> upcoming = AppointmentScope.of(context).upcoming;
    final List<Appointment> previous = AppointmentScope.of(context).previous;
    final LabBookingStore labStore = LabBookingScope.of(context);
    final List<LabBooking> labUpcoming = labStore.upcoming;
    final List<LabBooking> labPrevious = labStore.previous;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.appointmentsTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 27),
                ),
                const SizedBox(height: 5),
                Text(
                  AppStrings.appointmentsSubtitle,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  key: const Key('appointments_book_button'),
                  label: AppStrings.bookNewAppointment,
                  icon: Icons.add_rounded,
                  height: 50,
                  onPressed: () => showBookingSheet(context),
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: AppStrings.upcomingAppointmentTitle),
                const SizedBox(height: 12),
                if (upcoming.isEmpty && labUpcoming.isEmpty)
                  const EmptyStateCard(
                    icon: Icons.event_available_outlined,
                    title: AppStrings.emptyUpcomingTitle,
                    message: AppStrings.emptyUpcomingBody,
                  )
                else
                  for (final Appointment appointment in upcoming)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppointmentCard(
                        appointment: appointment,
                        onViewDetails: () =>
                            showAppointmentDetails(context, appointment),
                      ),
                    ),
                if (labUpcoming.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  const SectionHeader(
                    title: AppStrings.labUpcomingBookingsTitle,
                  ),
                  const SizedBox(height: 12),
                  for (final LabBooking booking in labUpcoming)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LabBookingCard(
                        booking: booking,
                        keyPrefix: 'appointments_lab',
                        onViewDetails: () =>
                            showLabBookingDetails(context, booking),
                      ),
                    ),
                ],
                const SizedBox(height: 24),
                const SectionHeader(title: 'Past consultations'),
                const SizedBox(height: 12),
                if (previous.isEmpty && labPrevious.isEmpty)
                  const EmptyStateCard(
                    icon: Icons.history_rounded,
                    title: AppStrings.emptyPreviousTitle,
                    message: AppStrings.emptyPreviousBody,
                  )
                else
                  for (final Appointment appointment in previous)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppointmentCard(
                        appointment: appointment,
                        onViewDetails: () =>
                            showAppointmentDetails(context, appointment),
                      ),
                    ),
                if (labPrevious.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  const SectionHeader(
                    title: AppStrings.labPreviousBookingsTitle,
                  ),
                  const SizedBox(height: 12),
                  for (final LabBooking booking in labPrevious)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LabBookingCard(
                        booking: booking,
                        keyPrefix: 'appointments_lab',
                        onViewDetails: () =>
                            showLabBookingDetails(context, booking),
                      ),
                    ),
                ],
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.shield_outlined,
                        size: 18,
                        color: AppColors.primaryDeep,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Consultation notes and prescriptions are shared '
                          'securely after every visit.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
