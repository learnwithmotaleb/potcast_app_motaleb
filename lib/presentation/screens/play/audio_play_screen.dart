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
        reels: widget.reels,
        popular: widget.popular,
        firstPodcastId: widget.id,
      );
    };

    feedController.pagingController
        .removePageRequestListener(_pageRequestListener);

    feedController.pagingController
        .addPageRequestListener(_pageRequestListener);

    print("1111 ${widget.id}");
    print("1111 current ${feedController.currentMediaId.value}");
    if (feedController.currentMediaId.value != widget.id &&
        feedController.currentMediaId.value.isNotEmpty) {
      feedController.pagingController.refresh();
    }
  }

  @override
  void dispose() {
    feedController.pagingController
        .removePageRequestListener(_pageRequestListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Obx(() {
          return Text(
            feedController.currentItem.value.title ?? widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }),
        actions: [
          /*MinimalistToggle(
            feedController: feedController,
            url: feedController.currentItem.value.audioUrl ?? "",
          ),*/
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
            itemBuilder: (context, PlayPodcastItem itemValue, index) {
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
                        AudioPlayBottom(controller: feedController),
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

/*
class PillToggleButton extends StatelessWidget {
  final PodcastFeedController feedController;
  final String url;

  const PillToggleButton({
    super.key,
    required this.feedController,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = feedController.isLoading.value == Status.loading;
      final isAudioMode = feedController.isAudioMode.value;

      return Container(
        margin: const EdgeInsets.only(right: 8),
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: isAudioMode
                ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                : [const Color(0xFFf093fb), const Color(0xFFf5576c)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isAudioMode
                  ? const Color(0xFF667eea)
                  : const Color(0xFFf093fb)).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: isLoading ? null : () => feedController.toggleMode(url: url),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedRotation(
                    turns: isAudioMode ? 0 : 0.5,
                    duration: const Duration(milliseconds: 400),
                    child: Icon(
                      isAudioMode ? Iconsax.video_play : Iconsax.music,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      isAudioMode ? 'Video' : 'Audio',
                      key: ValueKey(isAudioMode),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

// Option 3: Segmented Control Style
class SegmentedToggle extends StatelessWidget {
  final PodcastFeedController feedController;
  final String url;

  const SegmentedToggle({
    super.key,
    required this.feedController,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = feedController.isLoading.value == Status.loading;
      final isAudioMode = feedController.isAudioMode.value;

      return Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSegment(
              isSelected: isAudioMode,
              icon: Iconsax.music,
              label: 'Audio',
              onTap: isLoading ? null : () {
                if (!isAudioMode) feedController.toggleMode(url: url);
              },
            ),
            const SizedBox(width: 2),
            _buildSegment(
              isSelected: !isAudioMode,
              icon: Iconsax.video,
              label: 'Video',
              onTap: isLoading ? null : () {
                if (isAudioMode) feedController.toggleMode(url: url);
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSegment({
    required bool isSelected,
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Option 4: Circular Toggle with Animated Icons
class CircularAnimatedToggle extends StatelessWidget {
  final PodcastFeedController feedController;
  final String url;

  const CircularAnimatedToggle({
    super.key,
    required this.feedController,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = feedController.isLoading.value == Status.loading;
      final isAudioMode = feedController.isAudioMode.value;

      return Container(
        margin: const EdgeInsets.only(right: 8),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: isLoading ? null : () => feedController.toggleMode(url: url),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.elasticOut,
                  switchOutCurve: Curves.easeInBack,
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    isAudioMode ? Iconsax.video_play : Iconsax.music,
                    key: ValueKey(isAudioMode),
                    size: 20,
                    color: isLoading
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// Option 5: Minimalist with Subtle Animations
class MinimalistToggle extends StatelessWidget {
  final PodcastFeedController feedController;
  final String url;

  const MinimalistToggle({
    super.key,
    required this.feedController,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = feedController.isLoading.value == Status.loading;
      final isAudioMode = feedController.isAudioMode.value;

      return Container(
        margin: const EdgeInsets.only(right: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: isLoading ? null : () => feedController.toggleMode(url: url),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background indicator
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLoading ? 0.3 : 1.0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isAudioMode
                              ? const Color(0xFF4FC3F7)
                              : const Color(0xFFFF6B6B),
                        ),
                      ),
                    ),
                    // Icon with smooth transition
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeInBack,
                      child: Icon(
                        isAudioMode ? Iconsax.video : Iconsax.music,
                        key: ValueKey(isAudioMode),
                        size: 24,
                        color: isLoading
                            ? Colors.grey.withOpacity(0.4)
                            : Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}*/
