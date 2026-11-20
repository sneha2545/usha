import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import 'primary_button.dart';

/// Modal confirmation dialog used after local authentication actions.
Future<void> showSuccessDialog(
  BuildContext context, {
  required String title,
  required String message,
  String actionLabel = AppStrings.continueLabel,
  VoidCallback? onAction,
}) {
  final ThemeData theme = Theme.of(context);

  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: actionLabel,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    onAction?.call();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
