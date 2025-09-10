import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import '../controller/podcast_play_controller.dart';

class AudioPlayControl extends StatelessWidget {
  final PodcastFeedController controller;

  const AudioPlayControl({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() {
        final loadingStatus = controller.loadingStatus.value;
        final hasCurrentItem = controller.hasCurrentItem;
        final isPlaying = controller.isPlaying.value;
        final currentItem = controller.currentItem.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFavoriteButton(currentItem),
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

            _buildMainPlayButton(
              loadingStatus: loadingStatus,
              hasCurrentItem: hasCurrentItem,
              isPlaying: isPlaying,
            ),

            _buildSkipButton(
              onPressed: hasCurrentItem && loadingStatus != Status.loading
                  ? () => controller.playNext()
                  : null,
              icon: Icon(
                Icons.skip_next,
                color: hasCurrentItem ? Colors.white : Colors.white38,
                size: 24,
              ),
            ),

            _buildLikeButton(currentItem),
          ],
        );
      }),
    );
  }

  Widget _buildFavoriteButton(PlayPodcastItem? currentItem) {
    return Obx(() {
      final isLoading = controller.favoriteLoading.value;
      final isFavorited = controller.isFavorite.value;

      return _buildControlButton(
        onPressed: isLoading || currentItem == null
            ? null
            : () => _handleFavorite(currentItem.id ?? ""),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
            key: const ValueKey('loading'),
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white.withOpacity(0.7),
            ),
          )
              : Icon(
            key: ValueKey('favorite_$isFavorited'),
            Icons.favorite,
            size: 28,
            color: isFavorited ? Colors.green : Colors.white70,
          ),
        ),
      );
    });
  }

  Widget _buildLikeButton(PlayPodcastItem? currentItem) {
    return Obx(() {
      final isLoading = controller.likeLoading.value;
      final isLiked = controller.isLike.value;

      return _buildControlButton(
        onPressed: isLoading || currentItem == null
            ? null
            : () => _handleLike(currentItem.id ?? ""),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
            key: const ValueKey('loading'),
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white.withOpacity(0.7),
            ),
          )
              : Icon(
            key: ValueKey('like_$isLiked'),
            Icons.thumb_up,
            size: 28,
            color: isLiked ? Colors.green : Colors.white70,
          ),
        ),
      );
    });
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
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
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

    // Error state
    if (loadingStatus == Status.error) {
      return GestureDetector(
        onTap: hasCurrentItem ? controller.retryCurrentPodcast : null,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
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

    // No data state
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

    // Normal play/pause state
    return GestureDetector(
      onTap: controller.togglePlayPause,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: isPlaying ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ] : [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
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
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Center(child: child),
      ),
    );
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
      // Show error feedback
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Text('Failed to update favorite'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),
        );
      }
    }
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
      // Show error feedback
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Text('Failed to update like'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),
        );
      }
    }
  }
}