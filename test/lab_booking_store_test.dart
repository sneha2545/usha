import 'package:flutter_test/flutter_test.dart';
import 'package:usha/core/data/demo_data.dart';
import 'package:usha/core/state/lab_booking_store.dart';
import 'package:usha/models/lab_availability_slot.dart';
import 'package:usha/models/lab_booking.dart';

void main() {
  group('LabBookingStore', () {
    final DateTime now = DateTime(2026, 11, 21, 8);
    final DateTime slot = DateTime(2026, 11, 21, 9);
    final String laboratoryId = DemoData.laboratories.first.id;

    LabBooking createBooking({
      String id = 'lab-booking-1',
      String? serviceId,
      DateTime? scheduledAt,
      LabBookingStatus status = LabBookingStatus.confirmed,
      LabCollectionMethod collectionMethod = LabCollectionMethod.labVisit,
      String? collectionAddress,
    }) {
      final laboratory = DemoData.laboratories.first;
      return LabBooking(
        id: id,
        laboratoryId: laboratory.id,
        laboratoryName: laboratory.name,
        laboratoryLocation:
            '${laboratory.address}, ${laboratory.locationLabel}',
        serviceType: LabBookingServiceType.diagnosticTest,
        serviceId: serviceId ?? laboratory.tests.first.id,
        serviceName: laboratory.tests.first.name,
        price: laboratory.tests.first.price,
        scheduledAt: scheduledAt ?? slot,
        collectionMethod: collectionMethod,
        collectionAddress: collectionAddress,
        status: status,
        createdAt: now,
      );
    }

    LabAvailabilitySlot createSlot({int capacity = 1}) {
      return LabAvailabilitySlot(
        laboratoryId: laboratoryId,
        weekdays: <int>[slot.weekday],
        hour: slot.hour,
        minute: slot.minute,
        capacity: capacity,
      );
    }

    LabBookingStore createStore({
      List<LabBooking> upcoming = const <LabBooking>[],
      List<LabBooking> previous = const <LabBooking>[],
      int capacity = 1,
      DateTime Function()? clock,
    }) {
      return LabBookingStore(
        upcoming: upcoming,
        previous: previous,
        availability: <LabAvailabilitySlot>[createSlot(capacity: capacity)],
        clock: clock ?? () => now,
      );
    }

    test('adds a valid lab visit and notifies listeners', () {
      final LabBookingStore store = createStore();
      addTearDown(store.dispose);
      int notifications = 0;
      store.addListener(() => notifications++);

      expect(store.addBooking(createBooking()), isTrue);
      expect(store.upcoming.single.id, 'lab-booking-1');
      expect(notifications, 1);
    });

    test('rejects past and unconfigured slots', () {
      final LabBookingStore store = createStore();
      addTearDown(store.dispose);

      expect(
        store.addBooking(
          createBooking(scheduledAt: DateTime(2026, 11, 21, 7, 59)),
        ),
        isFalse,
      );
      expect(
        store.isSlotAvailable(laboratoryId, DateTime(2026, 11, 21, 10)),
        isFalse,
      );
    });

    test('rejects bookings when the explicit slot capacity is full', () {
      final LabBookingStore store = createStore(capacity: 2);
      addTearDown(store.dispose);

      expect(
        store.addBooking(createBooking(id: 'capacity-1', serviceId: 'test-1')),
        isTrue,
      );
      expect(
        store.addBooking(createBooking(id: 'capacity-2', serviceId: 'test-2')),
        isTrue,
      );
      expect(store.reservationsForSlot(laboratoryId, slot), 2);
      expect(store.isSlotAvailable(laboratoryId, slot), isFalse);
      expect(store.addBooking(createBooking(id: 'capacity-3')), isFalse);
      expect(store.upcoming, hasLength(2));
    });

    test(
      'prevents duplicate booking IDs across active and previous history',
      () {
        final LabBookingStore store = createStore(
          previous: <LabBooking>[
            createBooking(
              id: 'existing-id',
              status: LabBookingStatus.cancelled,
            ),
          ],
        );
        addTearDown(store.dispose);

        expect(store.addBooking(createBooking(id: 'existing-id')), isFalse);
        expect(store.upcoming, isEmpty);
      },
    );

    test('rejects repeat submissions for the same service and slot', () {
      final LabBookingStore store = createStore(capacity: 3);
      addTearDown(store.dispose);

      expect(store.addBooking(createBooking(id: 'first-submission')), isTrue);
      expect(store.addBooking(createBooking(id: 'repeat-submission')), isFalse);
      expect(store.upcoming, hasLength(1));
    });

    test('cancellation moves booking to history and releases capacity', () {
      final LabBookingStore store = createStore(
        capacity: 1,
        upcoming: <LabBooking>[createBooking(id: 'cancel-me')],
      );
      addTearDown(store.dispose);
      int notifications = 0;
      store.addListener(() => notifications++);

      expect(store.cancel('cancel-me'), isTrue);
      expect(store.upcoming, isEmpty);
      expect(store.previous.single.status, LabBookingStatus.cancelled);
      expect(notifications, 1);
      expect(store.isSlotAvailable(laboratoryId, slot), isTrue);
    });

    test(
      'rejects home collection for unsupported labs and empty addresses',
      () {
        final laboratory = DemoData.laboratories.singleWhere(
          (lab) => !lab.supportsHomeSampleCollection,
        );
        final LabAvailabilitySlot unsupportedSlot = LabAvailabilitySlot(
          laboratoryId: laboratory.id,
          weekdays: <int>[slot.weekday],
          hour: slot.hour,
          minute: slot.minute,
          capacity: 2,
        );
        final LabBookingStore store = LabBookingStore(
          availability: <LabAvailabilitySlot>[unsupportedSlot],
          clock: () => now,
        );
        addTearDown(store.dispose);

        final LabBooking homeBooking = LabBooking(
          id: 'unsupported-home-booking',
          laboratoryId: laboratory.id,
          laboratoryName: laboratory.name,
          laboratoryLocation: laboratory.locationLabel,
          serviceType: LabBookingServiceType.diagnosticTest,
          serviceId: laboratory.tests.first.id,
          serviceName: laboratory.tests.first.name,
          price: laboratory.tests.first.price,
          scheduledAt: slot,
          collectionMethod: LabCollectionMethod.homeCollection,
          collectionAddress: '1 Demo Street',
          status: LabBookingStatus.confirmed,
          createdAt: now,
        );
        expect(store.addBooking(homeBooking), isFalse);

        final LabBookingStore supportedStore = createStore();
        addTearDown(supportedStore.dispose);
        expect(
          supportedStore.addBooking(
            createBooking(
              collectionMethod: LabCollectionMethod.homeCollection,
              collectionAddress: '  ',
            ),
          ),
          isFalse,
        );
      },
    );

    test('past confirmed records remain confirmed in previous history', () {
      final LabBookingStore store = createStore(
        upcoming: <LabBooking>[
          createBooking(scheduledAt: DateTime(2026, 11, 20, 9)),
        ],
      );
      addTearDown(store.dispose);

      expect(store.upcoming, isEmpty);
      expect(store.previous.single.status, LabBookingStatus.confirmed);
    });
  });
}
