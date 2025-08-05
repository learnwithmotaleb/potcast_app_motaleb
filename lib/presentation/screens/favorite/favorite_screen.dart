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
      bottomNavigationBar: Obx((){
        return playController.isPlaying.value? BottomNavPlayCard(): const SizedBox();
      }),
      body: RefreshIndicator(
        onRefresh: ()async{
          controller.pagingController.refresh();
        },
        child: PagedListView<int, FavoritePodcast>(
          pagingController: controller.pagingController,
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
          builderDelegate: PagedChildBuilderDelegate<FavoritePodcast>(
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
                onTap: (){},
                // onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: item.id??""),
              );
            },
          ),
        ),
      ),
    );
  }
}
