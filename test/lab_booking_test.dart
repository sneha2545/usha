import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:usha/core/constants/app_constants.dart';
import 'package:usha/core/data/demo_data.dart';
import 'package:usha/core/state/appointment_scope.dart';
import 'package:usha/core/state/appointment_store.dart';
import 'package:usha/core/state/lab_booking_scope.dart';
import 'package:usha/core/state/lab_booking_store.dart';
import 'package:usha/core/state/patient_scope.dart';
import 'package:usha/core/state/patient_store.dart';
import 'package:usha/core/theme/app_theme.dart';
import 'package:usha/models/lab_booking.dart';
import 'package:usha/models/laboratory.dart';
import 'package:usha/screens/home/home_screen.dart';
import 'package:usha/widgets/lab_booking_sheet.dart';

void main() {
  final DateTime now = DateTime(2026, 11, 21, 8);
  final Laboratory laboratory = DemoData.laboratories.first;

  testWidgets('test booking reviews and appears in Upcoming history', (
    WidgetTester tester,
  ) async {
    final _Harness harness = await _pumpApp(tester, clock: () => now);
    await _openTestBooking(tester, laboratory, 'ind-cbc');

    expect(find.text(AppStrings.labBookingReviewTitle), findsOneWidget);
    expect(find.text(laboratory.name), findsWidgets);
    expect(find.text('Complete Blood Count (CBC)'), findsWidgets);
    expect(find.text('₹450'), findsWidgets);
    expect(find.text(AppStrings.labVisitLabel), findsWidgets);

    final Finder confirmButton = find.byKey(
      const Key('lab_booking_confirm_button'),
    );
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(harness.labStore.upcoming, hasLength(1));
    final LabBooking booking = harness.labStore.upcoming.single;
    expect(booking.serviceType, LabBookingServiceType.diagnosticTest);
    expect(booking.serviceId, 'ind-cbc');
    expect(booking.collectionMethod, LabCollectionMethod.labVisit);
    expect(booking.createdAt, now);
    expect(booking.collectionAddress, isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav_appointments')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(Key('appointments_lab_details_${booking.id}')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.labUpcomingBookingsTitle), findsOneWidget);
  });

  testWidgets('home collection uses an editable address snapshot', (
    WidgetTester tester,
  ) async {
    final _Harness harness = await _pumpApp(tester, clock: () => now);
    await _openTestBooking(tester, laboratory, 'ind-hba1c');

    await tester.tap(find.byKey(const Key('lab_collection_home')));
    await tester.pumpAndSettle();

    final TextFormField houseField = tester.widget<TextFormField>(
      find.byKey(const Key('lab_address_house')),
    );
    final TextFormField streetField = tester.widget<TextFormField>(
      find.byKey(const Key('lab_address_street')),
    );
    expect(houseField.controller!.text, '12B');
    expect(streetField.controller!.text, 'Palm Grove Apartments, MG Road');

    await tester.enterText(find.byKey(const Key('lab_address_house')), '99A');
    await tester.enterText(find.byKey(const Key('lab_address_pin')), '560002');
    final Finder confirmButton = find.byKey(
      const Key('lab_booking_confirm_button'),
    );
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final LabBooking booking = harness.labStore.upcoming.single;
    expect(booking.collectionMethod, LabCollectionMethod.homeCollection);
    expect(booking.collectionAddress, contains('99A'));
    expect(booking.collectionAddress, contains('560002'));
    expect(harness.patientStore.patient.houseNumber, '12B');
    expect(harness.patientStore.patient.pinCode, '560001');
  });

  testWidgets('unsupported laboratory disables Home Collection', (
    WidgetTester tester,
  ) async {
    final _Harness harness = await _pumpApp(tester, clock: () => now);
    final Laboratory unsupported = DemoData.laboratories.singleWhere(
      (Laboratory lab) => !lab.supportsHomeSampleCollection,
    );
    await _openTestBooking(tester, unsupported, 'wh-fasting-glucose');

    final ChoiceChip homeCollection = tester.widget<ChoiceChip>(
      find.byKey(const Key('lab_collection_home')),
    );
    expect(homeCollection.onSelected, isNull);
    expect(
      find.text(AppStrings.homeCollectionUnavailableForLab),
      findsOneWidget,
    );
    expect(find.byKey(const Key('lab_address_house')), findsNothing);
    expect(harness.labStore.upcoming, isEmpty);
  });

  testWidgets('package booking includes package tests and listed price', (
    WidgetTester tester,
  ) async {
    final _Harness harness = await _pumpApp(tester, clock: () => now);
    await _openPackageBooking(tester, laboratory, 'ind-wellness-screen');

    expect(find.text('Essential Wellness Screen'), findsWidgets);
    expect(find.text('₹2299'), findsWidgets);
    expect(
      find.textContaining('Complete Blood Count (CBC), HbA1c, Lipid Profile'),
      findsOneWidget,
    );

    final Finder confirmButton = find.byKey(
      const Key('lab_booking_confirm_button'),
    );
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final LabBooking booking = harness.labStore.upcoming.single;
    expect(booking.serviceType, LabBookingServiceType.healthPackage);
    expect(booking.serviceId, 'ind-wellness-screen');
    expect(booking.price, 2299);
    expect(booking.includedTestNames, hasLength(4));
  });

  testWidgets('past and capacity-full slots are disabled in the sheet', (
    WidgetTester tester,
  ) async {
    final DateTime slot = DateTime(2026, 11, 21, 11);
    final List<LabBooking> occupied = List<LabBooking>.generate(
      3,
      (int index) => _booking(
        laboratory: laboratory,
        id: 'occupied-$index',
        scheduledAt: slot,
      ),
    );
    await _pumpApp(
      tester,
      clock: () => DateTime(2026, 11, 21, 10),
      upcoming: occupied,
    );
    await _openTestBooking(tester, laboratory, 'ind-cbc');

    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('lab_booking_slot_9_0')))
          .onSelected,
      isNull,
    );
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('lab_booking_slot_11_0')))
          .onSelected,
      isNull,
    );
    expect(
      tester.widget<InkWell>(find.byKey(const Key('lab_booking_date_1'))).onTap,
      isNull,
    );
  });

  testWidgets('cancelling a lab booking records status and releases capacity', (
    WidgetTester tester,
  ) async {
    final _Harness harness = await _pumpApp(tester, clock: () => now);
    await _openTestBooking(tester, laboratory, 'ind-cbc');
    final Finder confirmButton = find.byKey(
      const Key('lab_booking_confirm_button'),
    );
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final LabBooking booking = harness.labStore.upcoming.single;
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav_appointments')));
    await tester.pumpAndSettle();
    final Finder bookingDetails = find.byKey(
      Key('appointments_lab_details_${booking.id}'),
    );
    await tester.ensureVisible(bookingDetails);
    await tester.tap(bookingDetails);
    await tester.pumpAndSettle();
    final Finder cancelButton = find.byKey(
      const Key('lab_booking_cancel_button'),
    );
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('lab_booking_cancel_confirm')));
    await tester.pumpAndSettle();

    expect(harness.labStore.upcoming, isEmpty);
    expect(harness.labStore.previous.single.status, LabBookingStatus.cancelled);
    expect(
      harness.labStore.isSlotAvailable(laboratory.id, booking.scheduledAt),
      isTrue,
    );

    await tester.tap(find.byKey(const Key('nav_profile')));
    await tester.pumpAndSettle();
    final Finder previousTab = find.byKey(const Key('profile_tab_previous'));
    await tester.ensureVisible(previousTab);
    await tester.tap(previousTab);
    await tester.pumpAndSettle();
    expect(
      find.byKey(Key('profile_lab_details_${booking.id}')),
      findsOneWidget,
    );
  });

  testWidgets('booking sheet remains usable on a compact phone', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pumpApp(tester, clock: () => now);
    await _openTestBooking(tester, laboratory, 'ind-cbc');
    await tester.ensureVisible(
      find.byKey(const Key('lab_booking_confirm_button')),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

Future<void> _openTestBooking(
  WidgetTester tester,
  Laboratory laboratory,
  String testId,
) async {
  await _openLaboratory(tester, laboratory);
  final Finder detailsButton = find.byKey(Key('test_details_$testId'));
  await tester.ensureVisible(detailsButton);
  await tester.tap(detailsButton);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('lab_test_book_button')));
  await tester.pumpAndSettle();
  expect(find.byType(LabBookingSheet), findsOneWidget);
}

Future<void> _openPackageBooking(
  WidgetTester tester,
  Laboratory laboratory,
  String packageId,
) async {
  await _openLaboratory(tester, laboratory);
  final Finder detailsButton = find.byKey(Key('package_details_$packageId'));
  await tester.ensureVisible(detailsButton);
  await tester.tap(detailsButton);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('lab_package_book_button')));
  await tester.pumpAndSettle();
  expect(find.byType(LabBookingSheet), findsOneWidget);
}

Future<void> _openLaboratory(WidgetTester tester, Laboratory laboratory) async {
  final Finder exploreButton = find.byKey(
    const Key('home_explore_laboratory_tests'),
  );
  await tester.ensureVisible(exploreButton);
  await tester.tap(exploreButton);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('laboratory_${laboratory.id}')));
  await tester.pumpAndSettle();
}

Future<_Harness> _pumpApp(
  WidgetTester tester, {
  required DateTime Function() clock,
  List<LabBooking> upcoming = const <LabBooking>[],
}) async {
  final PatientStore patientStore = PatientStore();
  final AppointmentStore appointmentStore = AppointmentStore(clock: clock);
  final LabBookingStore labStore = LabBookingStore(
    upcoming: upcoming,
    clock: clock,
  );
  addTearDown(patientStore.dispose);
  addTearDown(appointmentStore.dispose);
  addTearDown(labStore.dispose);

  await tester.pumpWidget(
    PatientScope(
      store: patientStore,
      child: AppointmentScope(
        store: appointmentStore,
        child: LabBookingScope(
          store: labStore,
          child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return _Harness(patientStore, labStore);
}

LabBooking _booking({
  required Laboratory laboratory,
  required String id,
  required DateTime scheduledAt,
}) {
  final test = laboratory.tests.first;
  return LabBooking(
    id: id,
    laboratoryId: laboratory.id,
    laboratoryName: laboratory.name,
    laboratoryLocation: '${laboratory.address}, ${laboratory.locationLabel}',
    serviceType: LabBookingServiceType.diagnosticTest,
    serviceId: test.id,
    serviceName: test.name,
    price: test.price,
    scheduledAt: scheduledAt,
    collectionMethod: LabCollectionMethod.labVisit,
    status: LabBookingStatus.confirmed,
    createdAt: DateTime(2026, 11, 20, 8),
  );
}

class _Harness {
  const _Harness(this.patientStore, this.labStore);

  final PatientStore patientStore;
  final LabBookingStore labStore;
}
