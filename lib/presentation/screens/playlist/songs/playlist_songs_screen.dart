import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/playlist/controller/playlist_songs_controller.dart';
import 'package:podcast/presentation/screens/playlist/model/playlist_songs_model.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';

class PlaylistSongsScreen extends StatefulWidget {
  const PlaylistSongsScreen({super.key, required this.id});
  final String id;

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  final controller = Get.put(PlayListSongsController());

  @override
  void initState() {
    controller.pagingController.addPageRequestListener((pageKey) {
      controller.getPlaylistPodcast(pageKey: pageKey, id: widget.id);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.pagingController.dispose();
    Get.delete<PlayListSongsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => AppRouter.route.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("my_play_list".tr),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          controller.pagingController.refresh();
        },
        child: PagedListView<int, PlayListPodcast>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<PlayListPodcast>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id??"",
                title: item.title??"",
                image: item.cover??"",
                categories: item.category?.title??"",
                duration: item.audioDuration.toString(),
                artist: item.creator?.user?.name??"",
                url: ""
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
