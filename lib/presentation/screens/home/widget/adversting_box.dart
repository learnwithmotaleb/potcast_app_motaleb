import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/model/banner_model.dart';
import 'package:podcast/presentation/screens/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/home/widget/media_banner_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Spotify-style inline advertising banner card.
///
/// Reads from [UserHomeController.bannerModel] and is completely hidden for
/// premium users (when [UserHomeController.shouldShowBanners] is false).
///
/// Layout mirrors the design reference:
///  - Full-width image (16 : 7 aspect ratio)
///  - Semi-transparent "Advertisement" badge top-left
///  - Sponsor label bottom-left  +  white "View details" pill bottom-right
class AdvertisingBox extends StatefulWidget {
  const AdvertisingBox({super.key});

  @override
  State<AdvertisingBox> createState() => _AdvertisingBoxState();
}

class _AdvertisingBoxState extends State<AdvertisingBox>
    with SingleTickerProviderStateMixin {
  final _ctrl = Get.find<UserHomeController>();

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    _pageController = PageController();

    // Auto-slide every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final banners = _getBanners();
        if (banners.isNotEmpty) {
          int nextIndex = (_pageController.page?.round() ?? 0) + 1;
          if (nextIndex >= banners.length) nextIndex = 0;
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _launch(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  /// Extracts a readable sponsor name from the redirect URL host.
  String _sponsorName(String? redirectUrl) {
    if (redirectUrl == null || redirectUrl.isEmpty) return 'Sponsored';
    try {
      final uri = Uri.tryParse(redirectUrl);
      final host = uri?.host ?? '';
      final clean = host.replaceFirst(RegExp(r'^www\.'), '');
      final parts = clean.split('.');
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        final n = parts[0];
        return '${n[0].toUpperCase()}${n.substring(1)}';
      }
    } catch (_) {}
    return 'Sponsored';
  }

  List<BannerItem> _getBanners() {
    final apiBanners = _ctrl.bannerModel.value.data;
    if (apiBanners != null && apiBanners.isNotEmpty) {
      return apiBanners;
    }

    // Fallback dummy banners for UI display
    return [
      BannerItem(
        bannerUrl: 'https://images.unsplash.com/photo-1542204165-65bf26472b9b',
        redirectUrl: 'https://www.google.com',
      ),
      BannerItem(
        bannerUrl:
            'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
        redirectUrl: 'https://www.apple.com',
      ),
      BannerItem(
        bannerUrl:
            'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
        redirectUrl: 'https://www.spotify.com',
      ),
      BannerItem(
        bannerUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
        redirectUrl: 'https://www.amazon.com',
      ),
      BannerItem(
        bannerUrl:
            'https://images.unsplash.com/photo-1493225457124-a1a2a5f5221b',
        redirectUrl: 'https://www.netflix.com',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Hide for premium users
      if (!_ctrl.shouldShowBanners.value) return const SizedBox.shrink();

      final banners = _getBanners();
      if (banners.isEmpty) return const SizedBox.shrink();

      return FadeTransition(
        opacity: _fadeAnim,
        child: LayoutBuilder(builder: (context, constraints) {
          // Calculate a fixed height for the PageView based on the image aspect ratio + bottom row
          final width = constraints.maxWidth;
          final imageHeight = (width - 24) * 7 / 16;
          final bottomRowHeight = 60.0;
          final padding = 16.0;
          final totalHeight = imageHeight + bottomRowHeight + padding;

          return SizedBox(
            height: totalHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                final imageUrl =
                    banner.bannerUrl != null && banner.bannerUrl!.isNotEmpty
                        ? (banner.bannerUrl!.startsWith('http')
                            ? banner.bannerUrl!
                            : 'https://api.preachradio.com${banner.bannerUrl!}')
                        : '';
                return MediaBannerCard(
                  imageUrl: imageUrl,
                  badgeText: 'Advertisement',
                  title: _sponsorName(banner.redirectUrl),
                  buttonLabel: 'View details',
                  onTap: () => _launch(banner.redirectUrl),
                );
              },
            ),
          );
        }),
      );
    });
  }
}
