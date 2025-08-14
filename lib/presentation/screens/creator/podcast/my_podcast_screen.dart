import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'controller/podcast_audio_controller.dart';
import 'model/my_podcast_model.dart';

class MyPodcastScreen extends StatefulWidget {
  const MyPodcastScreen({super.key});

  @override
  State<MyPodcastScreen> createState() => _MyPodcastScreenState();
}

class _MyPodcastScreenState extends State<MyPodcastScreen> {
  final _controller = Get.find<PodcastAudioController>();
  final PagingController<int, MyPodcastItem> pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      _controller.getMyPodcast(
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
        title: Text(
          "My Podcast".tr,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: PagedListView<int, MyPodcastItem>(
          pagingController: pagingController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          builderDelegate: PagedChildBuilderDelegate<MyPodcastItem>(
            itemBuilder: (context, item, index) {
              final data = AudioPlayerModel(
                id: item.id ?? "",
                title: item.title ?? "",
                image: item.creator?.profileImage ?? "",
                categories: item.category?.name ?? "",
                duration: formatDuration(item.duration ?? 0),
                artist: item.creator?.name ?? "",
                url: "",
              );
              return MusicCard(
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
