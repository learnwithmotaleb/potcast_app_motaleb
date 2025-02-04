import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/user/search/controller/user_search_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'model/search_podcast_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.find<UserSearchController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => AppRouter.route.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("search".tr),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          controller.pagingController.refresh();
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
                      placeholder:  "what_would_you_like_to_listen".tr,
                      style: const TextStyle(fontSize: 16, color: CupertinoColors.white),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSubmitted: controller.updateSearch,
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "search_item".tr),
                        Assets.icons.sort.svg(colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                      ],
                    ),
                    const Gap(12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: PagedSliverList<int, SearchPodcast>(
                pagingController: controller.pagingController,

                builderDelegate: PagedChildBuilderDelegate<SearchPodcast>(
                  itemBuilder: (context, item, index) {
                    final data = AudioPlayerModel(
                      id: item.id??"",
                      title: item.title??"",
                      image: item.cover??"",
                      categories: item.category?.title??"",
                      duration: item.audioDuration.toString(),
                      artist: item.creator?.user?.name??"",
                    );
                    return MusicCard(
                      data: data,
                      onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: item.id??""),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
