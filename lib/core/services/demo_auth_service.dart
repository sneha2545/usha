import '../constants/app_constants.dart';

/// Frontend-only authentication used for the USHA demo build.
///
/// Replace the body of [signIn] with the real API call when the backend is
/// ready; callers only depend on the returned success flag.
abstract final class DemoAuthService {
  static const String demoEmail = 'test@usha.com';
  static const String demoPassword = 'Usha@123';
  static const String demoUserName = 'Jordan Mathew';

  static Future<bool> signIn({
    required String identifier,
    required String password,
  }) async {
    await Future<void>.delayed(AppDurations.authRequest);
    return identifier.trim().toLowerCase() == demoEmail &&
        password == demoPassword;
  }
}
