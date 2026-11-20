import 'package:material_ui/material_ui.dart';

import '../../core/data/demo_data.dart';
import '../../models/lab_availability_slot.dart';
import '../../models/lab_booking.dart';

/// Session-scoped local bookings for diagnostic tests and health packages.
class LabBookingStore extends ChangeNotifier {
  LabBookingStore({
    List<LabBooking>? upcoming,
    List<LabBooking>? previous,
    List<LabAvailabilitySlot>? availability,
    DateTime Function()? clock,
  }) : _upcoming = List<LabBooking>.of(upcoming ?? const <LabBooking>[]),
       _previous = List<LabBooking>.of(previous ?? const <LabBooking>[]),
       _availability = List<LabAvailabilitySlot>.of(
         availability ?? DemoData.labBookingAvailability,
       ),
       _clock = clock ?? DateTime.now;

  final List<LabBooking> _upcoming;
  final List<LabBooking> _previous;
  final List<LabAvailabilitySlot> _availability;
  final DateTime Function() _clock;

  DateTime get currentTime => _clock();

  List<LabBooking> get upcoming => List<LabBooking>.unmodifiable(
    _upcoming.where(
      (LabBooking booking) =>
          booking.status == LabBookingStatus.confirmed &&
          booking.scheduledAt.isAfter(_clock()),
    ),
  );

  List<LabBooking> get previous {
    final List<LabBooking> history =
        <LabBooking>[
          ..._previous,
          ..._upcoming.where(
            (LabBooking booking) =>
                booking.status != LabBookingStatus.confirmed ||
                !booking.scheduledAt.isAfter(_clock()),
          ),
        ]..sort(
          (LabBooking first, LabBooking second) =>
              second.scheduledAt.compareTo(first.scheduledAt),
        );
    return List<LabBooking>.unmodifiable(history);
  }

  int capacityForSlot(String laboratoryId, DateTime scheduledAt) {
    for (final LabAvailabilitySlot slot in _availability) {
      if (slot.matches(laboratoryId, scheduledAt)) {
        return slot.capacity;
      }
    }
    return 0;
  }

  int reservationsForSlot(String laboratoryId, DateTime scheduledAt) {
    return _upcoming
        .where(
          (LabBooking booking) =>
              booking.status == LabBookingStatus.confirmed &&
              booking.laboratoryId == laboratoryId &&
              booking.scheduledAt.isAtSameMomentAs(scheduledAt),
        )
        .length;
  }

  bool isSlotAvailable(String laboratoryId, DateTime scheduledAt) {
    final int capacity = capacityForSlot(laboratoryId, scheduledAt);
    return scheduledAt.isAfter(_clock()) &&
        capacity > reservationsForSlot(laboratoryId, scheduledAt);
  }

  List<DateTime> slotsForDate(String laboratoryId, DateTime date) {
    final Set<DateTime> slots = <DateTime>{
      for (final LabAvailabilitySlot slot in _availability)
        if (slot.laboratoryId == laboratoryId &&
            slot.weekdays.contains(date.weekday))
          slot.onDate(date),
    };
    final List<DateTime> ordered = slots.toList()
      ..sort((DateTime first, DateTime second) => first.compareTo(second));
    return List<DateTime>.unmodifiable(ordered);
  }

  bool addBooking(LabBooking booking) {
    final bool hasExistingId =
        _upcoming.any((LabBooking existing) => existing.id == booking.id) ||
        _previous.any((LabBooking existing) => existing.id == booking.id);
    final bool isDuplicateSubmission = _upcoming.any(
      (LabBooking existing) =>
          existing.status == LabBookingStatus.confirmed &&
          existing.laboratoryId == booking.laboratoryId &&
          existing.serviceType == booking.serviceType &&
          existing.serviceId == booking.serviceId &&
          existing.scheduledAt.isAtSameMomentAs(booking.scheduledAt),
    );
    final bool homeCollectionSupported = DemoData.laboratories.any(
      (laboratory) =>
          laboratory.id == booking.laboratoryId &&
          laboratory.supportsHomeSampleCollection,
    );
    final bool validCollectionAddress =
        booking.collectionMethod != LabCollectionMethod.homeCollection ||
        (booking.collectionAddress?.trim().isNotEmpty ?? false);

    if (booking.id.trim().isEmpty ||
        booking.status != LabBookingStatus.confirmed ||
        hasExistingId ||
        isDuplicateSubmission ||
        !validCollectionAddress ||
        (booking.collectionMethod == LabCollectionMethod.homeCollection &&
            !homeCollectionSupported) ||
        !isSlotAvailable(booking.laboratoryId, booking.scheduledAt)) {
      return false;
    }

    _upcoming.add(booking);
    notifyListeners();
    return true;
  }

  bool cancel(String bookingId) {
    final int index = _upcoming.indexWhere(
      (LabBooking booking) =>
          booking.id == bookingId &&
          booking.status == LabBookingStatus.confirmed,
    );
    if (index == -1) {
      return false;
    }

    final LabBooking cancelled = _upcoming
        .removeAt(index)
        .copyWith(status: LabBookingStatus.cancelled);
    _previous.insert(0, cancelled);
    notifyListeners();
    return true;
  }
}
