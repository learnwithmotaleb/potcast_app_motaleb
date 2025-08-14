import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/playlist/controller/playlist_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'model/playlist_model.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final PagingController<int, PlaylistItem> pagingController = PagingController(firstPageKey: 1);
  final controller = Get.find<PlaylistController>();

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      controller.getPlayList(
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
    return Scaffold(
      appBar: AppBar(
        title: Text("my_play_list".tr),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20),
        child: FloatingActionButton(
          onPressed: () => AppRouter.route.pushNamed(RoutePath.playlistAddScreen),
          child: const Icon(Iconsax.add),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: PagedListView<int, PlaylistItem>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<PlaylistItem>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id ?? "",
                title: item.name ?? "",
                image: item.coverImage ?? "",
                url: "",
                artist: item.description ?? "",
                duration: "",
              );
              return MusicCard(
                data: data,
                isPlayList: true,
                onTap: () => AppRouter.route.pushNamed(
                  RoutePath.playlistSongsScreen,
                  extra: item.id ?? "",
                ),
                onLongPress: () {
                  if (item.id != null) {
                    controller.playlistDelete(
                      id: item.id ?? "",
                      pagingController: pagingController,
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
