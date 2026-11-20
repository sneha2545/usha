import 'package:material_ui/material_ui.dart';

import 'appointment_store.dart';

/// Exposes [AppointmentStore] to the widget tree and rebuilds dependants when
/// bookings change.
class AppointmentScope extends InheritedNotifier<AppointmentStore> {
  const AppointmentScope({
    super.key,
    required AppointmentStore store,
    required super.child,
  }) : super(notifier: store);

  static AppointmentStore of(BuildContext context) {
    final AppointmentScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppointmentScope>();
    assert(scope != null, 'AppointmentScope is missing above this context.');
    return scope!.notifier!;
  }

  static AppointmentStore? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppointmentScope>()
        ?.notifier;
  }
}
