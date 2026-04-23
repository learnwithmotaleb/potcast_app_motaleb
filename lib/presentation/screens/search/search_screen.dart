import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/search/controller/search_screen_controller.dart';
import 'package:podcast/presentation/screens/see_all/model/top_creator_model.dart';
import 'package:podcast/presentation/screens/see_all/model/see_all_album_model.dart';
import 'package:podcast/presentation/widget/card/creator_card.dart';
import 'package:podcast/presentation/widget/card/home_music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.find<SearchScreenController>();
  
  final PagingController<int, AllPodcastItem> justInPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, AllPodcastItem> faithHitsPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, AllPodcastItem> praiseClipsPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, SeeAllAlbumItem> seriesPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, TopCreatorItem> profilesPagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    justInPagingController.addPageRequestListener((pageKey) {
      controller.getPodcastSearch(
        pageKey: pageKey,
        pagingController: justInPagingController,
      );
    });
    faithHitsPagingController.addPageRequestListener((pageKey) {
      controller.getPodcastSearch(
        pageKey: pageKey,
        pagingController: faithHitsPagingController,
        popular: true,
      );
    });
    praiseClipsPagingController.addPageRequestListener((pageKey) {
      controller.getPodcastSearch(
        pageKey: pageKey,
        pagingController: praiseClipsPagingController,
        reels: true,
      );
    });
    seriesPagingController.addPageRequestListener((pageKey) {
      controller.getAlbumsSearch(
        pageKey: pageKey,
        pagingController: seriesPagingController,
      );
    });
    profilesPagingController.addPageRequestListener((pageKey) {
      controller.getTopCreatorSearch(
        pageKey: pageKey,
        pagingController: profilesPagingController,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    justInPagingController.dispose();
    faithHitsPagingController.dispose();
    praiseClipsPagingController.dispose();
    seriesPagingController.dispose();
    profilesPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ColorFilter? color;

    if (!isDarkMode) {
      color = const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn);
    }

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text("search".tr),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(12),
                        CupertinoSearchTextField(
                          itemColor: CupertinoColors.systemGrey,
                          placeholder: "what_would_you_like_to_listen".tr,
                          padding: const EdgeInsets.all(16),
                          placeholderStyle: const TextStyle(color: Colors.grey),
                          style: const TextStyle(color: AppColors.whiteColor),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2B31),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onSubmitted: (val) {
                            controller.updateSearch(
                              value: val,
                              controllers: [
                                justInPagingController,
                                faithHitsPagingController,
                                praiseClipsPagingController,
                                seriesPagingController,
                                profilesPagingController,
                              ],
                            );
                          },
                        ),
                        const Gap(12),
                        TabBar(
                          isScrollable: true,
                          indicatorColor: AppColors.redColor,
                          labelColor: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: "Just In".tr),
                            Tab(text: "Faith Hits".tr),
                            Tab(text: "Praise Clips".tr),
                            Tab(text: "Series".tr),
                            Tab(text: "Profiles".tr),
                          ],
                        ),
                        const Gap(12),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildPodcastList(justInPagingController),
                _buildPodcastList(faithHitsPagingController),
                _buildPodcastList(praiseClipsPagingController),
                _buildSeriesList(),
                _buildCreatorList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodcastList(PagingController<int, AllPodcastItem> pagingController) {
    return RefreshIndicator(
      onRefresh: () async {
        pagingController.refresh();
      },
      child: PagedGridView<int, AllPodcastItem>(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        pagingController: pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 220,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        builderDelegate: PagedChildBuilderDelegate<AllPodcastItem>(
          itemBuilder: (context, item, index) {
            final data = AudioPlayerModel(
              id: item.id ?? "",
              title: item.title ?? "",
              image: item.coverImage ?? "",
              categories: item.category?.name ?? "",
              duration: formatDuration(item.duration ?? 0),
              artist: item.creator?.name ?? "",
              url: item.podcastUrl ?? "",
            );
            return HomeMusicCard(
              data: data,
              onTap: () => AppRouter.route.pushNamed(
                RoutePath.audioPlayScreen,
                extra: data,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeriesList() {
    return RefreshIndicator(
      onRefresh: () async {
        seriesPagingController.refresh();
      },
      child: PagedGridView<int, SeeAllAlbumItem>(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        pagingController: seriesPagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 220,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        builderDelegate: PagedChildBuilderDelegate<SeeAllAlbumItem>(
          itemBuilder: (context, item, index) {
            final data = AudioPlayerModel(
              id: item.id ?? "",
              title: item.name ?? "",
              categories: item.description ?? "",
              image: item.coverImage ?? "",
              duration: formatDuration(0),
              url: "",
            );
            return HomeMusicCard(
              data: data,
              onTap: () {
                AppRouter.route.pushNamed(
                  RoutePath.albumPodcastScreen,
                  extra: {
                    "title": item.name ?? "",
                    "id": item.id ?? "",
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCreatorList() {
    return RefreshIndicator(
      onRefresh: () async {
        profilesPagingController.refresh();
      },
      child: PagedGridView<int, TopCreatorItem>(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        pagingController: profilesPagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 220,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        builderDelegate: PagedChildBuilderDelegate<TopCreatorItem>(
          itemBuilder: (context, item, index) {
            final data = AudioPlayerModel(
              id: item.creatorId ?? "",
              title: item.name ?? "",
              image: item.profileImage ?? "",
              duration: "",
              url: "",
            );
            return CreatorCard(
              data: data,
              onTap: () {
                final creatorId = item.creatorId ?? "";
                if (creatorId.isNotEmpty) {
                  AppRouter.route.pushNamed(
                    RoutePath.creatorProfileScreen,
                    extra: creatorId,
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  String formatDuration(num seconds) {
    if (seconds == 0) return "";
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      final minutes = (seconds / 60).floor();
      return '$minutes min';
    }
  }
}
