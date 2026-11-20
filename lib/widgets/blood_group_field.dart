import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';

/// Blood group dropdown shared by registration and edit profile.
class BloodGroupField extends StatelessWidget {
  const BloodGroupField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<String> bloodGroups = <String>[
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            AppStrings.bloodGroupLabel,
            style: theme.textTheme.labelMedium,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          hint: Text(
            'Select blood group',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          icon: const Icon(
            Icons.expand_more_rounded,
            color: AppColors.textSecondary,
          ),
          validator: (String? group) =>
              group == null ? 'Select your blood group' : null,
          items: bloodGroups
              .map(
                (String group) => DropdownMenuItem<String>(
                  value: group,
                  child: Text(
                    group,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
