import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/core/theme/dark_theme.dart';
import 'controller/language_controller.dart';
import 'core/dependency/getx_injection.dart';
import 'core/dependency/path.dart';
import 'core/route/routes.dart';
import 'core/theme/light_theme.dart';
import 'helper/device_utils/device_utils.dart';
import 'utils/app_const/app_const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Background Audio Player
  await JustAudioBackground.init(
    androidNotificationChannelId: "com.ryanheise.audio_service.podcast.audio_player",
    androidNotificationChannelName: "Audio playback",
    androidNotificationOngoing: true,
  );

  DeviceUtils.lockDevicePortrait();
  initGetX();
  initDependencies();

  //Localization
  Map<String, Map<String, String>>? languages = await LanguageController.getLanguages();

  runApp(MyApp(languages: languages));
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp(languages: languages)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.languages});

  final Map<String, Map<String, String>>? languages;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      init: Get.find<LanguageController>(),
      builder: (localizeController) {
        return ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          useInheritedMediaQuery: true,
          builder: (context, child){
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            _setGlobalStatusBarStyle(isDarkMode);
            return GetMaterialApp.router(
              debugShowCheckedModeBanner: false,

              //Route Section
              routeInformationParser: AppRouter.route.routeInformationParser,
              routerDelegate: AppRouter.route.routerDelegate,
              routeInformationProvider: AppRouter.route.routeInformationProvider,

              //Theme Section
              themeMode: ThemeMode.dark,
              theme: lightTheme,
              darkTheme: darkTheme,

              //Languages Section
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode,
              ),
            );
          },
        );
      },
    );
  }

  void _setGlobalStatusBarStyle(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDarkMode ? Colors.black : Colors.white, // Background color
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, // Icon brightness
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light, // iOS compatibility
      ),
    );
  }
}