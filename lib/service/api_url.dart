class ApiUrl {
  ApiUrl._();

  static const String base = "http://192.168.10.220:8000";

  ///Auth
  static String register() => '$base/auth/register';
  static String activate() => '$base/auth/activate';
  static String otp() => '$base/auth/verify-otp';
  static String login() => '$base/auth/login';
  static String forget() => '$base/auth/forgot-password';
  static String verifyOtp() => '$base/auth/verify-otp';
  static String reset() => '$base/auth/reset-password';
  static String profile() => '$base/user';
  static String profileEdit() => '$base/user/update';
  static String changePassword() => '$base/auth/change-password';
  static String delete() => '$base/auth/delete';

  ///Global
  static String category() => '$base/category';

  ///User
  // static String category() => '$base/category';

  ///Creator
  static String podcastCreate() => '$base/podcast/create';

  ///Settings
  static String terms() => '$base/tac';
  static String privacy() => '$base/privacy';
  static String about() => '$base/about';
}