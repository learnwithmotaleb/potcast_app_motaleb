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
  static String play({required String id}) => '$base/podcast/play/$id';
  static String like({required String id}) => '$base/like/$id';
  static String favoriteAdd() => '$base/favorite/toggle';
  static String comments({required String id, required int page}) => '$base/comment/$id?page=$page&limit=2';
  static String details({required String id}) => '$base/podcast/$id';

  static String favorite({required int page}) => '$base/favorite?limit=10&page=$page';
  static String history({required int page}) => '$base/history?page=$page&limit=10';

  ///User
  static String home() => '$base/home';

  ///Creator
  static String podcast({required int page}) => '$base/podcast?page=$page&limit=10';
  static String myPodcast({required int page}) => '$base/creator/all-podcasts?page=$page&limit=10';
  static String podcastCreate() => '$base/podcast/create';
  static String podcastEdit({required String id}) => '$base/podcast/update/$id';
  static String podcastDelete({required String id}) => '$base/podcast/delete/$id';

  ///Settings
  static String terms() => '$base/tac';
  static String privacy() => '$base/privacy';
  static String about() => '$base/about';
}