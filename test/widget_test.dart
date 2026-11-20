import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:usha/core/constants/app_constants.dart';
import 'package:usha/core/data/demo_data.dart';
import 'package:usha/core/theme/app_theme.dart';
import 'package:usha/core/state/appointment_scope.dart';
import 'package:usha/core/state/appointment_store.dart';
import 'package:usha/core/state/lab_booking_scope.dart';
import 'package:usha/core/state/lab_booking_store.dart';
import 'package:usha/core/state/patient_scope.dart';
import 'package:usha/core/state/patient_store.dart';
import 'package:usha/main.dart';
import 'package:usha/models/appointment.dart';
import 'package:usha/screens/auth/login_screen.dart';
import 'package:usha/screens/auth/sign_up_screen.dart';
import 'package:usha/screens/home/home_screen.dart';

void main() {
  testWidgets('splash screen shows branding then opens login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UshaApp());

    expect(find.text('USHA'), findsOneWidget);
    expect(find.text('Your Health, Our Priority'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('login form validates empty credentials', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pumpAndSettle();

    final Finder submitButton = find.byKey(const Key('login_submit_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    expect(find.text('Enter a valid email or mobile number'), findsOneWidget);
    expect(find.text('Enter your password'), findsWidgets);
  });

  testWidgets('password visibility toggle reveals the password', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pumpAndSettle();

    final Finder passwordField = find.descendant(
      of: find.byKey(const Key('login_password_field')),
      matching: find.byType(EditableText),
    );

    expect(tester.widget<EditableText>(passwordField).obscureText, isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();

    expect(tester.widget<EditableText>(passwordField).obscureText, isFalse);
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('login screen lays out on a compact phone', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
  });

  testWidgets('sign up action opens the registration screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pumpAndSettle();

    final Finder signUpButton = find.byKey(const Key('login_signup_button'));
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
    expect(find.text('Create your account'), findsOneWidget);
  });

  testWidgets('sign up screen lays out on a compact phone', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SignUpScreen()),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('signup_submit_button')), findsOneWidget);
  });

  testWidgets('demo credentials open the home dashboard', (
    WidgetTester tester,
  ) async {
    await pumpLogin(tester);
    await submitCredentials(
      tester,
      email: 'test@usha.com',
      password: 'Usha@123',
    );

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.textContaining('Jordan'), findsOneWidget);
    expect(find.text('Hello, Welcome!'), findsOneWidget);
    expect(find.text('Popular Doctors'), findsOneWidget);
  });

  testWidgets('incorrect credentials show an error and stay on login', (
    WidgetTester tester,
  ) async {
    await pumpLogin(tester);
    await submitCredentials(
      tester,
      email: 'test@usha.com',
      password: 'wrong-password',
    );

    expect(
      find.text(
        'Incorrect email or password. Please use the demo credentials below.',
      ),
      findsOneWidget,
    );
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('demo fill button populates the credential fields', (
    WidgetTester tester,
  ) async {
    await pumpLogin(tester);

    final Finder fillButton = find.byKey(const Key('login_demo_fill'));
    await tester.ensureVisible(fillButton);
    await tester.tap(fillButton);
    await tester.pumpAndSettle();

    final TextFormField emailField = tester.widget<TextFormField>(
      find.descendant(
        of: find.byKey(const Key('login_email_field')),
        matching: find.byType(TextFormField),
      ),
    );
    final TextFormField passwordField = tester.widget<TextFormField>(
      find.descendant(
        of: find.byKey(const Key('login_password_field')),
        matching: find.byType(TextFormField),
      ),
    );

    expect(emailField.controller?.text, 'test@usha.com');
    expect(passwordField.controller?.text, 'Usha@123');
  });

  testWidgets('signing out returns to the login screen', (
    WidgetTester tester,
  ) async {
    await pumpLogin(tester);
    await submitCredentials(
      tester,
      email: 'test@usha.com',
      password: 'Usha@123',
    );

    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    final Finder signOut = find.byKey(const Key('profile_sign_out_button'));
    await tester.ensureVisible(signOut);
    await tester.pumpAndSettle();
    await tester.tap(signOut);
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('home dashboard lays out on a compact phone', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpHome(tester);

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Jordan'), findsOneWidget);
    expect(find.text('Upcoming Appointment'), findsOneWidget);
    expect(find.byKey(const Key('home_book_appointment')), findsOneWidget);
    expect(
      find.byKey(const Key('home_explore_laboratory_tests')),
      findsOneWidget,
    );
  });

  testWidgets('home banner appointment action opens doctor booking', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('home_book_appointment')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.bookingTitle), findsOneWidget);
  });

  testWidgets('search filters the popular doctors list', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('home_search_field')),
        matching: find.byType(TextField),
      ),
      'Sneha',
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('home_doctor_dr-sneha-kapoor')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('home_doctor_dr-ananya-rao')), findsNothing);
    expect(find.text('Search results'), findsOneWidget);
  });

  testWidgets('tapping a category opens the filtered doctor directory', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    final Finder category = find.byKey(const Key('category_Cardiologist'));
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('directory_doctor_dr-ananya-rao')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('directory_doctor_dr-vikram-mehta')),
      findsNothing,
    );
  });

  testWidgets('bottom navigation switches dashboard tabs', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('nav_appointments')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('appointments_book_button')), findsOneWidget);
    expect(find.text('Past consultations'), findsOneWidget);
    expect(
      find.byKey(const Key('appointment_details_appt-upcoming-2')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    expect(find.text('test@usha.com'), findsWidgets);
    expect(find.text('Health Profile'), findsOneWidget);
    expect(
      find.byKey(const Key('profile_view_details_appt-upcoming-2')),
      findsOneWidget,
    );
    final Finder previousTab = find.byKey(const Key('profile_tab_previous'));
    await tester.ensureVisible(previousTab);
    await tester.tap(previousTab);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('profile_view_details_appt-past-1')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('nav_home')));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Welcome!'), findsOneWidget);
  });

  testWidgets('profile edits update the home greeting from shared state', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    final Finder editButton = find.byKey(const Key('profile_edit_button'));
    await tester.ensureVisible(editButton);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('edit_name_field')),
        matching: find.byType(TextFormField),
      ),
      'Avery Johnson',
    );
    final Finder saveButton = find.byKey(const Key('edit_save_button'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Avery Johnson'), findsWidgets);
    await tester.tap(find.byKey(const Key('nav_home')));
    await tester.pumpAndSettle();
    expect(
      find.text("Avery, let's take care of your health today."),
      findsOneWidget,
    );
  });

  testWidgets('registration rejects mobile numbers without digits', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SignUpScreen()),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('signup_mobile_field')),
        matching: find.byType(TextFormField),
      ),
      '----------',
    );
    final Finder submitButton = find.byKey(const Key('signup_submit_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.validationMobile), findsOneWidget);
  });

  testWidgets(
    'profile accepts seeded +91 number and saves a formatted update',
    (WidgetTester tester) async {
      await pumpHome(tester);
      await openProfileEditor(tester);

      final Finder saveButton = find.byKey(const Key('edit_save_button'));
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('+91 98765 43210'), findsNWidgets(2));

      await openProfileEditor(tester);
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('edit_mobile_field')),
          matching: find.byType(TextFormField),
        ),
        '+91-98765-43210',
      );
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('+91-98765-43210'), findsNWidgets(2));
      expect(find.text('Jordan Mathew'), findsNWidgets(2));
      expect(find.text('test@usha.com'), findsNWidgets(2));
      expect(find.text('O+'), findsOneWidget);
      expect(find.text('12B'), findsOneWidget);
    },
  );

  testWidgets('invalid profile mobile number prevents saving', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openProfileEditor(tester);

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('edit_mobile_field')),
        matching: find.byType(TextFormField),
      ),
      '----------',
    );
    final Finder saveButton = find.byKey(const Key('edit_save_button'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.validationMobile), findsOneWidget);
    expect(find.byKey(const Key('edit_save_button')), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('+91 98765 43210'), findsNWidgets(2));
  });

  testWidgets('profile email updates after trimming and preserves other data', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openProfileEditor(tester);

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('edit_email_field')),
        matching: find.byType(TextFormField),
      ),
      '  updated.patient@example.com  ',
    );
    final Finder saveButton = find.byKey(const Key('edit_save_button'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('updated.patient@example.com'), findsNWidgets(2));
    expect(find.text('Jordan Mathew'), findsNWidgets(2));
    expect(find.text('+91 98765 43210'), findsNWidgets(2));
    expect(find.text('O+'), findsOneWidget);
    expect(find.text('176 cm'), findsOneWidget);
    expect(find.text('12B'), findsOneWidget);
  });

  testWidgets('invalid profile email prevents saving', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openProfileEditor(tester);

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('edit_email_field')),
        matching: find.byType(TextFormField),
      ),
      'not-an-email',
    );
    final Finder saveButton = find.byKey(const Key('edit_save_button'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.byKey(const Key('edit_save_button')), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('test@usha.com'), findsNWidgets(2));
    expect(find.text('not-an-email'), findsNothing);
  });

  testWidgets('notification and profile header actions respond', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('home_notifications')));
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsWidgets);
    expect(find.text('Appointment reminder'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home_profile_avatar')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('profile_sign_out_button')), findsOneWidget);
  });

  testWidgets('forgot password sheet confirms the reset request', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pumpAndSettle();

    final Finder forgotLink = find.byKey(const Key('login_forgot_password'));
    await tester.ensureVisible(forgotLink);
    await tester.tap(forgotLink);
    await tester.pumpAndSettle();

    expect(find.text('Reset your password'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('forgot_email_field')),
        matching: find.byType(TextFormField),
      ),
      'jordan@example.com',
    );
    await tester.tap(find.byKey(const Key('forgot_submit_button')));
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.text('Reset link sent'), findsOneWidget);
  });

  testWidgets('doctor booking is reviewed, saved and shown in upcoming', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime(2026, 11, 21, 8);
    final AppointmentStore store = await pumpHomeWithAppointments(
      tester,
      clock: () => now,
    );
    final doctor = DemoData.doctors.first;

    await tester.tap(find.byKey(const Key('nav_doctors')));
    await tester.pumpAndSettle();
    final Finder viewProfile = find.byKey(Key('view_profile_${doctor.id}'));
    await tester.ensureVisible(viewProfile);
    await tester.tap(viewProfile);
    await tester.pumpAndSettle();

    expect(find.text(doctor.clinic), findsWidgets);
    await tester.tap(find.byKey(const Key('doctor_book_button')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.bookingReviewTitle), findsOneWidget);
    expect(find.text(doctor.specialty), findsWidgets);
    expect(find.text(doctor.clinic), findsWidgets);
    expect(find.text(doctor.feeLabel), findsWidgets);

    final Finder tomorrow = find.byKey(const Key('booking_date_1'));
    await tester.ensureVisible(tomorrow);
    await tester.tap(tomorrow);
    await tester.pumpAndSettle();
    final Finder noonSlot = find.byKey(const Key('booking_time_12_0'));
    await tester.ensureVisible(noonSlot);
    await tester.tap(noonSlot);
    await tester.pumpAndSettle();

    expect(find.text('Sun, 22 Nov 2026'), findsOneWidget);
    expect(find.text('12:00 PM'), findsWidgets);

    final Finder confirmButton = find.byKey(
      const Key('booking_confirm_button'),
    );
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appointmentBooked), findsOneWidget);
    expect(store.upcoming, hasLength(1));
    expect(store.upcoming.single.doctor.id, doctor.id);
    expect(store.upcoming.single.scheduledAt, DateTime(2026, 11, 22, 12));

    await tester.tap(find.byKey(const Key('nav_appointments')));
    await tester.pumpAndSettle();
    expect(find.text(doctor.name), findsOneWidget);
    expect(
      find.byKey(Key('appointment_details_${store.upcoming.single.id}')),
      findsOneWidget,
    );
  });

  testWidgets('past and occupied slots cannot be selected', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime(2026, 11, 21, 10);
    final doctor = DemoData.doctors.first;
    final Appointment occupiedAppointment = Appointment(
      id: 'occupied-slot',
      doctor: doctor,
      scheduledAt: DateTime(2026, 11, 21, 10, 30),
      mode: AppointmentMode.video,
    );
    final AppointmentStore store = await pumpHomeWithAppointments(
      tester,
      clock: () => now,
      upcoming: <Appointment>[occupiedAppointment],
    );

    await tester.tap(find.byKey(const Key('nav_appointments')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('appointments_book_button')));
    await tester.pumpAndSettle();

    for (final Key slotKey in <Key>[
      const Key('booking_time_9_0'),
      const Key('booking_time_10_30'),
    ]) {
      final Finder slot = find.byKey(slotKey);
      await tester.ensureVisible(slot);
      await tester.tap(slot);
      await tester.pumpAndSettle();
    }

    expect(find.text('12:00 PM'), findsWidgets);
    final Finder confirmButton = find.byKey(
      const Key('booking_confirm_button'),
    );
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(store.upcoming, hasLength(2));
    expect(store.upcoming.last.scheduledAt, DateTime(2026, 11, 21, 12));
  });

  testWidgets('cancelling a booking keeps it in previous history', (
    WidgetTester tester,
  ) async {
    final Appointment appointment = Appointment(
      id: 'cancel-widget-test',
      doctor: DemoData.doctors.first,
      scheduledAt: DateTime.now().add(const Duration(days: 2)),
      mode: AppointmentMode.video,
    );
    final AppointmentStore store = await pumpHomeWithAppointments(
      tester,
      upcoming: <Appointment>[appointment],
    );

    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    final Finder cancelButton = find.byKey(
      Key('profile_cancel_${appointment.id}'),
    );
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.cancelAppointment).last);
    await tester.pumpAndSettle();

    expect(store.upcoming, isEmpty);
    expect(store.previous.single.status, AppointmentStatus.cancelled);

    final Finder previousTab = find.byKey(const Key('profile_tab_previous'));
    await tester.ensureVisible(previousTab);
    await tester.tap(previousTab);
    await tester.pumpAndSettle();
    expect(find.text(appointment.doctor.name), findsOneWidget);
    expect(find.text(AppointmentStatus.cancelled.label), findsOneWidget);
  });
}

Future<void> openProfileEditor(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('nav_profile')));
  await tester.pumpAndSettle();
  final Finder editButton = find.byKey(const Key('profile_edit_button'));
  await tester.ensureVisible(editButton);
  await tester.tap(editButton);
  await tester.pumpAndSettle();
}

Future<void> pumpLogin(WidgetTester tester) async {
  final PatientStore patientStore = PatientStore();
  final AppointmentStore appointmentStore = AppointmentStore();
  final LabBookingStore labBookingStore = LabBookingStore();
  addTearDown(patientStore.dispose);
  addTearDown(appointmentStore.dispose);
  addTearDown(labBookingStore.dispose);

  await tester.pumpWidget(
    PatientScope(
      store: patientStore,
      child: AppointmentScope(
        store: appointmentStore,
        child: LabBookingScope(
          store: labBookingStore,
          child: MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpHome(WidgetTester tester) async {
  final PatientStore patientStore = PatientStore();
  final AppointmentStore appointmentStore = AppointmentStore();
  final LabBookingStore labBookingStore = LabBookingStore();
  addTearDown(patientStore.dispose);
  addTearDown(appointmentStore.dispose);
  addTearDown(labBookingStore.dispose);

  await tester.pumpWidget(
    PatientScope(
      store: patientStore,
      child: AppointmentScope(
        store: appointmentStore,
        child: LabBookingScope(
          store: labBookingStore,
          child: const MaterialApp(home: HomeScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<AppointmentStore> pumpHomeWithAppointments(
  WidgetTester tester, {
  DateTime Function()? clock,
  List<Appointment> upcoming = const <Appointment>[],
  List<Appointment> previous = const <Appointment>[],
}) async {
  final PatientStore patientStore = PatientStore();
  final AppointmentStore appointmentStore = AppointmentStore(
    upcoming: upcoming,
    previous: previous,
    clock: clock,
  );
  final LabBookingStore labBookingStore = LabBookingStore(clock: clock);
  addTearDown(patientStore.dispose);
  addTearDown(appointmentStore.dispose);
  addTearDown(labBookingStore.dispose);

  await tester.pumpWidget(
    PatientScope(
      store: patientStore,
      child: AppointmentScope(
        store: appointmentStore,
        child: LabBookingScope(
          store: labBookingStore,
          child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return appointmentStore;
}

Future<void> submitCredentials(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  await tester.enterText(
    find.descendant(
      of: find.byKey(const Key('login_email_field')),
      matching: find.byType(TextFormField),
    ),
    email,
  );
  await tester.enterText(
    find.descendant(
      of: find.byKey(const Key('login_password_field')),
      matching: find.byType(TextFormField),
    ),
    password,
  );

  final Finder submitButton = find.byKey(const Key('login_submit_button'));
  await tester.ensureVisible(submitButton);
  await tester.tap(submitButton);
  await tester.pump(const Duration(milliseconds: 1400));
  await tester.pumpAndSettle();
}
