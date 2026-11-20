import 'package:material_ui/material_ui.dart';

import 'lab_booking_store.dart';

/// Exposes [LabBookingStore] to booking and history widgets.
class LabBookingScope extends InheritedNotifier<LabBookingStore> {
  const LabBookingScope({
    super.key,
    required LabBookingStore store,
    required super.child,
  }) : super(notifier: store);

  static LabBookingStore of(BuildContext context) {
    final LabBookingScope? scope = context
        .dependOnInheritedWidgetOfExactType<LabBookingScope>();
    assert(scope != null, 'LabBookingScope is missing above this context.');
    return scope!.notifier!;
  }

  static LabBookingStore? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LabBookingScope>()
        ?.notifier;
  }
}
