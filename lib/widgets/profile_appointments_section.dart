import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/state/appointment_scope.dart';
import '../core/state/appointment_store.dart';
import '../core/state/lab_booking_scope.dart';
import '../core/state/lab_booking_store.dart';
import '../models/appointment.dart';
import '../models/lab_booking.dart';
import 'appointment_details_sheet.dart';
import 'empty_state_card.dart';
import 'lab_booking_card.dart';
import 'lab_booking_details_sheet.dart';
import 'profile_appointment_card.dart';
import 'section_header.dart';

/// Upcoming/previous appointment tabs shown inside the profile screen.
class ProfileAppointmentsSection extends StatefulWidget {
  const ProfileAppointmentsSection({super.key});

  @override
  State<ProfileAppointmentsSection> createState() =>
      _ProfileAppointmentsSectionState();
}

class _ProfileAppointmentsSectionState extends State<ProfileAppointmentsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmCancel(Appointment appointment) async {
    final AppointmentStore store = AppointmentScope.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.cancelAppointmentTitle),
          content: Text(
            'This will release your slot with ${appointment.doctor.name}. '
            'You can book a new consultation any time.',
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.keepAppointment),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.danger,
                backgroundColor: AppColors.danger.withValues(alpha: 0.08),
              ),
              child: const Text(AppStrings.cancelAppointment),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      store.cancel(appointment.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.appointmentCancelled)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppointmentStore store = AppointmentScope.of(context);
    final LabBookingStore labStore = LabBookingScope.of(context);
    final bool showUpcoming = _tabController.index == 0;
    final List<Appointment> appointments = showUpcoming
        ? store.upcoming
        : store.previous;
    final List<LabBooking> labBookings = showUpcoming
        ? labStore.upcoming
        : labStore.previous;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primaryDeep.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.primaryDeep,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
            tabs: const <Widget>[
              Tab(
                key: Key('profile_tab_upcoming'),
                height: 36,
                text: AppStrings.upcomingTab,
              ),
              Tab(
                key: Key('profile_tab_previous'),
                height: 36,
                text: AppStrings.previousTab,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Column(
            key: ValueKey<bool>(showUpcoming),
            children: <Widget>[
              if (appointments.isEmpty && labBookings.isEmpty)
                EmptyStateCard(
                  icon: showUpcoming
                      ? Icons.event_available_outlined
                      : Icons.history_rounded,
                  title: showUpcoming
                      ? AppStrings.emptyUpcomingTitle
                      : AppStrings.emptyPreviousTitle,
                  message: showUpcoming
                      ? AppStrings.emptyUpcomingBody
                      : AppStrings.emptyPreviousBody,
                )
              else
                for (final Appointment appointment in appointments)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ProfileAppointmentCard(
                      appointment: appointment,
                      onViewDetails: () =>
                          showAppointmentDetails(context, appointment),
                      onCancel: showUpcoming
                          ? () => _confirmCancel(appointment)
                          : null,
                    ),
                  ),
              if (labBookings.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                SectionHeader(
                  title: showUpcoming
                      ? AppStrings.labUpcomingBookingsTitle
                      : AppStrings.labPreviousBookingsTitle,
                ),
                const SizedBox(height: 10),
                for (final LabBooking booking in labBookings)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LabBookingCard(
                      booking: booking,
                      keyPrefix: 'profile_lab',
                      onViewDetails: () =>
                          showLabBookingDetails(context, booking),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
