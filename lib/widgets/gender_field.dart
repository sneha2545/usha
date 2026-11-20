import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/patient.dart';

/// Gender selector used by registration and edit profile.
class GenderField extends StatelessWidget {
  const GenderField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Gender? value;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FormField<Gender>(
      initialValue: value,
      validator: (Gender? gender) =>
          gender == null ? 'Select your gender' : null,
      builder: (FormFieldState<Gender> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                AppStrings.genderLabel,
                style: theme.textTheme.labelMedium,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final Gender gender in Gender.values)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('gender_${gender.name}'),
                      onTap: () {
                        field.didChange(gender);
                        onChanged(gender);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: value == gender
                              ? AppColors.primarySoft
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: value == gender
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : AppColors.border,
                            width: value == gender ? 1.4 : 1.2,
                          ),
                        ),
                        child: Text(
                          gender.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: value == gender
                                ? AppColors.primaryDeep
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  field.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.danger,
                    height: 1.35,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
