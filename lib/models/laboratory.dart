import 'diagnostic_test.dart';
import 'health_checkup_package.dart';

/// A fictional laboratory and its locally available demo catalog.
class Laboratory {
  const Laboratory({
    required this.id,
    required this.name,
    required this.address,
    required this.locality,
    required this.city,
    required this.operatingHours,
    required this.supportsHomeSampleCollection,
    required this.tests,
    required this.packages,
  });

  final String id;
  final String name;
  final String address;
  final String locality;
  final String city;
  final String operatingHours;
  final bool supportsHomeSampleCollection;
  final List<DiagnosticTest> tests;
  final List<HealthCheckupPackage> packages;

  String get locationLabel => '$locality, $city';
}
