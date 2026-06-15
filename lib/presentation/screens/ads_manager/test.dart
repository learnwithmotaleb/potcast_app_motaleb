import 'package:flutter/material.dart';
import 'banner_ad_service.dart';
import 'interstitial_ad_service.dart';
import 'app_open_ad_service.dart';
import 'rewarded_ad_service.dart';

class TestAds extends StatefulWidget {
  const TestAds({super.key});

  @override
  State<TestAds> createState() => _TestAdsState();
}

class _TestAdsState extends State<TestAds> {
  final BannerAdService _bannerService = BannerAdService();
  final InterstitialAdService _interstitialService = InterstitialAdService();
  final AppOpenAdService _appOpenService = AppOpenAdService();
  final RewardedAdService _rewardedService = RewardedAdService();

  @override
  void initState() {
    super.initState();
    // Pre‑load all ad types.
    _bannerService.onAdLoadedCallback = () {
      if (mounted) setState(() {});
    };
    _bannerService.load();
    _interstitialService.load();
    _appOpenService.load();
    _rewardedService.load();
  }

  @override
  void dispose() {
    _bannerService.dispose();
    _interstitialService.dispose();
    _appOpenService.dispose();
    _rewardedService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ad Manager Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async => await _bannerService.show(),
              child: const Text('Show Banner Ad'),
            ),
            // Show the banner widget directly after loading.
            if (_bannerService.getBannerAdWidget() != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _bannerService.getBannerAdWidget(),
              ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async => await _interstitialService.show(),
              child: const Text('Show Interstitial Ad'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async => await _appOpenService.show(),
              child: const Text('Show App‑Open Ad'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async => await _rewardedService.show(),
              child: const Text('Show Rewarded Ad'),
            ),
          ],
        ),
      ),
    );
  }
}
