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
import 'package:podcast/presentation/widget/card/creator_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.find<SearchScreenController>();
  final PagingController<int, AllPodcastItem> pagingController =
      PagingController(firstPageKey: 1);


  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      controller.getPodcastSearch(
        pageKey: pageKey,
        pagingController: pagingController,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
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
      child: Scaffold(
        appBar: AppBar(
          title: Text("search".tr),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            pagingController.refresh();
          },
          child: CustomScrollView(
            slivers: [
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
                              value: val, pagingController: pagingController);
                        },
                      ),
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "Search Content".tr),
                          Assets.icons.sort.svg(colorFilter: color),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                sliver: PagedSliverGrid<int, AllPodcastItem>(
                  pagingController: pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 200,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<AllPodcastItem>(
                    itemBuilder: (context, item, index) {
                      final data = AudioPlayerModel(
                        id: item.id ?? "",
                        title: item.title ?? "",
                        image: item.coverImage ?? "",
                        categories: item.category?.name ?? "",
                        duration: item.duration.toString(),
                        artist: item.creator?.name ?? "",
                        url: item.podcastUrl ?? "",
                      );
                      return CreatorCard(
                        data: data,
                        onTap: () => AppRouter.route.pushNamed(
                          RoutePath.audioPlayScreen,
                          extra: AudioPlayerModel(
                            id: item.id ?? "",
                            title: item.title ?? "",
                            categories: item.category?.name ?? "",
                            image: item.coverImage ?? "",
                            url: "",
                            duration: formatDuration(item.duration ?? 0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
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
