import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_formatter.dart';
import '../models/patient.dart';

/// Read-only date of birth picker with automatic age preview.
class DateOfBirthField extends StatelessWidget {
  const DateOfBirthField({
    super.key,
    required this.value,
    required this.onChanged,
    this.tapKey,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final Key? tapKey;

  Future<void> _pickDate(BuildContext context, FormFieldState<DateTime> field) async {
    final DateTime now = DateTime.now();
    final DateTime initial =
        value ?? DateTime(now.year - 25, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select date of birth',
    );
    if (picked != null) {
      field.didChange(picked);
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FormField<DateTime>(
      initialValue: value,
      validator: (DateTime? date) {
        if (date == null) {
          return 'Select your date of birth';
        }
        if (date.isAfter(DateTime.now())) {
          return 'Date of birth cannot be in the future';
        }
        if (Patient.ageFrom(date) > 120) {
          return 'Enter a valid date of birth';
        }
        return null;
      },
      builder: (FormFieldState<DateTime> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                AppStrings.dateOfBirthLabel,
                style: theme.textTheme.labelMedium,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              key: tapKey,
              onTap: () => _pickDate(context, field),
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: field.errorText,
                  prefixIcon: const Icon(
                    Icons.cake_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_month_rounded,
                    size: 19,
                    color: AppColors.textSecondary,
                  ),
                ),
                isEmpty: value == null,
                child: Text(
                  value == null
                      ? 'Select your date of birth'
                      : AppDateFormatter.fullDate(value!),
                  style: value == null
                      ? theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        )
                      : theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                ),
              ),
            ),
            if (value != null) ...<Widget>[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${AppStrings.ageLabel}: ${Patient.ageFrom(value!)} years',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10.5,
                    color: AppColors.primaryDeep,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
