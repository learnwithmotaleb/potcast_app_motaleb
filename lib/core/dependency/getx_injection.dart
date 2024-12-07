import 'package:get/get.dart';
import 'package:podcast/controller/language_controller.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/screens/creator/donate/controller/donate_controller.dart';
import 'package:podcast/presentation/screens/creator/home/controller/creator_home_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/edit/controller/podcast_edit_controller.dart';
import 'package:podcast/presentation/screens/notification/controller/notification_controller.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/screens/playlist/add/controller/playlist_add_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/settings/controller/settings_controller.dart';
import 'package:podcast/presentation/screens/user/categories/controller/categories_controller.dart';
import 'package:podcast/presentation/screens/user/country/controller/country_select_controller.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/search/controller/user_search_controller.dart';

void initGetX() {

  //Global
  Get.lazyPut(() => LanguageController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => ProfileController(), fenix: true);
  Get.lazyPut(() => PlaylistAddController(), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);
  Get.lazyPut(() => SettingsController(), fenix: true);

  //User
  Get.lazyPut(() => UserHomeController(), fenix: true);
  Get.lazyPut(() => CountrySelectController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => UserSearchController(), fenix: true);
  Get.lazyPut(() => AudioPlayController(), fenix: true);


  //Creator
  Get.lazyPut(() => CreatorHomeController(), fenix: true);
  Get.lazyPut(() => DonateController(), fenix: true);
  Get.lazyPut(() => PodcastController(), fenix: true);
  Get.lazyPut(() => PodcastEditController(), fenix: true);
}