import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_play_controller.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class StreamGlassMorphismToggle extends StatelessWidget {
  final PodcastManuallyPlayController controller;

  const StreamGlassMorphismToggle({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Status>(
      stream: controller.loadingStatusStream,
      initialData: controller.loadingStatus,
      builder: (context, statusSnapshot) {
        final isLoading = statusSnapshot.data == Status.loading;

        return StreamBuilder(
          stream: controller.currentItemStream,
          initialData: controller.currentItem,
          builder: (context, itemSnapshot) {
            final currentItem = itemSnapshot.data;

            // Only show for video files
            if (currentItem?.podcastUrl == null) {
              return const SizedBox.shrink();
            }

            final mediaType = _getMediaType(currentItem!.podcastUrl);
            if (mediaType != MediaType.video) {
              return const SizedBox.shrink();
            }

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
                  onTap: isLoading
                      ? null
                      : () => _navigateToVideoPlayer(currentItem),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
          },
        );
      },
    );
  }

  void _navigateToVideoPlayer(dynamic currentItem) async {
    // Get current audio position before stopping
    final currentPosition = controller.audioPlayer.position;

    // Stop current audio playback
    await controller.pause();

    // Navigate to video player screen with current position
    AppRouter.route.pushNamed(
      RoutePath.recordPlayScreen,
      extra: {
        "url": currentItem.podcastUrl,
        "startPosition": currentPosition,
      },
    );
  }

  MediaType _getMediaType(String url) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();

    // Video extensions
    if (path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.avi') ||
        path.endsWith('.mkv') ||
        path.endsWith('.webm') ||
        path.endsWith('.m4v')) {
      return MediaType.video;
    }

    // Audio extensions (default)
    return MediaType.audio;
  }
}
