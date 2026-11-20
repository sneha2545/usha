import 'doctor.dart';

/// How a consultation with a doctor takes place.
enum AppointmentMode { video, inClinic }

extension AppointmentModeLabel on AppointmentMode {
  String get label {
    switch (this) {
      case AppointmentMode.video:
        return 'Doctor appointment';
      case AppointmentMode.inClinic:
        return 'In-clinic visit';
    }
  }

  bool get isVideo => this == AppointmentMode.video;
}

/// Lifecycle state of a booking.
enum AppointmentStatus { confirmed, completed, cancelled }

extension AppointmentStatusLabel on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// A scheduled consultation shown in the appointments modules.
class Appointment {
  const Appointment({
    required this.id,
    required this.doctor,
    required this.scheduledAt,
    required this.mode,
    this.status = AppointmentStatus.confirmed,
    this.notes,
  });

  final String id;
  final Doctor doctor;
  final DateTime scheduledAt;
  final AppointmentMode mode;
  final AppointmentStatus status;
  final String? notes;

  bool get isUpcoming =>
      status == AppointmentStatus.confirmed &&
      scheduledAt.isAfter(DateTime.now());

  bool get canCancel =>
      status == AppointmentStatus.confirmed &&
      scheduledAt.isAfter(DateTime.now());

  Appointment copyWith({AppointmentStatus? status}) {
    return Appointment(
      id: id,
      doctor: doctor,
      scheduledAt: scheduledAt,
      mode: mode,
      status: status ?? this.status,
      notes: notes,
    );
  }
}
