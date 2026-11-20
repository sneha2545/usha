import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';

/// Light, softly tinted background with blurred brand glows.
///
/// Used by the authentication screens so every page shares the same premium
/// atmosphere without repeating decoration code.
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.gradient = AppColors.screenGradient,
    this.showGlow = true,
  });

  final Widget child;
  final Gradient gradient;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (showGlow) ...<Widget>[
            const Positioned(
              top: -130,
              right: -110,
              child: _Glow(
                size: 320,
                color: Color(0x1A0E8388),
              ),
            ),
            const Positioned(
              bottom: -150,
              left: -120,
              child: _Glow(
                size: 340,
                color: Color(0x142D7DD2),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
