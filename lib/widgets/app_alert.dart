import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';

/// Inline status banner used for authentication feedback.
class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.message,
    this.tone = AppAlertTone.error,
  });

  final String message;
  final AppAlertTone tone;

  @override
  Widget build(BuildContext context) {
    final bool isError = tone == AppAlertTone.error;
    final Color foreground = isError ? AppColors.danger : AppColors.primaryDeep;
    final Color background = isError
        ? AppColors.danger.withValues(alpha: 0.08)
        : AppColors.primarySoft;
    final Color border = isError
        ? AppColors.danger.withValues(alpha: 0.22)
        : AppColors.primary.withValues(alpha: 0.18);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            size: 18,
            color: foreground,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AppAlertTone { error, info }
