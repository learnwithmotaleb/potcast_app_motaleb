import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/global_search_model.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/search/controller/search_screen_controller.dart';
import 'package:podcast/presentation/widget/card/creator_card.dart';
import 'package:podcast/presentation/widget/card/home_music_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.find<SearchScreenController>();

  final PagingController<int, GlobalSearchResultItem> globalPagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    globalPagingController.addPageRequestListener((pageKey) {
      controller.getGlobalSearch(
        pageKey: pageKey,
        pagingController: globalPagingController,
      );
    });
  }

  @override
  void dispose() {
    globalPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("search".tr),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CupertinoSearchTextField(
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
                    controller: globalPagingController,
                  );
                },
              ),
            ),
            const Gap(12),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  globalPagingController.refresh();
                },
                child: PagedGridView<int, GlobalSearchResultItem>(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  pagingController: globalPagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 220,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<GlobalSearchResultItem>(
                    itemBuilder: (context, item, index) {
                      if (item.type.toLowerCase() == "profile" || item.type.toLowerCase() == "creator" || item.type.toLowerCase() == "user") {
                        final data = AudioPlayerModel(
                          id: item.id,
                          title: item.title,
                          image: item.image,
                          duration: "",
                          url: "",
                        );
                        return CreatorCard(
                          data: data,
                          onTap: () {
                            if (item.id.isNotEmpty) {
                              AppRouter.route.pushNamed(
                                RoutePath.creatorProfileScreen,
                                extra: item.id,
                              );
                            }
                          },
                        );
                      } else {
                        // Default to podcast
                        final data = AudioPlayerModel(
                          id: item.id,
                          title: item.title,
                          image: item.image,
                          categories: "",
                          duration: "",
                          artist: "",
                          url: item.url ?? "",
                        );
                        return HomeMusicCard(
                          data: data,
                          onTap: () {
                            AppRouter.route.pushNamed(
                              RoutePath.audioPlayScreen,
                              extra: data,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
