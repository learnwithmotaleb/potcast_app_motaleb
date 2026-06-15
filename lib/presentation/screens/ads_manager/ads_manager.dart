import 'package:flutter/material.dart';
import 'package:podcast/presentation/screens/ads_manager/app_open_ad_service.dart';
import 'package:podcast/presentation/screens/ads_manager/banner_ad_service.dart';
import 'package:podcast/presentation/screens/ads_manager/interstitial_ad_service.dart';

import 'package:podcast/presentation/screens/ads_manager/rewarded_ad_service.dart';

/// Centralized manager for all advertisement operations.
class AdManager {
  AdManager._();

  static final AdManager instance = AdManager._();

  // Flags controlled by remote config or subscription status
  bool _isPremiumUser = false;
  bool _bannerEnabled = true;
  bool _interstitialEnabled = true;
  bool _appOpenEnabled = true;
  bool _rewardedEnabled = true;

  // Action counter for frequency control
  int _actionCounter = 0;

  // Dedicated services for each ad type
  final BannerAdService _bannerService = BannerAdService();
  final InterstitialAdService _interstitialService = InterstitialAdService();
  final AppOpenAdService _appOpenService = AppOpenAdService();
  final RewardedAdService _rewardedService = RewardedAdService();

  /// Initialise the manager with premium flag and optional remote‑config overrides.
  Future<void> initialize({
    required bool isPremiumUser,
    bool bannerEnabled = true,
    bool interstitialEnabled = true,
    bool appOpenEnabled = true,
    bool rewardedEnabled = true,
  }) async {
    _isPremiumUser = isPremiumUser;
    _bannerEnabled = bannerEnabled;
    _interstitialEnabled = interstitialEnabled;
    _appOpenEnabled = appOpenEnabled;
    _rewardedEnabled = rewardedEnabled;

    // Load all enabled ads early so they are ready when needed.
    if (canShowBanner()) await _bannerService.load();
    if (canShowInterstitial()) await _interstitialService.load();
    if (canShowAppOpen()) await _appOpenService.load();
    if (canShowRewarded()) await _rewardedService.load();
  }

  bool get canShowAds => !_isPremiumUser;

  bool canShowBanner() => canShowAds && _bannerEnabled;
  bool canShowInterstitial() => canShowAds && _interstitialEnabled;
  bool canShowAppOpen() => canShowAds && _appOpenEnabled;
  bool canShowRewarded() => canShowAds && _rewardedEnabled;

  /// Record a user interaction that may trigger frequency‑based ads.
  void registerUserAction() {
    _actionCounter++;
  }

  /// Determines whether an interstitial should be shown based on the configured frequency.
  bool shouldShowInterstitial({int frequency = 5}) {
    if (!canShowInterstitial()) return false;
    return _actionCounter % frequency == 0;
  }

  // ---------------------------------------------------------------------
  // Public ad display helpers – delegate to the appropriate service.
  // ---------------------------------------------------------------------
  Future<void> showBanner() async {
    if (!canShowBanner()) return;
    await _bannerService.show();
  }

  Future<void> showInterstitial() async {
    if (!canShowInterstitial()) return;
    await _interstitialService.show();
  }

  Future<void> showAppOpen() async {
    if (!canShowAppOpen()) return;
    await _appOpenService.show();
  }

  Future<void> showRewarded() async {
    if (!canShowRewarded()) return;
    await _rewardedService.show();
  }
}
