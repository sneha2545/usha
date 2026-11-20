import 'package:material_ui/material_ui.dart';

import '../../models/appointment.dart';
import '../data/demo_data.dart';

/// Session-scoped appointment data, kept separate from patient information.
///
/// Cancelling moves a booking into the previous list with a cancelled status.
class AppointmentStore extends ChangeNotifier {
  AppointmentStore({
    List<Appointment>? upcoming,
    List<Appointment>? previous,
    DateTime Function()? clock,
  })  : _upcoming = List<Appointment>.of(
          upcoming ?? DemoData.upcomingAppointments,
        ),
        _previous = List<Appointment>.of(
          previous ?? DemoData.pastAppointments,
        ),
        _clock = clock ?? DateTime.now;

  final List<Appointment> _upcoming;
  final List<Appointment> _previous;
  final DateTime Function() _clock;

  List<Appointment> get upcoming => List<Appointment>.unmodifiable(_upcoming);

  List<Appointment> get previous => List<Appointment>.unmodifiable(_previous);

  DateTime get currentTime => _clock();

  bool isSlotAvailable(String doctorId, DateTime scheduledAt) {
    if (!scheduledAt.isAfter(_clock())) {
      return false;
    }

    return !_upcoming.any(
      (Appointment appointment) =>
           appointment.status == AppointmentStatus.confirmed &&
           appointment.doctor.id == doctorId &&
           appointment.scheduledAt.isAtSameMomentAs(scheduledAt),
    );
  }

  void cancel(String appointmentId) {
    final int index = _upcoming.indexWhere(
      (Appointment appointment) => appointment.id == appointmentId,
    );
    if (index == -1) {
      return;
    }
    final Appointment cancelled = _upcoming.removeAt(index).copyWith(
      status: AppointmentStatus.cancelled,
    );
    _previous.insert(0, cancelled);
    notifyListeners();
  }

  bool addUpcoming(Appointment appointment) {
    final bool hasExistingId = _upcoming.any(
          (Appointment existing) => existing.id == appointment.id,
        ) ||
        _previous.any(
          (Appointment existing) => existing.id == appointment.id,
        );
    if (appointment.status != AppointmentStatus.confirmed ||
        hasExistingId ||
        !isSlotAvailable(appointment.doctor.id, appointment.scheduledAt)) {
      return false;
    }

    _upcoming.add(appointment);
    notifyListeners();
    return true;
  }
}
