// app_open_ad_service.dart

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_constants.dart';

/// Service responsible for handling app‑open advertisements.
class AppOpenAdService {
  final String _unitId = AdConfigKeys.testAppOpenUnitId;
  AppOpenAd? _appOpenAd;
  bool _isLoaded = false;

  /// Load the app‑open ad.
  Future<void> load() async {
    await AppOpenAd.load(
      adUnitId: _unitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isLoaded = true;
          print('App open ad loaded (unitId: $_unitId)');

          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _appOpenAd = null;
              _isLoaded = false;
              load();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _appOpenAd = null;
              _isLoaded = false;
              print('App open ad failed to show: $error');
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('App open ad failed to load: $error');
          _isLoaded = false;
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Dispose the app‑open ad.
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isLoaded = false;
    print('App open ad disposed');
  }

  /// Show the app‑open ad if it has been loaded.
  Future<void> show() async {
    if (_isLoaded && _appOpenAd != null) {
      print('Showing app open ad (unitId: $_unitId)');
      await _appOpenAd!.show();
    } else {
      print('App open ad not ready yet, loading...');
      await load();
    }
  }
}
