import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/app_const/app_const.dart';

class ApiUrl {
  ApiUrl._();

  static const String base = "http://54.153.141.65:7010";
  static String googleSearchApi({required String search}) => 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=${AppConstants.googleMapAPI}';
  static String googleLetLongToAddressApi({required LatLng location}) => 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=${AppConstants.googleMapAPI}';

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
  static String playNext({required String id}) => '$base/podcast/play-next/$id';
  static String like({required String id}) => '$base/like/$id';
  static String favoriteAdd() => '$base/favorite/toggle';
  static String comments({required String id, required int page}) => '$base/comment/$id?page=$page&limit=10';
  static String commentsAdd({required String id}) => '$base/comment/$id';
  static String details({required String id}) => '$base/podcast/$id';
  static String subCategory({required String id, required String search}) => '$base/search/subcategories/$id?query=$search';
  static String favorite({required int page}) => '$base/favorite?limit=10&page=$page';
  static String history({required int page}) => '$base/history?page=$page&limit=10';
  static String search({required int page, required String search}) => '$base/search/podcasts?query=$search&page=$page&limit=10';
  static String playListCreate() => '$base/playlist/create';
  static String playList({required int page}) => '$base/playlist/?page=$page&limit=10';
  static String playListDelete({required String id}) => '$base/playlist/delete/$id';
  static String playListSongs({required String id, required int page}) => '$base/playlist/$id/podcasts?page=$page&limit=10';
  static String seeAll({required String type, required int page}) => '$base/podcast/$type?page=$page&limit=10';
  static String seeAllTopCreator({required int page}) => '$base/creator/top-creators?page=$page&limit=20';
  static String subCategoryPodcast({required String id, required int page}) => '$base/sub-category/$id/podcasts?page=$page&limit=10';
  static String addLocation() => '$base/user/update-location';
  static String notification({required int page}) => '$base/notification?limit=20&page=$page';
  static String adminPodcast({required int page}) => '$base/admin/podcasts?page=$page&limit=10';

  ///User
  static String home() => '$base/home';
  static String plan() => '$base/plan';
  static String payment({required String id}) => '$base/subscription/create/$id';

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
  static String faq() => '$base/faq';
}