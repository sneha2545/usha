import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:usha/core/constants/app_constants.dart';
import 'package:usha/core/data/demo_data.dart';
import 'package:usha/core/theme/app_theme.dart';
import 'package:usha/models/appointment.dart';
import 'package:usha/models/doctor.dart';
import 'package:usha/widgets/appointment_details_sheet.dart';
import 'package:usha/widgets/doctor_avatar.dart';
import 'package:usha/widgets/doctor_details_sheet.dart';
import 'package:usha/widgets/doctor_profile_overview.dart';

void main() {
  final Doctor doctor = DemoData.doctors.first;

  testWidgets('profile shows a large portrait with initials fallback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_profileApp(doctor));

    final Finder avatarFinder = find.byKey(
      Key('doctor_profile_avatar_${doctor.id}'),
    );
    expect(avatarFinder, findsOneWidget);
    expect(tester.widget<DoctorAvatar>(avatarFinder).size, 116);
    expect(find.text(doctor.initials), findsOneWidget);
  });

  testWidgets('missing local image safely falls back to initials', (
    WidgetTester tester,
  ) async {
    final Doctor doctorWithMissingImage = _doctor(
      profileImageAsset: 'images/missing-doctor.png',
    );

    await tester.pumpWidget(_profileApp(doctorWithMissingImage));
    await tester.pumpAndSettle();

    expect(find.text(doctorWithMissingImage.initials), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile displays qualifications, biography and clinic info', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_profileApp(doctor));

    expect(find.text(doctor.qualification!), findsOneWidget);
    expect(find.text(AppStrings.aboutDoctorLabel), findsOneWidget);
    expect(find.textContaining('sample focus'), findsOneWidget);
    expect(find.text(doctor.clinic), findsOneWidget);
    expect(find.text(doctor.clinicLocation!), findsOneWidget);
    expect(find.text(doctor.availabilityInfo!), findsOneWidget);
    expect(
      find.textContaining(AppStrings.doctorProfileDemoNotice),
      findsOneWidget,
    );
  });

  testWidgets('optional profile fields render safely when absent', (
    WidgetTester tester,
  ) async {
    final Doctor minimalDoctor = _doctor(
      about: '',
      clinic: '',
      qualification: ' ',
      clinicLocation: ' ',
      availabilityInfo: ' ',
      languages: const <String>[],
    );

    await tester.pumpWidget(_profileApp(minimalDoctor));

    expect(find.text(AppStrings.doctorBioUnavailable), findsOneWidget);
    expect(find.text(AppStrings.clinicLabel), findsNothing);
    expect(find.text(AppStrings.clinicLocationLabel), findsNothing);
    expect(find.text(AppStrings.availabilityLabel), findsNothing);
    expect(find.text(AppStrings.languagesSpokenLabel), findsNothing);
  });

  testWidgets('appointment sheet displays saved status and notes', (
    WidgetTester tester,
  ) async {
    final Appointment appointment = _appointment(
      status: AppointmentStatus.cancelled,
      scheduledAt: DateTime(2030, 3, 10, 14, 30),
      notes: 'Follow-up discussion',
    );

    await _openAppointmentDetails(tester, appointment);

    expect(find.text(AppointmentStatus.cancelled.label), findsOneWidget);
    expect(find.text(AppStrings.appointmentNotesLabel), findsOneWidget);
    expect(find.text('Follow-up discussion'), findsOneWidget);
    expect(find.textContaining('10 Mar 2030'), findsOneWidget);
    expect(find.text('2:30 PM'), findsOneWidget);
    expect(find.text(appointment.mode.label), findsOneWidget);
  });

  testWidgets('confirmed status is not inferred from the appointment date', (
    WidgetTester tester,
  ) async {
    final Appointment appointment = _appointment(
      status: AppointmentStatus.confirmed,
      scheduledAt: DateTime(2020, 1, 2, 9),
    );

    await _openAppointmentDetails(tester, appointment);

    expect(find.text(AppointmentStatus.confirmed.label), findsOneWidget);
    expect(find.text(AppointmentStatus.completed.label), findsNothing);
  });

  testWidgets('completed appointments display their saved status', (
    WidgetTester tester,
  ) async {
    final Appointment appointment = _appointment(
      status: AppointmentStatus.completed,
      scheduledAt: DateTime(2020, 1, 2, 9),
    );

    await _openAppointmentDetails(tester, appointment);

    expect(find.text(AppointmentStatus.completed.label), findsOneWidget);
  });

  test('legacy video mode uses neutral appointment wording', () {
    expect(AppointmentMode.video.label, 'Doctor appointment');
  });

  testWidgets('doctor details retains the existing booking action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: DoctorDetailsSheet(doctor: doctor)),
      ),
    );

    expect(find.byKey(const Key('doctor_book_button')), findsOneWidget);
    expect(find.text(doctor.name), findsOneWidget);
  });

  testWidgets('appointment details remains scrollable on a compact phone', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _openAppointmentDetails(tester, _appointment());
    await tester.ensureVisible(find.text(AppStrings.done));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.done), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

MaterialApp _profileApp(Doctor doctor) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: SingleChildScrollView(child: DoctorProfileOverview(doctor: doctor)),
    ),
  );
}

Doctor _doctor({
  String? about = 'A fictional sample doctor biography.',
  String? clinic = 'USHA Demo Clinic',
  String? qualification,
  String? clinicLocation,
  String? availabilityInfo,
  String? profileImageAsset,
  List<String> languages = const <String>['English'],
}) {
  return Doctor(
    id: 'test-doctor',
    name: 'Dr. Sample Doctor',
    specialty: 'General Physician',
    rating: 4.7,
    reviewCount: 20,
    fee: 450,
    experienceYears: 9,
    about: about ?? '',
    languages: languages,
    clinic: clinic ?? '',
    qualification: qualification,
    clinicLocation: clinicLocation,
    availabilityInfo: availabilityInfo,
    profileImageAsset: profileImageAsset,
    isVerified: false,
  );
}

Appointment _appointment({
  AppointmentStatus status = AppointmentStatus.confirmed,
  DateTime? scheduledAt,
  String? notes,
}) {
  return Appointment(
    id: 'test-appointment',
    doctor: _doctor(),
    scheduledAt: scheduledAt ?? DateTime(2030, 3, 10, 14, 30),
    mode: AppointmentMode.video,
    status: status,
    notes: notes,
  );
}

Future<void> _openAppointmentDetails(
  WidgetTester tester,
  Appointment appointment,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showAppointmentDetails(context, appointment),
              child: const Text('Open appointment'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Open appointment'));
  await tester.pumpAndSettle();
}
