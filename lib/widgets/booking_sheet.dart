import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/data/demo_data.dart';
import '../core/state/appointment_scope.dart';
import '../core/state/appointment_store.dart';
import '../core/utils/date_formatter.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import 'app_surface_card.dart';
import 'doctor_avatar.dart';
import 'primary_button.dart';

/// Shows the appointment booking flow and saves a confirmed appointment.
Future<void> showBookingSheet(BuildContext context, {Doctor? doctor}) async {
  final AppointmentStore store = AppointmentScope.of(context);
  final Appointment? appointment = await showModalBottomSheet<Appointment>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext sheetContext) => BookingSheet(initialDoctor: doctor),
  );

  if (appointment == null || !context.mounted) {
    return;
  }

  final bool saved = store.addUpcoming(appointment);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        saved
            ? AppStrings.appointmentBooked
            : AppStrings.appointmentSlotUnavailable,
      ),
    ),
  );
}

/// Frontend-only booking sheet: choose a doctor, date and available time.
class BookingSheet extends StatefulWidget {
  const BookingSheet({super.key, this.initialDoctor});

  final Doctor? initialDoctor;

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  static const List<TimeOfDay> _timeSlots = <TimeOfDay>[
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 30),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 16, minute: 30),
    TimeOfDay(hour: 18, minute: 0),
  ];

  late Doctor _doctor;
  late final List<DateTime> _dates;
  bool _datesInitialized = false;
  int _selectedDate = 0;
  int? _selectedTime;

  @override
  void initState() {
    super.initState();
    _doctor = widget.initialDoctor ?? DemoData.doctors.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_datesInitialized) {
      return;
    }

    final AppointmentStore store = AppointmentScope.of(context);
    final DateTime now = store.currentTime;
    final DateTime today = DateTime(now.year, now.month, now.day);
    _dates = List<DateTime>.generate(
      3,
      (int index) => DateTime(today.year, today.month, today.day + index),
    );
    _selectedDate = _firstAvailableDateIndex(store, _doctor);
    _selectedTime = _firstAvailableTimeIndex(
      store,
      _doctor,
      _dates[_selectedDate],
    );
    _datesInitialized = true;
  }

  int _firstAvailableDateIndex(AppointmentStore store, Doctor doctor) {
    for (int dateIndex = 0; dateIndex < _dates.length; dateIndex++) {
      if (_firstAvailableTimeIndex(store, doctor, _dates[dateIndex]) != null) {
        return dateIndex;
      }
    }
    return 0;
  }

  int? _firstAvailableTimeIndex(
    AppointmentStore store,
    Doctor doctor,
    DateTime date,
  ) {
    for (int timeIndex = 0; timeIndex < _timeSlots.length; timeIndex++) {
      if (store.isSlotAvailable(
        doctor.id,
        _scheduledAt(date, _timeSlots[timeIndex]),
      )) {
        return timeIndex;
      }
    }
    return null;
  }

  DateTime _scheduledAt(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String _formatTime(DateTime date, TimeOfDay time) {
    return AppDateFormatter.time(_scheduledAt(date, time));
  }

  void _confirmBooking(AppointmentStore store, DateTime scheduledAt) {
    if (!store.isSlotAvailable(_doctor.id, scheduledAt)) {
      setState(() => _selectedTime = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.appointmentSlotUnavailable)),
      );
      return;
    }

    final Appointment appointment = Appointment(
      id: 'booking-${_doctor.id}-${DateTime.now().microsecondsSinceEpoch}',
      doctor: _doctor,
      scheduledAt: scheduledAt,
      mode: AppointmentMode.video,
      status: AppointmentStatus.confirmed,
    );
    Navigator.of(context).pop(appointment);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppointmentStore store = AppointmentScope.of(context);
    final int? selectedTimeIndex = _selectedTime;
    final DateTime? selectedDateTime = selectedTimeIndex == null
        ? null
        : _scheduledAt(_dates[_selectedDate], _timeSlots[selectedTimeIndex]);
    final DateTime? availableDateTime =
        selectedDateTime != null &&
            store.isSlotAvailable(_doctor.id, selectedDateTime)
        ? selectedDateTime
        : null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        4,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  size: 22,
                  color: AppColors.primaryDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.bookingTitle,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a specialist and a slot that works for you.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Text(AppStrings.chooseDoctor, style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<Doctor>(
            initialValue: _doctor,
            isExpanded: true,
            icon: const Icon(
              Icons.expand_more_rounded,
              color: AppColors.textSecondary,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            items: DemoData.doctors
                .map(
                  (Doctor doctor) => DropdownMenuItem<Doctor>(
                    value: doctor,
                    child: Text(
                      '${doctor.name} · ${doctor.specialty}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.5,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (Doctor? doctor) {
              if (doctor == null) {
                return;
              }
              final AppointmentStore store = AppointmentScope.of(context);
              final int selectedDate = _firstAvailableDateIndex(store, doctor);
              setState(() {
                _doctor = doctor;
                _selectedDate = selectedDate;
                _selectedTime = _firstAvailableTimeIndex(
                  store,
                  doctor,
                  _dates[selectedDate],
                );
              });
            },
          ),
          const SizedBox(height: 20),
          Text(AppStrings.chooseDate, style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              for (int index = 0; index < _dates.length; index++) ...<Widget>[
                if (index > 0) const SizedBox(width: 10),
                Expanded(
                  child: Builder(
                    builder: (BuildContext context) {
                      final bool hasAvailability =
                          _firstAvailableTimeIndex(
                            store,
                            _doctor,
                            _dates[index],
                          ) !=
                          null;
                      final bool isSelected = _selectedDate == index;
                      return _SelectableTile(
                        key: ValueKey<String>('booking_date_$index'),
                        isSelected: isSelected,
                        onTap: hasAvailability
                            ? () {
                                setState(() {
                                  _selectedDate = index;
                                  _selectedTime = _firstAvailableTimeIndex(
                                    store,
                                    _doctor,
                                    _dates[index],
                                  );
                                });
                              }
                            : null,
                        child: Column(
                          children: <Widget>[
                            Text(
                              index == 0
                                  ? 'Today'
                                  : index == 1
                                  ? 'Tomorrow'
                                  : AppDateFormatter.weekdayShort(
                                      _dates[index],
                                    ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                color: !hasAvailability
                                    ? AppColors.textSecondary.withValues(
                                        alpha: 0.55,
                                      )
                                    : isSelected
                                    ? AppColors.primaryDeep
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              AppDateFormatter.dayMonth(_dates[index]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: hasAvailability
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary.withValues(
                                        alpha: 0.55,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Text(AppStrings.chooseTime, style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          Builder(
            builder: (BuildContext context) {
              final List<int> availableTimeIndexes = <int>[
                for (int index = 0; index < _timeSlots.length; index++)
                  if (store.isSlotAvailable(
                    _doctor.id,
                    _scheduledAt(_dates[_selectedDate], _timeSlots[index]),
                  ))
                    index,
              ];

              if (availableTimeIndexes.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    AppStrings.noAvailableAppointmentSlots,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (int index = 0; index < _timeSlots.length; index++)
                    Builder(
                      builder: (BuildContext context) {
                        final bool isAvailable = availableTimeIndexes.contains(
                          index,
                        );
                        final bool isSelected = _selectedTime == index;
                        return _SelectableTile(
                          key: ValueKey<String>(
                            'booking_time_${_timeSlots[index].hour}_'
                            '${_timeSlots[index].minute}',
                          ),
                          isSelected: isSelected,
                          onTap: isAvailable
                              ? () => setState(() => _selectedTime = index)
                              : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Text(
                            _formatTime(
                              _dates[_selectedDate],
                              _timeSlots[index],
                            ),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: !isAvailable
                                  ? AppColors.textSecondary.withValues(
                                      alpha: 0.55,
                                    )
                                  : isSelected
                                  ? AppColors.primaryDeep
                                  : AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          AppSurfaceCard(
            showShadow: false,
            color: AppColors.primarySoft.withValues(alpha: 0.5),
            radius: 14,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.bookingReviewTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    DoctorAvatar(doctor: _doctor, size: 40, showBadge: false),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _doctor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _doctor.specialty,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _BookingSummaryRow(label: 'Clinic', value: _doctor.clinic),
                _BookingSummaryRow(
                  label: 'Date',
                  value: AppDateFormatter.fullDate(_dates[_selectedDate]),
                ),
                _BookingSummaryRow(
                  label: 'Time',
                  value: availableDateTime == null
                      ? 'Select an available time'
                      : AppDateFormatter.time(availableDateTime),
                ),
                _BookingSummaryRow(
                  label: AppStrings.consultationFeeLabel,
                  value: _doctor.feeLabel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            key: const Key('booking_confirm_button'),
            label: AppStrings.confirmBooking,
            onPressed: availableDateTime != null
                ? () => _confirmBooking(store, availableDateTime)
                : null,
          ),
        ],
      ),
    );
  }
}

class _BookingSummaryRow extends StatelessWidget {
  const _BookingSummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
  });

  final bool isSelected;
  final VoidCallback? onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;
    return Material(
      color: isSelected
          ? AppColors.primarySoft
          : isEnabled
          ? AppColors.surface
          : AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.border,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
