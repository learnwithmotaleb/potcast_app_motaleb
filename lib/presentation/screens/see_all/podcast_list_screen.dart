import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/creator_card.dart';
import 'package:podcast/service/api_url.dart';

import 'controller/see_all_controller.dart';

class PodcastListScreen extends StatefulWidget {
  const PodcastListScreen({
    super.key,
    required this.title,
    this.searchTerm = '',
    this.category = '',
    this.subCategory = '',
    this.reels = false,
    this.popular = false,
  });

  final String title;
  final String category;
  final String subCategory;
  final String searchTerm;
  final bool reels;
  final bool popular;

  @override
  State<PodcastListScreen> createState() => _PodcastListScreenState();
}

class _PodcastListScreenState extends State<PodcastListScreen> {
  final controller = Get.find<SeeAllController>();
  final pagingController = PagingController<int, AllPodcastItem>(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      final url = ApiUrl.search(
        pageKey: pageKey.toString(),
        searchTerm: widget.searchTerm,
        reels: widget.reels,
        popular: widget.popular,
        category: widget.category,
        subCategory: widget.subCategory,
      );

      controller.getPodcast(
        pageKey: pageKey,
        url: url,
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
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title.tr),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            pagingController.refresh();
          },
          child: PagedGridView<int, AllPodcastItem>(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            pagingController: pagingController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 200,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
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
                return CreatorCard(
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
            ),
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
