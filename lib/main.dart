import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/core/theme/dark_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'controller/language_controller.dart';
import 'core/dependency/getx_injection.dart';
import 'core/dependency/path.dart';
import 'core/route/routes.dart';
import 'core/theme/light_theme.dart';
import 'helper/device_utils/device_utils.dart';
import 'utils/app_const/app_const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  //Background Audio Player
  await JustAudioBackground.init(
    androidNotificationChannelId: "com.ryanheise.audio_service.podcast.audio_player",
    androidNotificationChannelName: "Audio playback",
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    androidNotificationClickStartsActivity: true,
    androidNotificationIcon: 'drawable/ic_stat_music_note',
    preloadArtwork: true,
    rewindInterval: const Duration(seconds: 15),
  );

  DeviceUtils.lockDevicePortrait();
  initGetX();
  initDependencies();

  await Purchases.setLogLevel(LogLevel.debug);
  await Purchases.configure(PurchasesConfiguration(AppConstants.revenueCatApiKey));

  //Localization
  Map<String, Map<String, String>>? languages = await LanguageController.getLanguages();

  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.languages});

  final Map<String, Map<String, String>>? languages;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      init: Get.find<LanguageController>(),
      builder: (localizeController) {
        return GetMaterialApp.router(
          debugShowCheckedModeBanner: false,

          //Route Section
          routeInformationParser: AppRouter.route.routeInformationParser,
          routerDelegate: AppRouter.route.routerDelegate,
          routeInformationProvider:
          AppRouter.route.routeInformationProvider,

          //Theme Section
          themeMode: ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,

          //Languages Section
          locale: localizeController.locale,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(
            AppConstants.languages.first.languageCode,
            AppConstants.languages.first.countryCode,
          ),
        );
      },
    );
  }
}
