import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';

/// USHA logo placeholder: a rounded gradient tile with a healthcare glyph.
///
/// Replace the inner icon with a branded asset later without touching any
/// screen that uses this widget.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 72,
    this.showShadow = true,
  });

  final double size;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'USHA logo',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(size * 0.3),
          boxShadow: showShadow
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primaryDeep.withValues(alpha: 0.28),
                    blurRadius: size * 0.32,
                    offset: Offset(0, size * 0.12),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: -size * 0.28,
              left: -size * 0.1,
              child: Container(
                width: size * 0.9,
                height: size * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Icon(
              Icons.health_and_safety_rounded,
              size: size * 0.52,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
