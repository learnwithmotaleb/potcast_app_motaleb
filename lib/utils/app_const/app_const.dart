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


  static const String baseUrl = "http://143.110.241.146:9000/";
  //SharedPreferences
  static const String token = "token";
  static const String id = "id";
  static const String role = "role";
  static const String email = "email";
  static const String location = "location";
}

enum Status { loading, error, completed, internetError, noDataFound }

