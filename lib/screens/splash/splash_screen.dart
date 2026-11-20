import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../auth/login_screen.dart';

/// Branded launch screen that previews the app identity and hands control to
/// the login flow once the intro animation completes.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _revealController;
  late final AnimationController _pulseController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _footerOpacity;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      vsync: this,
      duration: AppDurations.splashReveal,
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _logoOpacity = CurvedAnimation(
      parent: _revealController,
      curve: const Interval(0, 0.45, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _titleOpacity = CurvedAnimation(
      parent: _revealController,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _footerOpacity = CurvedAnimation(
      parent: _revealController,
      curve: const Interval(0.5, 1, curve: Curves.easeOut),
    );

    _navigationTimer = Timer(AppDurations.splashDelay, _openLogin);
  }

  void _openLogin() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: AppDurations.screenTransition,
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              );
            },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _revealController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppBackground(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEDF8F8),
            Color(0xFFF8FCFC),
            Color(0xFFFFFFFF),
          ],
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isCompact =
                  constraints.maxHeight < AppBreakpoints.compactHeight;
              final double logoSize = isCompact ? 88 : 112;
              final double titleSize = isCompact ? 38 : 46;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: <Widget>[
                    const Spacer(flex: 3),
                    _buildLogoStage(logoSize),
                    SizedBox(height: isCompact ? 26 : 34),
                    FadeTransition(
                      opacity: _titleOpacity,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                AppStrings.appName,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontSize: titleSize,
                                  letterSpacing: 12,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: 46,
                              height: 3.5,
                              decoration: BoxDecoration(
                                gradient: AppColors.brandGradient,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppStrings.tagline,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 4),
                    FadeTransition(
                      opacity: _footerOpacity,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: SizedBox(
                              width: isCompact ? 128 : 152,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 2200),
                                curve: Curves.easeInOutCubic,
                                builder: (
                                  BuildContext context,
                                  double value,
                                  Widget? child,
                                ) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    minHeight: 4,
                                    backgroundColor: AppColors.primarySoft,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Preparing your care experience',
                            style: theme.textTheme.bodySmall?.copyWith(
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isCompact ? 24 : 40),
                    if (constraints.maxHeight > 560)
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.verified_user_outlined,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppStrings.splashFooter,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.version,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoStage(double logoSize) {
    final double ringSize = logoSize + 64;

    return SizedBox(
      width: ringSize + 32,
      height: ringSize + 32,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _pulseController,
            builder: (BuildContext context, Widget? child) {
              final double progress = Curves.easeInOut.transform(
                _pulseController.value,
              );
              return Transform.scale(
                scale: 1 + 0.14 * progress,
                child: Container(
                  width: ringSize,
                  height: ringSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(
                        alpha: 0.16 * (1 - progress),
                      ),
                      width: 1.4,
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (BuildContext context, Widget? child) {
              final double progress = 1 - _pulseController.value;
              return Transform.scale(
                scale: 1 + 0.08 * progress,
                child: Container(
                  width: ringSize - 26,
                  height: ringSize - 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(
                        alpha: 0.35 * progress,
                      ),
                      width: 1.2,
                    ),
                  ),
                ),
              );
            },
          ),
          FadeTransition(
            opacity: _logoOpacity,
            child: ScaleTransition(
              scale: _logoScale,
              child: AppLogo(size: logoSize),
            ),
          ),
        ],
      ),
    );
  }
}
