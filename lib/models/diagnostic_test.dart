/// A diagnostic test offered by a laboratory.
class DiagnosticTest {
  const DiagnosticTest({
    required this.id,
    required this.name,
    required this.price,
    this.preparationInstructions,
  });

  final String id;
  final String name;
  final int price;
  final String? preparationInstructions;

  String get priceLabel => '₹$price';
}
