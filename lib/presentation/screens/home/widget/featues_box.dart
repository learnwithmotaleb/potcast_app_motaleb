import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/home/model/home_model.dart';
import 'package:podcast/presentation/screens/home/widget/media_banner_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

/// Featured-albums section.
///
/// Structurally identical to [AdvertisingBox] — same full-width,
/// auto-sliding [PageView] of [MediaBannerCard]s — just with album copy and
/// a "Play now" call-to-action instead of ad copy and "View details".
class FeatureBox extends StatefulWidget {
  const FeatureBox({super.key});

  @override
  State<FeatureBox> createState() => _FeatureBoxState();
}

class _FeatureBoxState extends State<FeatureBox>
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
        final albums = _getAlbums();
        if (albums.isNotEmpty) {
          int nextIndex = (_pageController.page?.round() ?? 0) + 1;
          if (nextIndex >= albums.length) nextIndex = 0;
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

  void _openAlbum(HomeAlbumItem album) {
    AppRouter.route.pushNamed(
      RoutePath.albumPodcastScreen,
      extra: {
        'id': album.id,
        'title': album.name ?? '',
      },
    );
  }

  List<HomeAlbumItem> _getAlbums() {
    final apiAlbums = _ctrl.model.value.data?.albums;
    if (apiAlbums != null && apiAlbums.isNotEmpty) {
      return apiAlbums;
    }

    // Fallback dynamic dummy data so the UI is visible during development
    return [
      HomeAlbumItem(
        id: '1',
        name: 'Mr. Sexy Man: The Album',
        description: 'Nellie Tiger Travis',
        coverImage:
            'https://i.scdn.co/image/ab67616d0000b273b5b1574a7b7484a919f2d1e0',
      ),
      HomeAlbumItem(
        id: '2',
        name: 'Changes',
        description: 'Christopher Williams',
        coverImage:
            'https://i.scdn.co/image/ab67616d0000b273dbd32c58963cb5f23d463db8',
      ),
      HomeAlbumItem(
        id: '3',
        name: 'So So Def Bass All-Stars Vol. II',
        description: 'Various Artists',
        coverImage:
            'https://i.scdn.co/image/ab67616d0000b273dc7bb0ab7d079ebcb802058f',
      ),
      HomeAlbumItem(
        id: '4',
        name: 'Greatest Hits',
        description: '2Pac',
        coverImage:
            'https://i.scdn.co/image/ab67616d0000b27387cc8e7d7a17ddf0fb01b44c',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final albums = _getAlbums();
      if (albums.isEmpty) return const SizedBox.shrink();

      return FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: CustomText(
                      text: "Features",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AppRouter.route.pushNamed(RoutePath.albumSeeAllScreen);
                    },
                    child: Text("see_all".tr,
                        style: const TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
            LayoutBuilder(builder: (context, constraints) {
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
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    final album = albums[index];
                    final imageUrl = album.coverImage != null &&
                            album.coverImage!.isNotEmpty
                        ? (album.coverImage!.startsWith('http')
                            ? album.coverImage!
                            : 'https://api.preachradio.com${album.coverImage!}')
                        : '';
                    return MediaBannerCard(
                      imageUrl: imageUrl,
                      badgeText: 'Album',
                      title: album.name ?? '',
                      buttonLabel: 'Play now',
                      onTap: () => _openAlbum(album),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
