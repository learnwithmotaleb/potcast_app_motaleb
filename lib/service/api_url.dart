import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';

import '../utils/app_const/app_const.dart';

class ApiUrl {
  ApiUrl._();

  // static const String base = "http://10.10.20.9:5088";
  static const String base = "https://api.preachradio.com"; // Live
  static String generatePreSignedURL() => "$base/generate-presigned-url";
  static String googleSearchApi({required String search}) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=${AppConstants.googleMapAPI}';
  static String googleLetLongToAddressApi({required LatLng location}) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=${AppConstants.googleMapAPI}';
  static String placeIdToLatLng({required String placeId}) =>
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=${AppConstants.googleMapAPI}';

  ///Auth
  static String register() => '$base/user/register-user';
  static String activate() => '$base/user/verify-code';
  static String activeOTPResend() => '$base/user/resend-verify-code';

  static String login() => '$base/auth/login';
  static String forget() => '$base/auth/forget-password';
  static String verifyOtp() => '$base/auth/verify-reset-otp';
  static String verifyOtpResend() => '$base/auth/resend-reset-code';
  static String reset() => '$base/auth/reset-password';

  static String refreshToken() => '$base/auth/refresh-token';
  static String profile() => '$base/user/get-my-profile';
  static String profileEdit() => '$base/user/update-profile';
  static String changePassword() => '$base/auth/change-password';
  static String delete() => '$base/user/delete-account';

  ///Global
  static String category() => '$base/category/all-categories';

  static String banner() => '$base/banner/get-all';

  static String createLive() => '$base/live-stream/create-streaming-room';
  static String getLive() => '$base/live-stream/get-my-live-room';
  static String endLive({required String id}) => '$base/live-stream/end-live/$id';

  static String playFeed({
    bool? reels,
    bool? popular,
    String? firstPodcastId,
    int page = 1,
    int limit = 40,
    bool isAlbum = false,
    bool isPlaylist = false,
    String? id,
  }) {
    if (isAlbum) {
      if (id == null || id.isEmpty) {
        toastMessage(message: "Playlist ID must be provided when isPlaylist = true");
        return "";
      }
      return "$base/album/get-single/$id";
    }

    if (isPlaylist) {
      if (id == null || id.isEmpty) {
        toastMessage(message: "Playlist ID must be provided when isPlaylist = true");
        return "";
      }
      return "$base/playlist/get-single/$id";
    }

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (reels == true) queryParams['reels'] = reels.toString();
    if (popular == true) queryParams['popular'] = popular.toString();
    if (firstPodcastId != null && firstPodcastId.isNotEmpty) {
      queryParams['firstPodcastId'] = firstPodcastId;
    }

    final queryString = Uri(queryParameters: queryParams).query;
    return '$base/podcast/get-podcast-feed${queryString.isNotEmpty ? '?$queryString' : ''}';
  }


  static String search({
    String searchTerm = "",
    required String pageKey,
    bool? reels,
    bool? popular,
    String? category,
    String? subCategory,
    String limit = "10",
  }) {
    final Map<String, String> queryParams = {};
    queryParams['page'] = pageKey;
    queryParams['limit'] = limit;

    if (reels != null && reels) queryParams['reels'] = reels.toString();
    if (popular != null && popular) queryParams['popular'] = popular.toString();
    if (category != null && category.isNotEmpty) queryParams['category'] = category;
    if (subCategory != null && subCategory.isNotEmpty) queryParams['subCategory'] = subCategory;
    if (searchTerm.isNotEmpty) queryParams["searchTerm"] = searchTerm;

    final queryString = Uri(queryParameters: queryParams).query;
    return '$base/podcast/all${queryString.isNotEmpty ? '?$queryString' : ''}';
  }

  static String seeAllAlbum({required int page}) => '$base/album/all-albums?page=$page&limit=20';
  static String singleAlbum({required String id}) => '$base/album/get-single/$id';
  static String like({required String id}) => '$base/podcast/like-unlike/$id';
  static String favoriteAdd({required String id}) => '$base/bookmark/add-delete-bookmark/$id';
  static String videPodcast({required String id}) => '$base/podcast/view/$id';
  static String comments({required String id, required int page}) => '$base/comment/get-podcast-comments/$id?page=$page&limit=30';
  static String commentsAdd() => '$base/comment/create';
  static String details({required String id}) => '$base/podcast/$id';
  static String subCategory({required String id}) => '$base/podcast/subcategory-with-podcasts/$id';
  static String favorite({required int page}) => '$base/bookmark/my-bookmarks?page=$page&limit=20';
  static String history({required int page}) => '$base/watch-history/get-all?page=$page&limit=10';
  static String playListCreate() => '$base/playlist/create';
  static String playList({required int page}) => '$base/playlist/my-playlists?page=$page&limit=20';
  static String playListDelete({required String id}) => '$base/playlist/delete/$id';
  static String playListSongs({required String id, required int page}) => '$base/playlist/get-single/$id';
  static String seeAll({required String type, required int page}) => '$base/podcast/$type?page=$page&limit=10';
  static String seeAllTopCreator({required int page}) => '$base/creator/get-top-creators?page=$page&limit=20';
  static String subCategoryPodcast({required String id, required int page}) => '$base/sub-category/$id/podcasts?page=$page&limit=10';
  static String addLocation() => '$base/user/update-location';
  static String notification({required int page}) => '$base/notification?limit=20&page=$page';
  static String adminPodcast({required int page}) => '$base/admin/podcasts?page=$page&limit=10';

  ///User
  static String home() => '$base/podcast/get-home-data';
  static String streamingRecord({int page = 1, int limit = 10 }) => '$base/live-session/get-previous-live?page=$page&limit=$limit&isPublic=true';
  static String plan() => '$base/plan';
  static String payment({required String id}) => '$base/subscription/create/$id';

  ///Creator
  static String podcast({required int page}) => '$base/podcast?page=$page&limit=10';
  static String myPodcast({required int page}) => '$base/podcast/my-podcasts?page=$page&limit=20';

  static String liveRecordings({required int page}) => '$base/live-session/get-my-previous-live?page=$page&limit=20';
  static String toggleRecord({required String id}) => '$base/live-session/toggle-private-public/$id';
  static String deleteRecord({required String id}) => '$base/live-session/delete/$id';
  static String updateInfo({required String id}) => '$base/live-session/update/$id';

  static String podcastCreate() => '$base/podcast/create';
  static String podcastEdit({required String id}) => '$base/podcast/update/$id';
  static String podcastDelete({required String id}) => '$base/podcast/delete/$id';

  ///Settings
  static String terms() => '$base/manage/get-terms-conditions';
  static String privacy() => '$base/manage/get-privacy-policy';
  static String about() => '$base/manage/get-about-us';
  static String faq() => '$base/manage/get-faq';
}
