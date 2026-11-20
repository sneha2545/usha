import 'package:material_ui/material_ui.dart';

import 'patient_store.dart';

/// Exposes [PatientStore] to the widget tree and rebuilds dependants when the
/// patient changes.
class PatientScope extends InheritedNotifier<PatientStore> {
  const PatientScope({
    super.key,
    required PatientStore store,
    required super.child,
  }) : super(notifier: store);

  static PatientStore of(BuildContext context) {
    final PatientScope? scope =
        context.dependOnInheritedWidgetOfExactType<PatientScope>();
    assert(scope != null, 'PatientScope is missing above this context.');
    return scope!.notifier!;
  }

  static PatientStore? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PatientScope>()
        ?.notifier;
  }
}
