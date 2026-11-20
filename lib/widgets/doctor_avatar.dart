import 'package:material_ui/material_ui.dart';

import '../models/doctor.dart';

/// Circular doctor portrait with a gradient initials fallback.
class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({
    super.key,
    required this.doctor,
    this.size = 56,
    this.showBadge = true,
  });

  final Doctor doctor;
  final double size;
  final bool showBadge;

  static const List<List<Color>> _gradients = <List<Color>>[
    <Color>[Color(0xFF075E62), Color(0xFF15939A)],
    <Color>[Color(0xFF2D6CA8), Color(0xFF5C9FDB)],
    <Color>[Color(0xFF5E4B9E), Color(0xFF8E7CC9)],
    <Color>[Color(0xFFB0712F), Color(0xFFD9A15B)],
    <Color>[Color(0xFF2E7D5B), Color(0xFF63B48C)],
  ];

  @override
  Widget build(BuildContext context) {
    final int hash = doctor.id.codeUnits.fold<int>(
      0,
      (int sum, int unit) => sum + unit,
    );
    final List<Color> gradient = _gradients[hash % _gradients.length];
    final String? imageAsset = doctor.profileImageAsset?.trim();
    final Widget initialsFallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: Center(
        child: Text(
          doctor.initials,
          key: const Key('doctor_initials_fallback'),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.32,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
    final Widget portrait = imageAsset == null || imageAsset.isEmpty
        ? initialsFallback
        : Image.asset(
            imageAsset,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder:
                (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) => initialsFallback,
          );

    return SizedBox(
      width: size + (showBadge ? 4 : 0),
      height: size + (showBadge ? 4 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Semantics(
            image: true,
            label: 'Portrait of ${doctor.name}',
            child: ClipOval(
              child: SizedBox(
                width: size,
                height: size,
                child: portrait,
              ),
            ),
          ),
          if (showBadge && doctor.isVerified)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.34,
                height: size * 0.34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(size * 0.03),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E9E6B),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: size * 0.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
