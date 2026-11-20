import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';

/// Primary call-to-action with the USHA gradient, depth and a loading state.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.loadingLabel,
    this.height = AppSizes.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final String? loadingLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: AnimatedOpacity(
        opacity: isEnabled ? 1 : 0.6,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isEnabled
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.32),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isEnabled ? onPressed : null,
              splashColor: Colors.white.withValues(alpha: 0.16),
              highlightColor: Colors.white.withValues(alpha: 0.08),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: isLoading
                        ? FittedBox(
                            key: const ValueKey<String>('loading'),
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: AppColors.textOnPrimary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  loadingLabel ?? label,
                                  style: textTheme.labelLarge?.copyWith(
                                    color: AppColors.textOnPrimary,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : FittedBox(
                            key: const ValueKey<String>('label'),
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  label,
                                  style: textTheme.labelLarge?.copyWith(
                                    color: AppColors.textOnPrimary,
                                    fontSize: 15,
                                  ),
                                ),
                                if (icon != null) ...<Widget>[
                                  const SizedBox(width: 10),
                                  Icon(
                                    icon,
                                    size: 19,
                                    color: AppColors.textOnPrimary,
                                  ),
                                ],
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
