import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/presentation/screens/play/widget/audio_video_player_view.dart';
import 'model/play_feed_model.dart';
import 'widget/audio_play_bottom.dart';
import 'widget/audio_play_control.dart';
import 'widget/audio_play_progress.dart';
import 'widget/glassmorphism_toggle_widget.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({
    super.key,
    required this.id,
    required this.title,
    this.categories,
    required this.image,
    this.artist,
    required this.duration,
    required this.url,
    required this.reels,
    required this.popular,
  });

  final String id;
  final String title;
  final String? categories;
  final String image;
  final String? artist;
  final String duration;
  final String url;
  final bool reels;
  final bool popular;

  @override
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> {
  final feedController = Get.find<PodcastFeedController>();

  @override
  void initState() {
    super.initState();
    _initializeFeed();
  }

  late final void Function(dynamic) _pageRequestListener;

  void _initializeFeed() {
    _pageRequestListener = (pagingPageKey) {
      final cursor = pagingPageKey.cursor.isEmpty ? null : pagingPageKey.cursor;

      debugPrint(
        "[Feed] Page request: cursor=$cursor, reels=${widget.reels}, "
        "popular=${widget.popular}, ID=${widget.id}",
      );

      feedController.getPodcast(
        cursor: cursor,
        pageKey: pagingPageKey.pageKey,
        // reels: widget.reels,
        // popular: widget.popular,
        firstPodcastId: widget.id,
      );
    };

    feedController.pagingController.removePageRequestListener(_pageRequestListener);

    feedController.pagingController.addPageRequestListener(_pageRequestListener);

    print("1111 ${widget.id}");
    print("1111 current ${feedController.currentMediaId.value}");
    if (feedController.currentMediaId.value != widget.id &&
        feedController.currentMediaId.value.isNotEmpty) {
      feedController.pagingController.refresh();
    }
  }

  @override
  void dispose() {
    feedController.pagingController.removePageRequestListener(_pageRequestListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feedController.currentItem.value.title ?? widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                feedController.currentItem.value.subCategory?.name ??( widget.categories ?? ""),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          );
        }),
        actions: [
          GlassMorphismToggle(
            feedController: feedController,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: PagedPageView(
          pagingController: feedController.pagingController,
          pageController: feedController.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            print("-------------------------------onPageChanged $index");
            final items = feedController.pagingController.itemList;
            if (items != null && index < items.length) {
              final item = items[index];
              if (feedController.currentMediaId.value != item.id) {
                feedController.currentIndex.value = index;
                feedController.playPodcast(item: item);
              }
            }
          },
          builderDelegate: PagedChildBuilderDelegate<PlayPodcastItem>(
            itemBuilder: (BuildContext context, PlayPodcastItem itemValue, index) {
              return Column(
                children: [
                  Expanded(
                    child: AudioVideoPlayerView(
                      feedController: feedController,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      spacing: 12,
                      children: [
                        AudioPlayProgress(controller: feedController),
                        AudioPlayControl(
                          controller: feedController,
                        ),
                        AudioPlayBottom(
                          controller: feedController,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
