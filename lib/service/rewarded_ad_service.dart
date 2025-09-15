import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static final RewardedAdService _instance = RewardedAdService._internal();
  factory RewardedAdService() => _instance;
  RewardedAdService._internal();

  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  // Audio state management
  bool _wasPlayingBeforeAd = false;
  Function()? _onAdDismissed;

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

  /// Show rewarded ad with audio management
  Future<void> showAd({
    Function()? onEarnedReward,
    Function()? onPauseAudio,
    Function()? onResumeAudio,
  }) async {
    if (_rewardedAd == null) {
      debugPrint("⚠️ No rewarded ad available, continuing playback...");
      await loadAd(); // preload for next time
      return;
    }

    try {
      // Store the resume callback
      _onAdDismissed = onResumeAudio;

      // Pause audio before showing ad
      if (onPauseAudio != null) {
        debugPrint("⏸️ Pausing audio before ad");
        onPauseAudio();
        _wasPlayingBeforeAd = true;
      }

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint("📺 Ad is now showing full screen");
        },
        onAdDismissedFullScreenContent: (ad) {
          debugPrint("✅ Ad dismissed, cleaning up...");
          ad.dispose();
          _rewardedAd = null;

          // Resume audio after ad is dismissed
          _resumeAudioAfterAd();

          // Preload next ad
          loadAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint("❌ Ad failed to show: $error");
          ad.dispose();
          _rewardedAd = null;

          // Resume audio if ad failed to show
          _resumeAudioAfterAd();

          loadAd();
        },
      );

      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint("✅ User earned reward: ${reward.amount} ${reward.type}");
          onEarnedReward?.call();
        },
      );
    } catch (e, st) {
      debugPrint("💥 Exception during ad show: $e");
      debugPrint("📍 Stack trace: $st");
      _rewardedAd = null;

      // Resume audio if there was an exception
      _resumeAudioAfterAd();

      await loadAd(); // try to preload next ad
    }
  }

  void _resumeAudioAfterAd() {
    if (_wasPlayingBeforeAd && _onAdDismissed != null) {
      debugPrint("▶️ Resuming audio after ad");
      // Add a small delay to ensure ad resources are fully released
      Future.delayed(const Duration(milliseconds: 500), () {
        _onAdDismissed?.call();
        _wasPlayingBeforeAd = false;
        _onAdDismissed = null;
      });
    } else {
      _wasPlayingBeforeAd = false;
      _onAdDismissed = null;
    }
  }

  /// Dispose resources
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _wasPlayingBeforeAd = false;
    _onAdDismissed = null;
  }
}