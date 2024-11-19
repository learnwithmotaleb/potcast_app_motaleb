import 'package:get/get.dart';
import 'package:podcast/controller/language_controller.dart';
import 'package:podcast/presentation/screens/notification/controller/notification_controller.dart';
import 'package:podcast/presentation/screens/playlist_add/controller/playlist_add_controller.dart';
import 'package:podcast/presentation/screens/user/categories/controller/categories_controller.dart';
import 'package:podcast/presentation/screens/user/country/controller/country_select_controller.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/play/controller/user_play_controller.dart';
import 'package:podcast/presentation/screens/user/search/controller/user_search_controller.dart';

void initGetX() {
  Get.lazyPut(() => LanguageController(), fenix: true);
  Get.lazyPut(() => UserHomeController(), fenix: true);
  Get.lazyPut(() => CountrySelectController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => UserSearchController(), fenix: true);
  Get.lazyPut(() => UserPlayController(), fenix: true);
  Get.lazyPut(() => PlaylistAddController(), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);
}