import 'package:get/get.dart';
import 'package:podcast/controller/categories_controller.dart';
import 'package:podcast/controller/language_controller.dart';
import 'package:podcast/presentation/screens/admin/controller/admin_podcast_controller.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/screens/creator/donate/controller/donate_controller.dart';
import 'package:podcast/presentation/screens/creator/home/controller/creator_home_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_record_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_video_controller.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/history/controller/history_controller.dart';
import 'package:podcast/presentation/screens/notification/controller/notification_controller.dart';
import 'package:podcast/presentation/screens/playlist/controller/playlist_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/settings/controller/settings_controller.dart';
import 'package:podcast/presentation/screens/user/country/controller/country_select_controller.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/search/controller/user_search_controller.dart';
import 'package:podcast/presentation/screens/user/upgrade/controller/upgrade_controller.dart';
import 'package:podcast/presentation/screens/user/categories/controller/categories_controller.dart';

void initGetX() {

  //Global
  Get.lazyPut(() => LanguageController(), fenix: true);
  Get.lazyPut(() => GlobalCategoriesController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => ProfileController(), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);
  Get.lazyPut(() => SettingsController(), fenix: true);
  Get.lazyPut(() => FavoriteController(), fenix: true);
  Get.lazyPut(() => HistoryController(), fenix: true);
  Get.lazyPut(() => PlaylistController(), fenix: true);
  Get.lazyPut(() => AdminPodcastController(), fenix: true);

  //User
  Get.lazyPut(() => UserHomeController(), fenix: true);
  Get.lazyPut(() => CountrySelectController(), fenix: true);
  Get.lazyPut(() => UserSearchController(), fenix: true);
  Get.lazyPut(() => UpgradeController(), fenix: true);


  //Creator
  Get.lazyPut(() => CreatorHomeController(), fenix: true);
  Get.lazyPut(() => DonateController(), fenix: true);
  Get.lazyPut(() => PodcastController(), fenix: true);
  Get.lazyPut(() => PodcastAudioController(), fenix: true);
  Get.lazyPut(() => PodcastVideoController(), fenix: true);
  Get.lazyPut(() => PodcastRecordController(), fenix: true);
}