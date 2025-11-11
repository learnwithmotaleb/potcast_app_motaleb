import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class StreamAudioPlayControl extends StatelessWidget {
  final PodcastManuallyPlayController controller;

  const StreamAudioPlayControl({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: StreamBuilder<Status>(
        stream: controller.loadingStatusStream,
        initialData: controller.loadingStatus,
        builder: (context, statusSnapshot) {
          final loadingStatus = statusSnapshot.data ?? Status.loading;

          return StreamBuilder<bool>(
            stream: controller.playingStream,
            initialData: controller.audioPlayer.playing,
            builder: (context, playingSnapshot) {
              final isPlaying = playingSnapshot.data ?? false;

              return StreamBuilder<PlayEntity?>(
                stream: controller.currentItemStream,
                initialData: controller.currentItem,
                builder: (context, currentItemSnapshot) {
                  final currentItem = currentItemSnapshot.data;
                  final hasCurrentItem = currentItem != null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLikeButton(hasCurrentItem, currentItem?.id ?? ""),
                      _buildSkipButton(
                        onPressed: hasCurrentItem && loadingStatus != Status.loading
                            ? () => controller.skipBackward()
                            : null,
                        icon: Assets.icons.audioLeft.svg(
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            hasCurrentItem ? Colors.white : Colors.white38,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      /*_buildPreviousButton(
                        onPressed: hasCurrentItem && loadingStatus != Status.loading
                            ? () => controller.seekToPrevious()
                            : null,
                        hasCurrentItem: hasCurrentItem,
                      ),*/
                      _buildMainPlayButton(
                        loadingStatus: loadingStatus,
                        hasCurrentItem: hasCurrentItem,
                        isPlaying: isPlaying,
                      ),
                      _buildNextButton(
                        onPressed: hasCurrentItem && loadingStatus != Status.loading
                            ? () => controller.seekToNext()
                            : null,
                        hasCurrentItem: hasCurrentItem,
                      ),
                      /*_buildSkipButton(
                        onPressed: hasCurrentItem && loadingStatus != Status.loading
                            ? () => controller.skipForward()
                            : null,
                        icon: Assets.icons.audioRight.svg(
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            hasCurrentItem ? Colors.white : Colors.white38,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),*/
                      _buildFavoriteButton(hasCurrentItem, currentItem?.id ?? ""),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLikeButton(bool hasCurrentItem, String id) {
    return Obx(() {
      final isLoading = controller.likeLoading.value;
      final isLiked = controller.isLike.value;

      return _buildActionButton(
        onPressed: isLoading || !hasCurrentItem
            ? null
            : () => _handleLike(id),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
            key: const ValueKey('loading'),
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          )
              : Column(
            key: ValueKey('like_$isLiked'),
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.thumb_up,
                size: 30,
                color: isLiked ? Colors.green : Colors.white70,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFavoriteButton(bool hasCurrentItem, String id) {
    return Obx(() {
      final isLoading = controller.favoriteLoading.value;
      final isFavorited = controller.isFavorite.value;

      return _buildActionButton(
        onPressed: isLoading || !hasCurrentItem
            ? null
            : () => _handleFavorite(id),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
            key: const ValueKey('loading'),
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ) : Column(
            key: ValueKey('favorite_$isFavorited'),
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                size: 30,
                color: isFavorited ? Colors.red : Colors.white70,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onPressed != null ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: child,
        ),
      ),
    );
  }

  Future<void> _handleLike(String id) async {
    if (id.isEmpty) return;

    try {
      final currentState = controller.isLike.value;
      await controller.likePodcast(
        id: id,
        currentState: currentState,
      );
    } catch (e) {
      debugPrint('Error handling like: $e');
    }
  }

  Future<void> _handleFavorite(String id) async {
    if (id.isEmpty) return;

    try {
      final currentState = controller.isFavorite.value;
      await controller.favoritePodcast(
        id: id,
        currentState: currentState,
      );
    } catch (e) {
      debugPrint('Error handling favorite: $e');
    }
  }

  Widget _buildSkipButton({
    required VoidCallback? onPressed,
    required Widget icon,
  }) {
    return _buildControlButton(
      onPressed: onPressed,
      child: icon,
    );
  }

  // Widget _buildPreviousButton({
  //   required VoidCallback? onPressed,
  //   required bool hasCurrentItem,
  // }) {
  //   return _buildControlButton(
  //     onPressed: onPressed,
  //     child: Icon(
  //       Icons.skip_previous,
  //       color: hasCurrentItem ? Colors.white : Colors.white38,
  //       size: 32,
  //     ),
  //   );
  // }

  Widget _buildNextButton({
    required VoidCallback? onPressed,
    required bool hasCurrentItem,
  }) {
    return _buildControlButton(
      onPressed: onPressed,
      child: Icon(
        Icons.skip_next,
        color: hasCurrentItem ? Colors.white : Colors.white38,
        size: 32,
      ),
    );
  }

  Widget _buildMainPlayButton({
    required Status loadingStatus,
    required bool hasCurrentItem,
    required bool isPlaying,
  }) {
    if (loadingStatus == Status.loading) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (loadingStatus == Status.error) {
      return GestureDetector(
        onTap: hasCurrentItem ? () => _retryPlayback() : null,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.refresh,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (loadingStatus == Status.noDataFound || !hasCurrentItem) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey[600],
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.music_off,
          size: 36,
          color: Colors.white54,
        ),
      );
    }

    return GestureDetector(
      onTap: controller.togglePlayPause,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            key: ValueKey('play_$isPlaying'),
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 36,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed != null
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Center(child: child),
      ),
    );
  }

  void _retryPlayback() {
    // Retry logic - you can customize this
    final currentIndex = controller.audioPlayer.currentIndex ?? 0;
    controller.playAtIndex(currentIndex);
  }
}
