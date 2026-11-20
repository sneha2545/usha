import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'core/state/appointment_scope.dart';
import 'core/state/appointment_store.dart';
import 'core/state/lab_booking_scope.dart';
import 'core/state/lab_booking_store.dart';
import 'core/state/patient_scope.dart';
import 'core/state/patient_store.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFFFFFF),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const UshaApp());
}

/// Root widget for the USHA healthcare application.
///
/// Owns the session-scoped stores so registration, dashboard, profile and
/// appointments all share the same in-memory information.
class UshaApp extends StatefulWidget {
  const UshaApp({super.key});

  @override
  State<UshaApp> createState() => _UshaAppState();
}

class _UshaAppState extends State<UshaApp> {
  late final PatientStore _patientStore = PatientStore();
  late final AppointmentStore _appointmentStore = AppointmentStore();
  late final LabBookingStore _labBookingStore = LabBookingStore();

  @override
  void dispose() {
    _patientStore.dispose();
    _appointmentStore.dispose();
    _labBookingStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PatientScope(
      store: _patientStore,
      child: AppointmentScope(
        store: _appointmentStore,
        child: LabBookingScope(
          store: _labBookingStore,
          child: MaterialApp(
            title: 'USHA',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
