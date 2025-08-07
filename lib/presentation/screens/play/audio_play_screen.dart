import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/presentation/screens/play/widget/audio_video_player_view.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'model/play_feed_model.dart';
import 'widget/audio_play_bottom.dart';
import 'widget/audio_play_control.dart';
import 'widget/audio_play_progress.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({
    super.key,
    required this.audioPlayerModel,
  });

  final AudioPlayerModel audioPlayerModel;

  @override
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> {
  // final controller = Get.find<AudioPlayController>();
  final feedController = Get.find<PodcastFeedController>();
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _initializeFeed();
  }

  void _initializeFeed() {
    debugPrint("[Feed] Initializing podcast feed...");

    debugPrint("[Feed] Paging controller refreshed.");

    feedController.pagingController.addPageRequestListener((pagingPageKey) {
      final cursor = pagingPageKey.cursor.isEmpty ? null : pagingPageKey.cursor;
      debugPrint("[Feed] Page request: cursor=$cursor, reels=${widget.audioPlayerModel.reels}, popular=${widget.audioPlayerModel.popular}");

      feedController.getPodcast(
        cursor: cursor,
        pageKey: pagingPageKey.pageKey,
        reels: widget.audioPlayerModel.reels,
        popular: widget.audioPlayerModel.popular,
      );
    });

    feedController.pagingController.refresh();

    _findAndPlayPodcast();
  }

  void _findAndPlayPodcast() {
    debugPrint("[Feed] Setting up listener to auto-play first podcast...");

    feedController.pagingController.addStatusListener((status) {
      debugPrint("[Feed] Paging status updated: $status");

      if (status == PagingStatus.completed || status == PagingStatus.ongoing) {
        final items = feedController.pagingController.itemList;
        debugPrint("[Feed] Items loaded: ${items?.length}");

        if (items != null && items.isNotEmpty) {
          final firstItem = items.first;

          if (feedController.currentMediaId.value != firstItem.id) {
            debugPrint("[Feed] Auto-playing first podcast ID: ${firstItem.id}");

          } else {
            debugPrint("[Feed] First podcast already playing: ${firstItem.id}");
          }
        } else {
          debugPrint("[Feed] No podcast items to play.");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.audioPlayerModel.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Obx(() => IconButton(
                onPressed: feedController.isLoading.value == Status.loading
                    ? null
                    : () => feedController.toggleMode(),
                icon: const Icon(Iconsax.arrow_swap),
              )),
        ],
      ),
      body: SafeArea(
        top: false,
        child: PagedPageView(
          pagingController: feedController.pagingController,
          pageController: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            currentPageIndex.value = index;
            final items = feedController.pagingController.itemList;
            if (items != null && index < items.length) {
              final item = items[index];
              if (feedController.currentMediaId.value != item.id) {
                feedController.playPodcast(item: item);
              }
            }
          },
          builderDelegate: PagedChildBuilderDelegate<PlayPodcastItem>(
            itemBuilder: (context, item, index) {
              return _buildPodcastItem(item);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPodcastItem(PlayPodcastItem item) {
    return Column(
      children: [
        Expanded(
          child: AudioVideoPlayerView(
            item: item,
            isAudioMode: feedController.isAudioMode,
            videoController: feedController.videoPlayerController,
            loadingStatus: feedController.isLoading,
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
                currentPageIndex: currentPageIndex,
                pageController: pageController,
              ),
              AudioPlayBottom(controller: feedController),
            ],
          ),
        ),
      ],
    );
  }
}
