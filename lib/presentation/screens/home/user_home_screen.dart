import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/extension/base_extension.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/model/banner_model.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/home/widget/featues_box.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/reels/mock_reels_preview_screen.dart';
import 'package:podcast/presentation/widget/bottom_nav_play_card.dart';
import 'package:podcast/presentation/widget/card/home_music_card.dart';
import 'package:podcast/presentation/widget/card/home_reels_card.dart';
import 'package:podcast/presentation/widget/card/home_series_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/presentation/widget/loader/app_loader_custom.dart';
import 'package:podcast/presentation/widget/card/modern_streaming_card.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller/user_home_controller.dart';
import 'model/home_model.dart';
import 'widget/user_home_categories_section.dart';
import 'widget/user_home_top_section.dart';
import 'widget/user_top_artists_section.dart';
import 'widget/adversting_box.dart';
import 'widget/featues_box.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final controller = Get.find<UserHomeController>();
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ever(controller.loadingBanner, (status) async {
        if (!controller.shouldShowBanners.value) return;
        if (status == Status.completed &&
            controller.bannerModel.value.data != null &&
            controller.bannerModel.value.data!.isNotEmpty) {
          final shouldShow =
              await controller.dbHelper.shouldShowBanner(secondsGap: 10);
          final random = math.Random().nextBool();
          if (shouldShow && random) {
            _showFullScreenBanner(controller.bannerModel.value.data ?? []);
            await controller.dbHelper.markBannerShown();
          }
        }
      });
    });
  }

  bool _isDialogOpen = false;

  // ===================== PREVIEW-ONLY MOCK DATA =====================
  // Used only when the backend returns empty `reels` / `albums` lists, so
  // the Praise Clips / Series sections aren't blank while showing the
  // client a design preview. Safe to delete this whole block once real
  // Clip and Series content exists on the server.
  static final List<HomeNewestPodcast> _mockReelItems = [
    HomeNewestPodcast(
      id: "mock-reel-1",
      title: "Sunday Praise Moment",
      coverImage: "https://picsum.photos/id/1011/400/700",
      podcastUrl: "",
      duration: 45,
    ),
    HomeNewestPodcast(
      id: "mock-reel-2",
      title: "Worship Highlight",
      coverImage: "https://picsum.photos/id/1025/400/700",
      podcastUrl: "",
      duration: 38,
    ),
    HomeNewestPodcast(
      id: "mock-reel-3",
      title: "Youth Testimony",
      coverImage: "https://picsum.photos/id/1027/400/700",
      podcastUrl: "",
      duration: 52,
    ),
    HomeNewestPodcast(
      id: "mock-reel-4",
      title: "Choir Special",
      coverImage: "https://picsum.photos/id/1035/400/700",
      podcastUrl: "",
      duration: 29,
    ),
    HomeNewestPodcast(
      id: "mock-reel-5",
      title: "Prayer Clip",
      coverImage: "https://picsum.photos/id/1039/400/700",
      podcastUrl: "",
      duration: 41,
    ),
  ];

  // Sample public videos so tapping a mock clip actually plays something
  // reels-style. Keyed by the mock item's id.
  static const Map<String, String> _mockReelVideoUrls = {
    "mock-reel-1":
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4",
    "mock-reel-2":
        "https://test-videos.co.uk/vids/sintel/mp4/h264/360/Sintel_360_10s_1MB.mp4",
    "mock-reel-3":
        "https://test-videos.co.uk/vids/jellyfish/mp4/h264/360/Jellyfish_360_10s_1MB.mp4",
    "mock-reel-4":
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_2MB.mp4",
    "mock-reel-5":
        "https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4",
  };

  List<PlayEntity> _mockReelPlayEntities() => _mockReelItems
      .map((e) => PlayEntity(
            id: e.id ?? "",
            title: e.title ?? "",
            podcastUrl: _mockReelVideoUrls[e.id] ?? "",
            coverImage: e.coverImage ?? "",
            creatorName: "Preview Creator",
            isLike: false,
            isBookmark: false,
          ))
      .toList();

  static final List<HomeAlbumItem> _mockAlbumItems = [
    HomeAlbumItem(
      id: "mock-series-1",
      name: "Faith Over Fear",
      description: "A journey through faith and courage",
      coverImage: "https://picsum.photos/id/1015/800/500",
    ),
    HomeAlbumItem(
      id: "mock-series-2",
      name: "Grace Unfolded",
      description: "Weekly reflections on grace",
      coverImage: "https://picsum.photos/id/1043/800/500",
    ),
    HomeAlbumItem(
      id: "mock-series-3",
      name: "Renewed Hope",
      description: "Stories of renewal and hope",
      coverImage: "https://picsum.photos/id/1050/800/500",
    ),
    HomeAlbumItem(
      id: "mock-series-4",
      name: "Sacred Sundays",
      description: "Sunday sermon series",
      coverImage: "https://picsum.photos/id/1074/800/500",
    ),
  ];
  // ==================== END PREVIEW-ONLY MOCK DATA ===================

  void _showFullScreenBanner(List<BannerItem> banners) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    final random = math.Random();
    final banner = banners[random.nextInt(banners.length)];

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black,
      builder: (_) => Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (banner.redirectUrl != null &&
                        banner.redirectUrl!.isNotEmpty) {
                      openBrowser(url: banner.redirectUrl ?? "");
                    }
                    Navigator.pop(context);
                  },
                  child: CustomNetworkImage(
                    imageUrl: banner.bannerUrl,
                    width: double.infinity,
                    height: double.infinity,
                    backgroundColor: Colors.grey.shade900,
                    errorIcon: Icons.image_not_supported_outlined,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 30,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    if (banner.redirectUrl != null &&
                        banner.redirectUrl!.isNotEmpty) {
                      openBrowser(url: banner.redirectUrl ?? "");
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tap to visit',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) => _isDialogOpen = false);
  }

  Future<void> openBrowser({required String url}) async {
    final Uri recordUri = Uri.parse(url);

    try {
      if (await canLaunchUrl(recordUri)) {
        await launchUrl(recordUri, mode: LaunchMode.externalApplication);
      } else {
        if (await canLaunchUrl(recordUri)) {
          await launchUrl(recordUri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      if (!controller.shouldShowBanners.value) return;

      if (controller.bannerModel.value.data != null &&
          controller.bannerModel.value.data!.isNotEmpty) {
        final shouldShow =
            await controller.dbHelper.shouldShowBanner(secondsGap: 30);

        if (shouldShow) {
          _showFullScreenBanner(controller.bannerModel.value.data ?? []);
          await controller.dbHelper.markBannerShown();
        }
      }
    });

    return Scaffold(
      bottomNavigationBar: const BottomNavPlayCard(),
      body: Obx(
        () {
          switch (controller.loading.value) {
            case Status.loading:
              return const Center(
                child: AppLogoLoader(),
              );
            case Status.internetError:
              return NoInternetCard(
                onTap: () => controller.getHome(),
                text: "Please check internet connection!",
              );
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: () => controller.getHome());

            case Status.completed:
              final data = controller.model.value.data;

              final categoryNotEmpty =
                  data?.categories != null && data!.categories!.isNotEmpty;
              final newNotEmpty = data?.newestPodcasts != null &&
                  data!.newestPodcasts!.isNotEmpty;
              final popularNotEmpty = data?.popularPodcasts != null &&
                  data!.popularPodcasts!.isNotEmpty;
              final reelsNotEmpty =
                  data?.reels != null && data!.reels!.isNotEmpty;
              final albumNotEmpty =
                  data?.albums != null && data!.albums!.isNotEmpty;

              final List<HomeCategoryElement>? categories =
                  categoryNotEmpty ? data.categories : [];
              final List<HomeNewestPodcast>? newItem =
                  newNotEmpty ? data.newestPodcasts : [];
              final List<HomeNewestPodcast>? popularItem =
                  popularNotEmpty ? data.popularPodcasts : [];
              // NOTE: Preview-only fallback data. Backend currently returns
              // empty `reels` / `albums` lists, so these placeholders let the
              // client see the section designs. Remove once real Clips/Series
              // content is uploaded from the admin panel — real data always
              // takes priority over these mocks.
              final List<HomeNewestPodcast>? reelsItem =
                  reelsNotEmpty ? data.reels : _mockReelItems;
              final List<HomeAlbumItem>? albumItem =
                  albumNotEmpty ? data.albums : _mockAlbumItems;

              return RefreshIndicator(
                onRefresh: () async {
                  profileController.getProfile();
                  controller.getHome();
                },
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: UserHomeTopSection(),
                    ),

                    const SliverGap(8),
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 8, top: 8),
                      sliver: SliverGrid.builder(
                        itemBuilder: (BuildContext context, int index) {
                          if (categories == null) {
                            return const SizedBox.shrink();
                          }
                          return UserHomeCategoriesSection(
                              category: categories[index]);
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          mainAxisExtent: 85,
                        ),
                        itemCount: categories?.length ?? 0,
                      ),
                    ),

                    //====================

                    //================

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const UserTopArtistsSection(),
                          FeatureBox(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Just In".tr,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                                TextButton(
                                  onPressed: () {
                                    AppRouter.route.pushNamed(
                                      RoutePath.podcastListScreen,
                                      extra: {
                                        'title': 'Just In',
                                        'reels': false,
                                        'popular': false,
                                        'searchTerm': '',
                                      },
                                    );
                                  },
                                  child: Text(
                                    "see_all".tr,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          itemCount: newItem?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return HomeMusicCard(
                              data: AudioPlayerModel(
                                  id: newItem?[index].id ?? "",
                                  title: newItem?[index].title ?? "",
                                  categories:
                                      newItem?[index].category?.name ?? "",
                                  image: newItem?[index].coverImage ?? "",
                                  duration: formatDuration(
                                      newItem?[index].duration ?? 0),
                                  url: newItem?[index].podcastUrl ?? ""),
                              onTap: () => AppRouter.route.pushNamed(
                                  RoutePath.audioPlayScreen,
                                  extra: AudioPlayerModel(
                                    id: newItem?[index].id ?? "",
                                    title: newItem?[index].title ?? "",
                                    categories:
                                        newItem?[index].category?.name ?? "",
                                    image: newItem?[index].coverImage ?? "",
                                    url: newItem?[index].podcastUrl ?? "",
                                    duration: formatDuration(
                                        newItem?[index].duration ?? 0),
                                  )),
                            );
                          },
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Advertisement",
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     AppRouter.route.pushNamed(
                            //       RoutePath.podcastListScreen,
                            //       extra: {
                            //         'title': 'Advertisement ',
                            //         'popular': true,
                            //       },
                            //     );
                            //   },
                            //   child: Text("see_all".tr),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: AdvertisingBox(),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Faith Hits",
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            TextButton(
                              onPressed: () {
                                AppRouter.route.pushNamed(
                                  RoutePath.podcastListScreen,
                                  extra: {
                                    'title': 'Faith Hits',
                                    'popular': true,
                                  },
                                );
                              },
                              child: Text("see_all".tr),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          itemCount: popularItem?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return HomeMusicCard(
                              data: AudioPlayerModel(
                                id: popularItem?[index].id ?? "",
                                title: popularItem?[index].title ?? "",
                                categories:
                                    popularItem?[index].category?.name ?? "",
                                image: popularItem?[index].coverImage ?? "",
                                url: popularItem?[index].podcastUrl ?? "",
                                duration: formatDuration(
                                    popularItem?[index].duration ?? 0),
                              ),
                              onTap: () => AppRouter.route.pushNamed(
                                  RoutePath.audioPlayScreen,
                                  extra: AudioPlayerModel(
                                    id: popularItem?[index].id ?? "",
                                    title: popularItem?[index].title ?? "",
                                    categories:
                                        popularItem?[index].category?.name ??
                                            "",
                                    image: popularItem?[index].coverImage ?? "",
                                    url: popularItem?[index].podcastUrl ?? "",
                                    duration: formatDuration(
                                        popularItem?[index].duration ?? 0),
                                    popular: true,
                                  )),
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Praise Clips",
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            TextButton(
                              onPressed: () {
                                AppRouter.route.pushNamed(
                                  RoutePath.podcastListScreen,
                                  extra: {
                                    'title': 'Praise Clips',
                                    'reels': true,
                                  },
                                );
                              },
                              child: Text("see_all".tr),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 250,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          itemCount: reelsItem?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return HomeReelsCard(
                              data: AudioPlayerModel(
                                id: reelsItem?[index].id ?? "",
                                title: reelsItem?[index].title ?? "",
                                categories:
                                    reelsItem?[index].category?.name ?? "",
                                image: reelsItem?[index].coverImage ?? "",
                                duration: formatDuration(
                                    reelsItem?[index].duration ?? 0),
                                url: reelsItem?[index].podcastUrl ?? "",
                              ),
                              onTap: () {
                                if (reelsNotEmpty) {
                                  AppRouter.route.pushNamed(
                                      RoutePath.reelsScreen,
                                      extra: AudioPlayerModel(
                                        id: reelsItem?[index].id ?? "",
                                        title: reelsItem?[index].title ?? "",
                                        categories:
                                            reelsItem?[index].category?.name ??
                                                "",
                                        image:
                                            reelsItem?[index].coverImage ?? "",
                                        url: reelsItem?[index].podcastUrl ?? "",
                                        duration: formatDuration(
                                            reelsItem?[index].duration ?? 0),
                                        reels: true,
                                        creatorImage: reelsItem?[index]
                                            .creator
                                            ?.profileImage,
                                      ));
                                } else {
                                  // Preview-only mock clips: play locally
                                  // instead of calling the (empty) reels API.
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MockReelsPreviewScreen(
                                        items: _mockReelPlayEntities(),
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Series",
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            TextButton(
                              onPressed: () {
                                AppRouter.route
                                    .pushNamed(RoutePath.albumSeeAllScreen);
                              },
                              child: Text(
                                "see_all".tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 250,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          itemCount: albumItem?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final isFirst = index == 0;
                            final screenWidth =
                                MediaQuery.of(context).size.width;
                            return HomeSeriesCard(
                              imageUrl: albumItem?[index].coverImage ?? "",
                              title: albumItem?[index].name ?? "",
                              width:
                                  isFirst ? screenWidth - 24 : screenWidth / 3,
                              onTap: () => toastMessage(message: "Coming Soon"),
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverGap(8),
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.recordList.isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "Streaming Record",
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                              TextButton(
                                onPressed: () {
                                  AppRouter.route
                                      .pushNamed(RoutePath.seeAllRecord);
                                },
                                child: Text(
                                  "see_all".tr,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SliverToBoxAdapter(
                      child: Obx(() {
                        switch (controller.loadingRecord.value) {
                          case Status.loading:
                            return const SizedBox();
                          case Status.error:
                            return const SizedBox();
                          case Status.noDataFound:
                            return const SizedBox();
                          case Status.internetError:
                            return const SizedBox();
                          case Status.completed:
                            if (controller.recordList.isEmpty) {
                              return const SizedBox();
                            }
                            return SizedBox(
                              height: 220,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                itemCount: controller.recordList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = controller.recordList[index];

                                  return ModernStreamingCard(
                                    isLive: false,
                                    data: AudioPlayerModel(
                                      id: item.id ?? "",
                                      title: item.name ?? "",
                                      image: item.coverImage ?? "",
                                      duration: formatDuration(0),
                                      url: item.recordingPresignedUrl ?? "",
                                    ),
                                    onTap: () {
                                      if (item.recordingPresignedUrl != null) {
                                        AppRouter.route.pushNamed(
                                          RoutePath.recordPlayScreen,
                                          extra: {
                                            "url":
                                                item.recordingPresignedUrl ?? ""
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                        }
                      }),
                    ),
                    const SliverGap(8),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  String formatDuration(num seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      final minutes = (seconds / 60).floor();
      return '$minutes min';
    }
  }
}
