class ApiUrl {
  ApiUrl._();

  static const String base = "http://192.168.10.220:8000";

  static String register() => '$base/auth/register';
  static String activate() => '$base/auth/activate';
  static String otp() => '$base/auth/verify-otp';
  static String login() => '$base/auth/login';
  static String forget() => '$base/auth/forgot-password';
  static String verifyOtp() => '$base/auth/verify-otp';
  static String reset() => '$base/auth/reset-password';
}