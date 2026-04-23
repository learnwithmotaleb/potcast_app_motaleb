import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/search/controller/search_screen_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class PlaylistAddScreen extends StatefulWidget {
  const PlaylistAddScreen({super.key});

  @override
  State<PlaylistAddScreen> createState() => _PlaylistAddScreenState();
}

class _PlaylistAddScreenState extends State<PlaylistAddScreen> {
  final controller = Get.find<SearchScreenController>();
  final pagingController = PagingController<int, AllPodcastItem>(firstPageKey: 1);
  final ValueNotifier<List<String>> selectedItem = ValueNotifier([]);

  @override
  void initState() {
    selectedItem.value.clear();
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
    selectedItem.dispose();
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
          centerTitle: true,
          title: Text("Add Playlist".tr),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedItem.value.isNotEmpty) {
              AppRouter.route.pushNamed(
                RoutePath.playlistAddInfoScreen,
                extra: selectedItem.value,
              );
            }
          },
          child: const Icon(Iconsax.add_square),
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
                            value: val,
                            controllers: [pagingController],
                          );
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
                sliver: ValueListenableBuilder<List<String>>(
                  valueListenable: selectedItem,
                  builder: (_, selectedId, child) {
                    print("Build");
                    return PagedSliverList<int, AllPodcastItem>(
                      pagingController: pagingController,
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

                          return MusicCard(
                              data: data,
                              bgColor: selectedId.contains(item.id) ? AppColors.redColor : null,
                              onTap: () {
                                final id = item.id ?? "";
                                if (id.isNotEmpty) {
                                  if (selectedId.contains(id)) {
                                    selectedItem.value = List.from(selectedId)..remove(id);
                                  } else {
                                    selectedItem.value = List.from(selectedId)..add(id);
                                  }
                                }
                              });
                        },
                      ),
                    );
                  },
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
