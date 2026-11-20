import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/primary_button.dart';

/// Bottom sheet that collects an email address and simulates sending a reset
/// link. Backend delivery will replace the local confirmation later.
class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isSending = false;
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSending = true);
    await Future<void>.delayed(AppDurations.shortRequest);
    if (!mounted) {
      return;
    }
    setState(() {
      _isSending = false;
      _isSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: SingleChildScrollView(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
            child: _isSent
                ? _buildConfirmation(theme)
                : Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.lock_reset_rounded,
                                size: 22,
                                color: AppColors.primaryDeep,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppStrings.forgotTitle,
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.forgotSubtitle,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          key: const Key('forgot_email_field'),
                          label: AppStrings.emailOrPhoneLabel,
                          hint: AppStrings.emailOrPhoneHint,
                          controller: _emailController,
                          prefixIcon: AppIcons.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autofillHints: const <String>[AutofillHints.email],
                          validator: Validators.email,
                          onFieldSubmitted: (_) => _sendResetLink(),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          key: const Key('forgot_submit_button'),
                          label: AppStrings.sendResetLink,
                          loadingLabel: 'Sending...',
                          icon: AppIcons.arrow,
                          isLoading: _isSending,
                          onPressed: _sendResetLink,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              AppStrings.signIn,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmation(ThemeData theme) {
    return Column(
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
            Icons.mark_email_read_outlined,
            size: 30,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          AppStrings.resetSentTitle,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a reset link to ${_emailController.text.trim()}. Check your inbox to continue.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: AppStrings.done,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
