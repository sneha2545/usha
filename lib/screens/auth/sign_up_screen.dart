import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/state/patient_scope.dart';
import '../../core/utils/validators.dart';
import '../../models/patient.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/blood_group_field.dart';
import '../../widgets/date_of_birth_field.dart';
import '../../widgets/form_section_card.dart';
import '../../widgets/gender_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/responsive_field_row.dart';
import '../../widgets/success_dialog.dart';
import '../home/home_screen.dart';

/// Detailed patient registration with personal, security, health and address
/// sections. Saves locally into [PatientStore] and opens the dashboard.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  DateTime? _dateOfBirth;
  Gender? _gender;
  String? _bloodGroup;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(AppDurations.authRequest);
    if (!mounted) {
      return;
    }

    final Patient patient = Patient(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      mobile: _mobileController.text.trim(),
      dateOfBirth: _dateOfBirth!,
      gender: _gender!,
      bloodGroup: _bloodGroup!,
      heightCm: int.parse(_heightController.text.trim()),
      weightKg: int.parse(_weightController.text.trim()),
      houseNumber: _houseController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pinCode: _pinController.text.trim(),
    );

    PatientScope.of(context).save(patient);
    setState(() => _isSubmitting = false);

    await showSuccessDialog(
      context,
      title: AppStrings.registrationSuccessTitle,
      message:
          'Welcome to USHA, ${patient.firstName}. Your health profile is '
          'ready and available across the app.',
      actionLabel: AppStrings.goToDashboard,
    );

    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HomeScreen(),
      ),
      (Route<dynamic> route) => false,
    );
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
              _buildHeader(theme),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
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
                              AppStrings.signUpTitle,
                              style: theme.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'A few details to set up your care profile.',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 22),
                            FormSectionCard(
                              title: AppStrings.personalDetailsTitle,
                              icon: Icons.person_outline_rounded,
                              children: <Widget>[
                                AppTextField(
                                  key: const Key('signup_name_field'),
                                  label: AppStrings.fullNameLabel,
                                  hint: AppStrings.fullNameHint,
                                  controller: _nameController,
                                  prefixIcon: AppIcons.person,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  autofillHints: const <String>[
                                    AutofillHints.name,
                                  ],
                                  validator: Validators.name,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  key: const Key('signup_email_field'),
                                  label: AppStrings.emailLabel,
                                  hint: AppStrings.emailOrPhoneHint,
                                  controller: _emailController,
                                  prefixIcon: AppIcons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  autofillHints: const <String>[
                                    AutofillHints.email,
                                  ],
                                  validator: Validators.email,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  key: const Key('signup_mobile_field'),
                                  label: AppStrings.mobileLabel,
                                  hint: AppStrings.mobileHint,
                                  controller: _mobileController,
                                  prefixIcon: AppIcons.phone,
                                  keyboardType: TextInputType.phone,
                                  autofillHints: const <String>[
                                    AutofillHints.telephoneNumber,
                                  ],
                                  validator: Validators.mobile,
                                ),
                                const SizedBox(height: 16),
                                DateOfBirthField(
                                  key: const Key('signup_dob_wrapper'),
                                  tapKey: const Key('signup_dob_field'),
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
                              title: AppStrings.accountSecurityTitle,
                              icon: Icons.lock_outline_rounded,
                              children: <Widget>[
                                AppTextField(
                                  key: const Key('signup_password_field'),
                                  label: AppStrings.passwordLabel,
                                  hint: AppStrings.passwordHint,
                                  controller: _passwordController,
                                  prefixIcon: AppIcons.lock,
                                  obscureText: _obscurePassword,
                                  onToggleObscure: () {
                                    setState(
                                      () => _obscurePassword =
                                          !_obscurePassword,
                                    );
                                  },
                                  autocorrect: false,
                                  autofillHints: const <String>[
                                    AutofillHints.newPassword,
                                  ],
                                  validator: Validators.password,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  key: const Key(
                                    'signup_confirm_password_field',
                                  ),
                                  label: AppStrings.confirmPasswordLabel,
                                  hint: AppStrings.confirmPasswordHint,
                                  controller: _confirmPasswordController,
                                  prefixIcon: AppIcons.lock,
                                  obscureText: _obscureConfirmPassword,
                                  onToggleObscure: () {
                                    setState(
                                      () => _obscureConfirmPassword =
                                          !_obscureConfirmPassword,
                                    );
                                  },
                                  autocorrect: false,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const <String>[
                                    AutofillHints.newPassword,
                                  ],
                                  validator: (String? value) =>
                                      Validators.confirmPassword(
                                        value,
                                        _passwordController.text,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FormSectionCard(
                              title: AppStrings.healthInformationTitle,
                              icon: Icons.monitor_heart_outlined,
                              children: <Widget>[
                                BloodGroupField(
                                  key: const Key('signup_blood_group'),
                                  value: _bloodGroup,
                                  onChanged: (String? group) {
                                    setState(() => _bloodGroup = group);
                                  },
                                ),
                                const SizedBox(height: 16),
                                ResponsiveFieldRow(
                                  children: <Widget>[
                                    AppTextField(
                                      key: const Key('signup_height_field'),
                                      label: AppStrings.heightLabel,
                                      hint: '176',
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
                                      key: const Key('signup_weight_field'),
                                      label: AppStrings.weightLabel,
                                      hint: '72',
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
                                  key: const Key('signup_house_field'),
                                  label: AppStrings.houseNumberLabel,
                                  hint: '12B',
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
                                  key: const Key('signup_street_field'),
                                  label: AppStrings.streetLabel,
                                  hint: 'Street, area or landmark',
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
                                      key: const Key('signup_city_field'),
                                      label: AppStrings.cityLabel,
                                      hint: 'Bengaluru',
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
                                      key: const Key('signup_state_field'),
                                      label: AppStrings.stateLabel,
                                      hint: 'Karnataka',
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
                                  key: const Key('signup_pin_field'),
                                  label: AppStrings.pinCodeLabel,
                                  hint: '560001',
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
                            const SizedBox(height: 18),
                            Text(
                              "By continuing, you agree to USHA's Terms of "
                              'Service and Privacy Policy.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              key: const Key('signup_submit_button'),
                              label: AppStrings.registerButton,
                              loadingLabel: AppStrings.registering,
                              icon: AppIcons.arrow,
                              isLoading: _isSubmitting,
                              onPressed: _register,
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Text(
                                  AppStrings.haveAccount,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 12.5,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 6,
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings.signIn,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
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

  Widget _buildHeader(ThemeData theme) {
    return Padding(
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
          const AppLogo(size: 34, showShadow: false),
          const SizedBox(width: 10),
          Text(
            AppStrings.appName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 3.6,
            ),
          ),
          const Spacer(),
          Text(
            AppStrings.signUp,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
