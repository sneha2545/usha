import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/state/patient_scope.dart';
import '../../core/utils/validators.dart';
import '../../models/patient.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/blood_group_field.dart';
import '../../widgets/date_of_birth_field.dart';
import '../../widgets/form_section_card.dart';
import '../../widgets/gender_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/responsive_field_row.dart';

/// Editable patient profile saved into the shared [PatientStore].
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.patient});

  final Patient patient;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _houseController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pinController;

  late DateTime _dateOfBirth;
  late Gender _gender;
  late String _bloodGroup;

  @override
  void initState() {
    super.initState();
    final Patient patient = widget.patient;
    _nameController = TextEditingController(text: patient.fullName);
    _emailController = TextEditingController(text: patient.email);
    _mobileController = TextEditingController(text: patient.mobile);
    _heightController = TextEditingController(
      text: patient.heightCm.toString(),
    );
    _weightController = TextEditingController(
      text: patient.weightKg.toString(),
    );
    _houseController = TextEditingController(text: patient.houseNumber);
    _streetController = TextEditingController(text: patient.street);
    _cityController = TextEditingController(text: patient.city);
    _stateController = TextEditingController(text: patient.state);
    _pinController = TextEditingController(text: patient.pinCode);
    _dateOfBirth = patient.dateOfBirth;
    _gender = patient.gender;
    _bloodGroup = patient.bloodGroup;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final Patient updated = widget.patient.copyWith(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      mobile: _mobileController.text.trim(),
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      bloodGroup: _bloodGroup,
      heightCm: int.parse(_heightController.text.trim()),
      weightKg: int.parse(_weightController.text.trim()),
      houseNumber: _houseController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pinCode: _pinController.text.trim(),
    );

    PatientScope.of(context).save(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.profileUpdated)),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 20, 0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Back',
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 21,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        AppStrings.editProfile,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Keep your care profile up to date.',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 18),
                            FormSectionCard(
                              title: AppStrings.personalDetailsTitle,
                              icon: Icons.person_outline_rounded,
                              children: <Widget>[
                                AppTextField(
                                  key: const Key('edit_name_field'),
                                  label: AppStrings.fullNameLabel,
                                  controller: _nameController,
                                  prefixIcon: AppIcons.person,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  validator: Validators.name,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  key: const Key('edit_email_field'),
                                  label: AppStrings.emailLabel,
                                  controller: _emailController,
                                  prefixIcon: AppIcons.email,
                                  validator: (String? value) =>
                                      Validators.email(value?.trim()),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppStrings.emailProfileNote,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 10.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  key: const Key('edit_mobile_field'),
                                  label: AppStrings.mobileLabel,
                                  controller: _mobileController,
                                  prefixIcon: AppIcons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: Validators.mobile,
                                ),
                                const SizedBox(height: 16),
                                DateOfBirthField(
                                  key: const Key('edit_dob_wrapper'),
                                  tapKey: const Key('edit_dob_field'),
                                  value: _dateOfBirth,
                                  onChanged: (DateTime date) {
                                    setState(() => _dateOfBirth = date);
                                  },
                                ),
                                const SizedBox(height: 16),
                                GenderField(
                                  value: _gender,
                                  onChanged: (Gender gender) {
                                    setState(() => _gender = gender);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FormSectionCard(
                              title: AppStrings.healthInformationTitle,
                              icon: Icons.monitor_heart_outlined,
                              children: <Widget>[
                                BloodGroupField(
                                  key: const Key('edit_blood_group'),
                                  value: _bloodGroup,
                                  onChanged: (String? group) {
                                    if (group != null) {
                                      setState(() => _bloodGroup = group);
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                ResponsiveFieldRow(
                                  children: <Widget>[
                                    AppTextField(
                                      key: const Key('edit_height_field'),
                                      label: AppStrings.heightLabel,
                                      controller: _heightController,
                                      prefixIcon: Icons.height_rounded,
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) =>
                                          Validators.positiveNumber(
                                            value,
                                            label: 'height',
                                          ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                    ),
                                    AppTextField(
                                      key: const Key('edit_weight_field'),
                                      label: AppStrings.weightLabel,
                                      controller: _weightController,
                                      prefixIcon: Icons.monitor_weight_outlined,
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) =>
                                          Validators.positiveNumber(
                                            value,
                                            label: 'weight',
                                          ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FormSectionCard(
                              title: AppStrings.addressDetailsTitle,
                              icon: Icons.home_outlined,
                              children: <Widget>[
                                AppTextField(
                                  key: const Key('edit_house_field'),
                                  label: AppStrings.houseNumberLabel,
                                  controller: _houseController,
                                  prefixIcon: Icons.apartment_rounded,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  validator: (String? value) =>
                                      Validators.requiredField(
                                        value,
                                        message: 'Enter your house or flat',
                                      ),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  key: const Key('edit_street_field'),
                                  label: AppStrings.streetLabel,
                                  controller: _streetController,
                                  prefixIcon: Icons.location_on_outlined,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  validator: (String? value) =>
                                      Validators.requiredField(
                                        value,
                                        message: 'Enter your street or area',
                                      ),
                                ),
                                const SizedBox(height: 16),
                                ResponsiveFieldRow(
                                  children: <Widget>[
                                    AppTextField(
                                      key: const Key('edit_city_field'),
                                      label: AppStrings.cityLabel,
                                      controller: _cityController,
                                      prefixIcon: Icons.location_city_rounded,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: (String? value) =>
                                          Validators.requiredField(
                                            value,
                                            message: 'Enter your city',
                                          ),
                                    ),
                                    AppTextField(
                                      key: const Key('edit_state_field'),
                                      label: AppStrings.stateLabel,
                                      controller: _stateController,
                                      prefixIcon: Icons.map_outlined,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: (String? value) =>
                                          Validators.requiredField(
                                            value,
                                            message: 'Enter your state',
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  key: const Key('edit_pin_field'),
                                  label: AppStrings.pinCodeLabel,
                                  controller: _pinController,
                                  prefixIcon: Icons.pin_drop_outlined,
                                  keyboardType: TextInputType.number,
                                  validator: Validators.pinCode,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: OutlinedButton(
                                    key: const Key('edit_cancel_button'),
                                    onPressed: () =>
                                        Navigator.of(context).maybePop(),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(56),
                                    ),
                                    child: const Text(AppStrings.cancel),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: PrimaryButton(
                                    key: const Key('edit_save_button'),
                                    label: AppStrings.saveChanges,
                                    onPressed: _save,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
