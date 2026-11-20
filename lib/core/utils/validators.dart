import '../constants/app_constants.dart';

/// Reusable form validation rules for authentication screens.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(
    r'^[\w.+-]+@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)+$',
  );

  static final RegExp _phonePattern = RegExp(r'^\+?[\d\s-]{10,15}$');
  static final RegExp _mobileInputPattern = RegExp(r'^\+?[\d -]+$');
  static final RegExp _indianMobilePattern = RegExp(r'^[6-9]\d{9}$');

  static String? emailOrPhone(String? value) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty) {
      return AppStrings.validationEmailOrPhone;
    }
    if (_emailPattern.hasMatch(input) || _phonePattern.hasMatch(input)) {
      return null;
    }
    return AppStrings.validationEmailOrPhone;
  }

  static String? email(String? value) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty || !_emailPattern.hasMatch(input)) {
      return AppStrings.validationEmail;
    }
    return null;
  }

  static String? mobile(String? value) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty || !_mobileInputPattern.hasMatch(input)) {
      return AppStrings.validationMobile;
    }

    final String normalized = input.replaceAll(RegExp(r'[ -]'), '');
    final String nationalNumber;
    if (input.startsWith('+')) {
      if (!input.startsWith('+91') || !normalized.startsWith('+91')) {
        return AppStrings.validationMobile;
      }
      nationalNumber = normalized.substring(3);
    } else {
      nationalNumber = normalized;
    }

    if (!_indianMobilePattern.hasMatch(nationalNumber)) {
      return AppStrings.validationMobile;
    }

    return null;
  }

  static String? name(String? value) {
    final String input = value?.trim() ?? '';
    if (input.length < 2) {
      return AppStrings.validationName;
    }
    return null;
  }

  static String? password(String? value) {
    final String input = value ?? '';
    if (input.isEmpty) {
      return AppStrings.validationPassword;
    }
    if (input.length < 6) {
      return AppStrings.validationPasswordShort;
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) {
      return AppStrings.validationPasswordMismatch;
    }
    return null;
  }

  static String? requiredField(
    String? value, {
    String message = 'This field is required',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? pinCode(String? value) {
    final String input = value?.trim() ?? '';
    if (!RegExp(r'^\d{6}$').hasMatch(input)) {
      return 'Enter a valid 6-digit PIN code';
    }
    return null;
  }

  static String? positiveNumber(String? value, {required String label}) {
    final int? parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid $label';
    }
    return null;
  }
}
