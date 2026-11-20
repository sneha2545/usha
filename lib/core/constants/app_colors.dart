import 'package:material_ui/material_ui.dart';

/// Central colour palette for the USHA brand.
///
/// Keeping colours in one place makes it easy to keep the product visually
/// consistent as new screens are added.
abstract final class AppColors {
  static const Color primary = Color(0xFF0E8388);
  static const Color primaryDeep = Color(0xFF075E62);
  static const Color primarySoft = Color(0xFFE6F4F4);
  static const Color secondary = Color(0xFF2D7DD2);
  static const Color accent = Color(0xFF4FD1C5);

  static const Color background = Color(0xFFF6F9F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEEF5F5);

  static const Color textPrimary = Color(0xFF0F2A2D);
  static const Color textSecondary = Color(0xFF5D7579);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE1ECEC);

  static const Color success = Color(0xFF2E9E6B);
  static const Color danger = Color(0xFFD9534F);
  static const Color warning = Color(0xFFE2A03F);

  /// Signature brand gradient used for the logo, headers and primary actions.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF075E62), Color(0xFF0E8388), Color(0xFF249AA8)],
  );

  /// Softer gradient for large decorative header surfaces.
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF065456), Color(0xFF0B7478), Color(0xFF178F98)],
  );

  /// Very light gradient used behind auth forms.
  static const LinearGradient screenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFF3FAFA), Color(0xFFF8FBFB), Color(0xFFFFFFFF)],
  );
}
