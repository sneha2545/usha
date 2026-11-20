import 'package:flutter_test/flutter_test.dart';
import 'package:usha/core/data/demo_data.dart';
import 'package:usha/core/state/appointment_store.dart';
import 'package:usha/models/appointment.dart';
import 'package:usha/models/doctor.dart';

void main() {
  group('AppointmentStore booking', () {
    final DateTime now = DateTime(2026, 11, 21, 8);
    final Doctor doctor = DemoData.doctors.first;
    final DateTime futureSlot = DateTime(2026, 11, 22, 10, 30);

    Appointment createAppointment({
      required String id,
      required DateTime scheduledAt,
      Doctor? withDoctor,
      AppointmentStatus status = AppointmentStatus.confirmed,
    }) {
      return Appointment(
        id: id,
        doctor: withDoctor ?? doctor,
        scheduledAt: scheduledAt,
        mode: AppointmentMode.video,
        status: status,
      );
    }

    AppointmentStore createStore({
      List<Appointment> upcoming = const <Appointment>[],
      List<Appointment> previous = const <Appointment>[],
    }) {
      return AppointmentStore(
        upcoming: upcoming,
        previous: previous,
        clock: () => now,
      );
    }

    test('adds a valid appointment and notifies listeners', () {
      final AppointmentStore store = createStore();
      int notifications = 0;
      store.addListener(() => notifications++);

      final Appointment appointment = createAppointment(
        id: 'booking-1',
        scheduledAt: futureSlot,
      );

      expect(store.addUpcoming(appointment), isTrue);
      expect(store.upcoming, <Appointment>[appointment]);
      expect(notifications, 1);
    });

    test('rejects a past appointment time', () {
      final AppointmentStore store = createStore();
      final Appointment appointment = createAppointment(
        id: 'booking-past',
        scheduledAt: DateTime(2026, 11, 21, 7, 59),
      );

      expect(store.addUpcoming(appointment), isFalse);
      expect(store.upcoming, isEmpty);
    });

    test('rejects a duplicate active doctor and time slot', () {
      final Appointment existing = createAppointment(
        id: 'booking-existing',
        scheduledAt: futureSlot,
      );
      final AppointmentStore store = createStore(
        upcoming: <Appointment>[existing],
      );
      int notifications = 0;
      store.addListener(() => notifications++);

      expect(
        store.addUpcoming(
          createAppointment(id: 'booking-duplicate', scheduledAt: futureSlot),
        ),
        isFalse,
      );
      expect(store.upcoming, <Appointment>[existing]);
      expect(notifications, 0);
    });

    test('allows the same time for a different doctor', () {
      final AppointmentStore store = createStore(
        upcoming: <Appointment>[
          createAppointment(id: 'booking-existing', scheduledAt: futureSlot),
        ],
      );

      expect(
        store.addUpcoming(
          createAppointment(
            id: 'booking-other-doctor',
            scheduledAt: futureSlot,
            withDoctor: DemoData.doctors[1],
          ),
        ),
        isTrue,
      );
      expect(store.upcoming, hasLength(2));
    });

    test('cancellation notifies listeners and releases its slot', () {
      final Appointment existing = createAppointment(
        id: 'booking-to-cancel',
        scheduledAt: futureSlot,
      );
      final AppointmentStore store = createStore(
        upcoming: <Appointment>[existing],
      );
      int notifications = 0;
      store.addListener(() => notifications++);

      store.cancel(existing.id);

      expect(store.upcoming, isEmpty);
      expect(store.previous.single.status, AppointmentStatus.cancelled);
      expect(notifications, 1);
      expect(
        store.addUpcoming(
          createAppointment(id: 'booking-rebooked', scheduledAt: futureSlot),
        ),
        isTrue,
      );
      expect(notifications, 2);
    });

    test('does not add the same appointment id twice', () {
      final AppointmentStore store = createStore();
      final Appointment appointment = createAppointment(
        id: 'booking-same-id',
        scheduledAt: futureSlot,
      );

      expect(store.addUpcoming(appointment), isTrue);
      expect(store.addUpcoming(appointment), isFalse);
      expect(store.upcoming, hasLength(1));
    });
  });
}
