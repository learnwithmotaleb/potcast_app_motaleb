import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static final RewardedAdService _instance = RewardedAdService._internal();
  factory RewardedAdService() => _instance;
  RewardedAdService._internal();

  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  String get _adUnitId {
    return Platform.isAndroid
        ? "ca-app-pub-3940256099942544/5224354917"
        : "ca-app-pub-3940256099942544/1712485313";
  }

  /// Load rewarded ad safely
  Future<void> loadAd() async {
    if (_isLoading || _rewardedAd != null) return;

    _isLoading = true;
    try {
      RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint("🎉 Rewarded ad loaded successfully");
            _rewardedAd = ad;
            _isLoading = false;
          },
          onAdFailedToLoad: (error) {
            debugPrint("❌ Failed to load rewarded ad: $error");
            _rewardedAd = null;
            _isLoading = false;
          },
        ),
      );
    } catch (e, st) {
      debugPrint("💥 Exception during ad load: $e");
      debugPrint("📍 Stack trace: $st");
      _rewardedAd = null;
      _isLoading = false;
    }
  }

  /// Show rewarded ad safely
  Future<void> showAd({Function()? onEarnedReward}) async {
    if (_rewardedAd == null) {
      debugPrint("⚠️ No rewarded ad available, continuing playback...");
      await loadAd(); // preload for next time
      return;
    }

    try {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          loadAd(); // preload next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint("❌ Ad failed to show: $error");
          ad.dispose();
          _rewardedAd = null;
          loadAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint("✅ User earned reward: ${reward.amount} ${reward.type}");
          onEarnedReward?.call();
        },
      );
    } catch (e, st) {
      debugPrint("💥 Exception during ad show: $e");
      debugPrint("📍 Stack trace: $st");
      _rewardedAd = null;
      await loadAd(); // try to preload next ad
    }
  }
}
