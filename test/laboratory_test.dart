import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:usha/core/constants/app_colors.dart';
import 'package:usha/core/constants/app_constants.dart';
import 'package:usha/core/data/demo_data.dart';
import 'package:usha/core/state/appointment_scope.dart';
import 'package:usha/core/state/appointment_store.dart';
import 'package:usha/core/state/lab_booking_scope.dart';
import 'package:usha/core/state/lab_booking_store.dart';
import 'package:usha/core/state/patient_scope.dart';
import 'package:usha/core/state/patient_store.dart';
import 'package:usha/core/theme/app_theme.dart';
import 'package:usha/models/laboratory.dart';
import 'package:usha/screens/home/home_screen.dart';
import 'package:usha/screens/laboratory/laboratories_screen.dart';
import 'package:usha/widgets/promo_banner.dart';

void main() {
  testWidgets('dashboard laboratory action matches banner appointment button', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    final Finder banner = find.byType(PromoBanner);
    final Finder bookButton = find.byKey(const Key('home_book_appointment'));
    final Finder laboratoryButton = find.byKey(
      const Key('home_explore_laboratory_tests'),
    );

    expect(find.descendant(of: banner, matching: bookButton), findsOneWidget);
    expect(
      find.descendant(of: banner, matching: laboratoryButton),
      findsOneWidget,
    );
    expect(find.text(AppStrings.exploreLaboratoryTests), findsOneWidget);
    expect(find.byKey(const Key('home_laboratories_entry')), findsNothing);
    expect(
      tester.getRect(bookButton).size,
      tester.getRect(laboratoryButton).size,
    );
    expect(
      tester.getTopLeft(laboratoryButton).dy -
          tester.getBottomLeft(bookButton).dy,
      12,
    );

    final Finder bookSurfaceFinder = find.descendant(
      of: bookButton,
      matching: find.byType(Material),
    );
    final Finder laboratorySurfaceFinder = find.descendant(
      of: laboratoryButton,
      matching: find.byType(Material),
    );
    final Material bookSurface = tester.widget<Material>(bookSurfaceFinder);
    final Material laboratorySurface = tester.widget<Material>(
      laboratorySurfaceFinder,
    );
    expect(bookSurface.color, Colors.white);
    expect(laboratorySurface.color, Colors.white);
    expect(bookSurface.borderRadius, BorderRadius.circular(12));
    expect(laboratorySurface.borderRadius, BorderRadius.circular(12));

    final Finder bookIcon = find.descendant(
      of: bookButton,
      matching: find.byType(Icon),
    );
    final Finder laboratoryIcon = find.descendant(
      of: laboratoryButton,
      matching: find.byType(Icon),
    );
    expect(tester.widget<Icon>(bookIcon).icon, Icons.calendar_month_rounded);
    expect(tester.widget<Icon>(laboratoryIcon).icon, Icons.biotech_outlined);

    final Text bookLabel = tester.widget<Text>(
      find.descendant(
        of: bookButton,
        matching: find.text(AppStrings.bookAppointment),
      ),
    );
    final Text laboratoryLabel = tester.widget<Text>(
      find.descendant(
        of: laboratoryButton,
        matching: find.text(AppStrings.exploreLaboratoryTests),
      ),
    );
    expect(bookLabel.style?.color, AppColors.primaryDeep);
    expect(laboratoryLabel.style?.color, AppColors.primaryDeep);
    expect(bookLabel.style?.fontSize, laboratoryLabel.style?.fontSize);
    expect(bookLabel.style?.fontWeight, laboratoryLabel.style?.fontWeight);
  });

  testWidgets('dashboard opens the laboratory listing with demo lab cards', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratories(tester);

    expect(find.byType(LaboratoriesScreen), findsOneWidget);
    expect(
      find.byKey(const Key('laboratory_demo-lab-indiranagar')),
      findsOneWidget,
    );
    expect(find.text('Indiranagar, Bengaluru'), findsOneWidget);
    expect(find.text('Mon-Sat, 6:30 AM-8:00 PM'), findsOneWidget);
    expect(find.text(AppStrings.homeCollectionAvailable), findsWidgets);
    expect(find.text(AppStrings.homeCollectionUnavailable), findsWidgets);
  });

  testWidgets('laboratory search filters by laboratory name', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratories(tester);

    await enterLaboratorySearch(tester, 'DemoLife');

    expect(
      find.byKey(const Key('laboratory_demo-lab-whitefield')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('laboratory_demo-lab-indiranagar')),
      findsNothing,
    );
  });

  testWidgets('laboratory search filters by location', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratories(tester);

    await enterLaboratorySearch(tester, 'Hyderabad');

    expect(
      find.byKey(const Key('laboratory_demo-lab-jubilee-hills')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('laboratory_demo-lab-whitefield')),
      findsNothing,
    );
  });

  testWidgets('laboratory search displays a no-results state', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratories(tester);

    await enterLaboratorySearch(tester, 'Atlantis');

    expect(find.byKey(const Key('laboratory_no_results')), findsOneWidget);
    expect(find.text(AppStrings.noLaboratoriesFound), findsOneWidget);
    for (final Laboratory laboratory in DemoData.laboratories) {
      expect(find.byKey(Key('laboratory_${laboratory.id}')), findsNothing);
    }
  });

  testWidgets('laboratory details show location, tests and packages', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    final Laboratory laboratory = DemoData.laboratories.first;
    await openLaboratoryDetails(tester, laboratory);

    expect(find.text(laboratory.name), findsOneWidget);
    expect(
      find.text('${laboratory.address}, ${laboratory.locationLabel}'),
      findsOneWidget,
    );
    expect(find.text(AppStrings.homeCollectionAvailable), findsOneWidget);
    expect(find.text(AppStrings.diagnosticTestsTitle), findsOneWidget);
    expect(find.text('Complete Blood Count (CBC)'), findsOneWidget);
    expect(find.text('₹450'), findsOneWidget);
    expect(find.text(AppStrings.healthPackagesTitle), findsOneWidget);
    expect(find.text('Essential Wellness Screen'), findsOneWidget);
    expect(find.text('₹2299'), findsOneWidget);
  });

  testWidgets('test details show price and preparation instructions', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratoryDetails(tester, DemoData.laboratories.first);

    final Finder testDetailsButton = find.byKey(
      const Key('test_details_ind-lipid-profile'),
    );
    await tester.ensureVisible(testDetailsButton);
    await tester.tap(testDetailsButton);
    await tester.pumpAndSettle();

    expect(find.text('Lipid Profile'), findsWidgets);
    expect(find.text('₹850'), findsWidgets);
    expect(find.text(AppStrings.preparationLabel), findsOneWidget);
    expect(find.text('Fast for 9-12 hours; water is allowed.'), findsWidgets);
  });

  testWidgets('test search filters the laboratory catalog', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratoryDetails(tester, DemoData.laboratories.first);

    final Finder searchField = find.descendant(
      of: find.byKey(const Key('diagnostic_test_search_field')),
      matching: find.byType(TextField),
    );
    await tester.enterText(searchField, 'thyroid');
    await tester.pumpAndSettle();

    expect(find.text('Thyroid Profile'), findsOneWidget);
    expect(find.text('Lipid Profile'), findsNothing);

    await tester.enterText(searchField, 'not a test');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('diagnostic_test_no_results')), findsOneWidget);
  });

  testWidgets('package details show price and included tests', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratoryDetails(tester, DemoData.laboratories.first);

    final Finder packageDetailsButton = find.byKey(
      const Key('package_details_ind-wellness-screen'),
    );
    await tester.ensureVisible(packageDetailsButton);
    await tester.tap(packageDetailsButton);
    await tester.pumpAndSettle();

    expect(find.text('Essential Wellness Screen'), findsWidgets);
    expect(find.text('₹2299'), findsWidgets);
    expect(find.text(AppStrings.includedTestsLabel), findsOneWidget);
    expect(find.text('Complete Blood Count (CBC)'), findsWidgets);
    expect(find.text('HbA1c'), findsWidgets);
    expect(find.text('Lipid Profile'), findsWidgets);
    expect(find.text('Thyroid Profile'), findsWidgets);
  });

  testWidgets('returning from laboratory discovery preserves navigation', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    await openLaboratories(tester);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('home_explore_laboratory_tests')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('nav_doctors')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.doctorsTitle), findsWidgets);

    await tester.tap(find.byKey(const Key('nav_appointments')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('appointments_book_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.profileTitle), findsWidgets);

    await tester.tap(find.byKey(const Key('nav_home')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.helloWelcome), findsOneWidget);
  });

  test('every demo package references tests offered by its laboratory', () {
    for (final Laboratory laboratory in DemoData.laboratories) {
      for (final package in laboratory.packages) {
        expect(
          package.includedTestIds.every(
            (String id) => laboratory.tests.any((test) => test.id == id),
          ),
          isTrue,
          reason: '${package.name} contains an unknown test ID.',
        );
      }
    }
  });
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
          child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> openLaboratories(WidgetTester tester) async {
  final Finder entry = find.byKey(const Key('home_explore_laboratory_tests'));
  await tester.ensureVisible(entry);
  await tester.tap(entry);
  await tester.pumpAndSettle();
}

Future<void> enterLaboratorySearch(WidgetTester tester, String query) async {
  final Finder searchField = find.descendant(
    of: find.byKey(const Key('laboratory_search_field')),
    matching: find.byType(TextField),
  );
  await tester.enterText(searchField, query);
  await tester.pumpAndSettle();
}

Future<void> openLaboratoryDetails(
  WidgetTester tester,
  Laboratory laboratory,
) async {
  await openLaboratories(tester);
  final Finder card = find.byKey(Key('laboratory_${laboratory.id}'));
  await tester.ensureVisible(card);
  await tester.tap(card);
  await tester.pumpAndSettle();
}
