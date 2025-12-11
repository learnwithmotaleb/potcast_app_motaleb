/*
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mime/mime.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
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

            if (currentItem?.podcastUrl == null) {
              return const SizedBox.shrink();
            }

            final mediaType = detectMediaType(currentItem!.podcastUrl);
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
    final currentPosition = controller.audioPlayer.position;

    await controller.pause();

    AppRouter.route.pushNamed(
      RoutePath.recordPlayScreen,
      extra: {
        "url": currentItem.podcastUrl,
        "startPosition": currentPosition,
      },
    );
  }

  MediaType detectMediaType(String url) {
    final mimeType = lookupMimeType(url);
    if (mimeType != null) {
      if (mimeType.startsWith('video/')) return MediaType.video;
      if (mimeType.startsWith('audio/')) return MediaType.audio;
    }
    return MediaType.audio;
  }

}

enum MediaType{
  audio,
  video
}*/
