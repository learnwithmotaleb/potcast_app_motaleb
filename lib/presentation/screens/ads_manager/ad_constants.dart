// ad_constants.dart

import 'package:flutter/foundation.dart';

enum AdType {
  banner,
  interstitial,
  appOpen,
  rewarded,
}

class AdConfigKeys {
  // Remote config keys
  static const String showBannerAds = 'show_banner_ads';
  static const String showInterstitialAds = 'show_interstitial_ads';
  static const String showAppOpenAds = 'show_app_open_ads';
  static const String showRewardedAds = 'show_rewarded_ads';

  // Android test unit IDs
  static const String _androidBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _androidInterstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _androidRewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _androidAppOpenUnitId = 'ca-app-pub-3940256099942544/3419835294';

  // iOS test unit IDs
  static const String _iosBannerUnitId = 'ca-app-pub-3940256099942544/2934735716';
  static const String _iosInterstitialUnitId = 'ca-app-pub-3940256099942544/4411468910';
  static const String _iosRewardedUnitId = 'ca-app-pub-3940256099942544/1712485313';
  static const String _iosAppOpenUnitId = 'ca-app-pub-3940256099942544/5662855259';

  // Getters that select the appropriate ID based on the platform
  static String get testBannerUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS ? _iosBannerUnitId : _androidBannerUnitId;
  static String get testInterstitialUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS ? _iosInterstitialUnitId : _androidInterstitialUnitId;
  static String get testRewardedUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS ? _iosRewardedUnitId : _androidRewardedUnitId;
  static String get testAppOpenUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS ? _iosAppOpenUnitId : _androidAppOpenUnitId;
}
