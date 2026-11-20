import 'package:material_ui/material_ui.dart';

import '../../models/patient.dart';
import '../data/demo_data.dart';

/// In-memory source of truth for the signed-in patient.
///
/// Registration writes here and every interested screen listens through
/// [PatientScope] so profile details never need to be duplicated.
class PatientStore extends ChangeNotifier {
  PatientStore({Patient? initialPatient})
      : _patient = initialPatient ?? DemoData.seedPatient;

  Patient _patient;

  Patient get patient => _patient;

  void save(Patient patient) {
    _patient = patient;
    notifyListeners();
  }
}
