import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import '../controller/podcast_play_controller.dart';
import '../record_play_screen.dart';

class GlassMorphismToggle extends StatelessWidget {
  final PodcastFeedController feedController;

  const GlassMorphismToggle({
    super.key,
    required this.feedController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = feedController.loadingStatus.value == Status.loading;
      final currentItem = feedController.currentItem.value;
      
      // Only show for video files
      if (currentItem?.podcastUrl == null) return const SizedBox.shrink();
      
      final mediaType = feedController.getMediaType(currentItem!.podcastUrl);
      if (mediaType != MediaType.video) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isLoading ? null : () => _navigateToVideoPlayer(currentItem),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.video,
                    size: 20,
                    color: isLoading
                        ? Colors.grey.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _navigateToVideoPlayer(dynamic currentItem) {
    // Get current audio position before stopping
    final currentPosition = feedController.currentPosition.value;
    
    // Stop current audio playback
    feedController.stopAudioIfPlaying();
    
    // Navigate to video player screen with current position
    AppRouter.route.pushNamed(
      RoutePath.recordPlayScreen,
      extra: {"url": currentItem.podcastUrl, "startPosition": currentPosition},
    );
  }
}
