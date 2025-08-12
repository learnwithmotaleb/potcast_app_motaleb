import 'package:get/get.dart';
import 'package:podcast/controller/global_controller.dart';
import 'package:podcast/controller/language_controller.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/screens/creator/donate/controller/donate_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/history/controller/history_controller.dart';
import 'package:podcast/presentation/screens/notification/controller/notification_controller.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/presentation/screens/playlist/controller/playlist_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/settings/controller/settings_controller.dart';
import 'package:podcast/presentation/screens/user/country/controller/country_select_controller.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/upgrade/controller/upgrade_controller.dart';

import '../../presentation/screens/categories/controller/categories_controller.dart';
import '../../presentation/screens/creator/nav/controller/creator_nav_controller.dart';
import '../../presentation/screens/play/controller/audio_play_controller.dart';
import '../../presentation/screens/search/controller/search_screen_controller.dart';
import '../../presentation/screens/see_all/controller/see_all_controller.dart';

void initGetX() {
  //Global
  Get.lazyPut(() => LanguageController(), fenix: true);
  Get.lazyPut(() => GlobalController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => ProfileController(), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);
  Get.lazyPut(() => SettingsController(), fenix: true);
  Get.lazyPut(() => FavoriteController(), fenix: true);
  Get.lazyPut(() => HistoryController(), fenix: true);
  Get.lazyPut(() => PlaylistController(), fenix: true);
  Get.lazyPut(() => AudioPlayController(), fenix: true);
  Get.lazyPut(() => PodcastFeedController(), fenix: true);
  Get.lazyPut(() => SearchScreenController(), fenix: true);
  Get.lazyPut(() => SeeAllController(), fenix: true);

  //User
  Get.lazyPut(() => UserHomeController(), fenix: true);
  Get.lazyPut(() => CountrySelectController(), fenix: true);
  Get.lazyPut(() => UpgradeController(), fenix: true);

  //Creator
  Get.lazyPut(() => CreatorNavController(), fenix: true);
  // Get.lazyPut(() => CreatorHomeController(), fenix: true);
  Get.lazyPut(() => DonateController(), fenix: true);
  // Get.lazyPut(() => PodcastController(), fenix: true);
  Get.lazyPut(() => PodcastAudioController(), fenix: true);
  // Get.lazyPut(() => PodcastVideoController(), fenix: true);
  // Get.lazyPut(() => PodcastRecordController(), fenix: true);
}
