import 'package:material_ui/material_ui.dart';

/// A medical speciality shown in the dashboard category grid.
class HealthCategory {
  const HealthCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}
