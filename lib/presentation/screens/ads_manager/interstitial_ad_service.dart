// interstitial_ad_service.dart

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_constants.dart';

/// Service responsible for handling interstitial advertisements.
class InterstitialAdService {
  final String _unitId = AdConfigKeys.testInterstitialUnitId;
  InterstitialAd? _interstitialAd;
  bool _isLoaded = false;

  /// Load the interstitial ad.
  Future<void> load() async {
    await InterstitialAd.load(
      adUnitId: _unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoaded = true;
          print('Interstitial ad loaded (unitId: $_unitId)');
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isLoaded = false;
              load(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isLoaded = false;
              print('Interstitial ad failed to show: $error');
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
          _isLoaded = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Dispose the interstitial ad.
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoaded = false;
    print('Interstitial ad disposed');
  }

  /// Show the interstitial ad if it has been loaded.
  Future<void> show() async {
    if (_isLoaded && _interstitialAd != null) {
      print('Showing interstitial ad (unitId: $_unitId)');
      await _interstitialAd!.show();
    } else {
      print('Interstitial ad not ready yet, loading...');
      await load();
    }
  }
}
