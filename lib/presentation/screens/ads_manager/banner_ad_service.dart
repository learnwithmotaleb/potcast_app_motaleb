// This file has been removed; service implementation moved to lib/service layer.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_constants.dart';

/// Service responsible for handling banner advertisements.
class BannerAdService {
  final String _unitId = AdConfigKeys.testBannerUnitId;
  bool _isLoaded = false;
  BannerAd? _bannerAd;

  Function()? onAdLoadedCallback;

  /// Load the banner ad.
  Future<void> load() async {
    // Always attempt to load a real banner ad using test unit ID.
    _bannerAd = BannerAd(
      adUnitId: _unitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isLoaded = true;
          _bannerAd = ad as BannerAd;
          print('Banner ad loaded (unitId: $_unitId)');
          if (onAdLoadedCallback != null) onAdLoadedCallback!();
        },
        onAdFailedToLoad: (ad, error) {
          _isLoaded = false;
          ad.dispose();
          print('Banner ad failed to load: $error');
        },
        onAdClosed: (_) {
          _isLoaded = false;
          print('Banner ad closed');
        },
      ),
    );

    await _bannerAd!.load();


  }

  /// Show the banner ad. In this mock implementation we simply ensure it is loaded.
  /// In a real UI you would place the widget returned by getBannerAdWidget() in the widget tree.
  Future<void> show() async {
    if (!_isLoaded) {
      await load();
    }
    // No additional action needed; the ad widget can now be retrieved.
  }

  Widget? getBannerAdWidget() {
    if (!_isLoaded || _bannerAd == null) return null;
    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }

  /// Dispose the banner ad.
  void dispose() {
    _bannerAd?.dispose();
    _isLoaded = false;
  }
}
