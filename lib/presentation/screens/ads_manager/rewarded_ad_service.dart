// rewarded_ad_service.dart

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_constants.dart';

/// Service responsible for handling rewarded advertisements.
class RewardedAdService {
  final String _unitId = AdConfigKeys.testRewardedUnitId;
  RewardedAd? _rewardedAd;
  bool _isLoaded = false;

  /// Load the rewarded ad.
  Future<void> load() async {
    await RewardedAd.load(
      adUnitId: _unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoaded = true;
          print('Rewarded ad loaded (unitId: $_unitId)');

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _isLoaded = false;
              load(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _isLoaded = false;
              print('Rewarded ad failed to show: $error');
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
          _isLoaded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Dispose the rewarded ad.
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoaded = false;
    print('Rewarded ad disposed');
  }

  /// Show the rewarded ad if it has been loaded.
  /// In a real implementation you would provide a callback to grant the reward.
  Future<void> show() async {
    if (_isLoaded && _rewardedAd != null) {
      print('Showing rewarded ad (unitId: $_unitId)');
      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          print('User earned reward: ${rewardItem.amount} ${rewardItem.type}');
          // TODO: implement actual user reward logic here
        },
      );
    } else {
      print('Rewarded ad not ready yet, loading...');
      await load();
    }
  }
}
