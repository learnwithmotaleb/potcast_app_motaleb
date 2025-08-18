import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/widget/bottom_nav_play_card.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import '../../widget/card/creator_card.dart';
import 'model/favorite_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final controller = Get.find<FavoriteController>();
  final playController = Get.put(AudioPlayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("favorite".tr),
      ),
      bottomNavigationBar: Obx(() {
        return playController.isPlaying.value
            ? BottomNavPlayCard()
            : const SizedBox();
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.pagingController.refresh();
        },
        child: PagedGridView<int, FavoriteItem>(
          pagingController: controller.pagingController,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 200,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          builderDelegate: PagedChildBuilderDelegate<FavoriteItem>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id ?? "",
                title: item.podcast?.title ?? "",
                image: item.podcast?.creator?.profileImage ?? "",
                categories: item.podcast?.category?.name ?? "",
                duration: formatDuration(item.podcast?.duration ?? 0),
                artist: item.podcast?.creator?.name ?? "",
                url: "",
              );
              return CreatorCard(
                data: data,
                onTap: () => AppRouter.route.pushNamed(
                  RoutePath.audioPlayScreen,
                  extra: AudioPlayerModel(
                    id: item.podcast?.id ?? "",
                    title: item.podcast?.title ?? "",
                    categories: item.podcast?.category?.name ?? "",
                    image: item.podcast?.coverImage ?? "",
                    url: "",
                    duration: formatDuration(item.podcast?.duration ?? 0),
                  ),
                ),
              );
            },
            firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
            newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
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
