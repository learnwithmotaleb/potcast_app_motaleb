import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/playlist/controller/playlist_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'model/playlist_model.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final controller = Get.find<PlaylistController>();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("my_play_list".tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRouter.route.pushNamed(RoutePath.playlistAddScreen),
        backgroundColor: AppColors.primaryColor,
        label: Text(
          "add_new".tr,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          controller.playListController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Row(
                  children: [
                    Assets.icons.sort.svg(height: 15, width: 15, colorFilter: isDarkMode ? null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                    const Gap(5),
                    CustomText(text: "recently_added".tr, fontWeight: FontWeight.w600, fontSize: 16),
                  ],
                ),
              ),
            ),
            PagedSliverList<int, Playlist>(
              pagingController: controller.playListController,
              builderDelegate: PagedChildBuilderDelegate<Playlist>(
                itemBuilder: (context, item, index) {
                  final data = AudioPlayerModel(
                    id: item.id??"",
                    title: item.title??"",
                    image: item.cover??"",
                    categories: "Total Songs ${item.total??0.0}"
                  );
                  return MusicCard(
                    data: data,
                    onTap: () => AppRouter.route.pushNamed(RoutePath.playlistSongsScreen, extra: item.id??""),
                    onLongPress: (){
                      if(!controller.deleteLoading.value){
                        controller.playlistDelete(id: item.id??"", context: context);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
