import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/playlist/model/playlist_songs_model.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';

import '../controller/playlist_controller.dart';

class PlaylistSongsScreen extends StatefulWidget {
  const PlaylistSongsScreen({super.key, required this.id});

  final String id;

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  final PagingController<int, PlayListPodcastItem> pagingController = PagingController(firstPageKey: 1);
  final controller = Get.find<PlaylistController>();

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      controller.getPlaylistPodcast(
        pageKey: pageKey,
        id: widget.id,
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
        leading: IconButton(
          onPressed: () => AppRouter.route.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("my_play_list".tr),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: PagedListView<int, PlayListPodcastItem>(
          pagingController:pagingController,
          builderDelegate: PagedChildBuilderDelegate<PlayListPodcastItem>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id ?? "",
                title: item.title ?? "",
                image: item.coverImage ?? "",
                categories: item.category?.name ?? "",
                duration: formatDuration(item.duration ?? 0),
                artist: item.creator?.name ?? "",
                url: "",
              );

              return MusicCard(
                data: data,
                onTap: () => AppRouter.route.pushNamed(RoutePath.audioPlayScreen,
                    extra: AudioPlayerModel(
                      id: widget.id,
                      title: item.title ?? "",
                      categories: item.category?.name ?? "",
                      image: item.coverImage ?? "",
                      url: item.podcastUrl ?? "",
                      duration: formatDuration(item.duration ?? 0),
                      isPlaylist: true,
                    ),
                ),
              );
            },
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
