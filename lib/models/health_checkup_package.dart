/// A laboratory health-check package containing diagnostic test IDs.
class HealthCheckupPackage {
  const HealthCheckupPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.includedTestIds,
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final List<String> includedTestIds;

  String get priceLabel => '₹$price';
}
