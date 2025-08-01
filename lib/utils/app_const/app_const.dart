import 'package:podcast/model/basic/language_model.dart';

class AppConstants {
  //Language
  static const String languageCode = "languagesCode";
  static const String countryCode = "countryCode";
  static const String selectedValue = "selectedValue";
  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: "", languageName: 'English', countryCode: 'US', languageCode: 'en'),
    // LanguageModel(imageUrl: "", languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  ];

  static const String googleMapAPI = "AIzaSyAszXC1be8aJ37eHuNcBm_-O1clWkPUwV4";

  static const String baseUrl = "http://182.252.68.230:7003";
  static const String bannerAndroid = "ca-app-pub-3940256099942544/9214589741";
  static const String bannerIOS = 'ca-app-pub-3940256099942544/2435281174';
  //SharedPreferences
  static const String token = "token";
  static const String refreshToken = "refresh_token";
  static const String id = "id";
  static const String role = "role";
  static const String profileId = "profile_id";
  static const String location = "location";
}

enum Status { loading, error, completed, internetError, noDataFound }

enum SelectedAddPostScreenType {
  // video,
  audio,
  // record,
  // live,
  none
}


