import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class StreamAudioVideoPlayerView extends StatelessWidget {
  const StreamAudioVideoPlayerView({
    super.key,
    required this.controller,
  });

  final PodcastManuallyPlayController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Status>(
      stream: controller.loadingStatusStream,
      initialData: controller.loadingStatus,
      builder: (context, statusSnapshot) {
        final loadingStatus = statusSnapshot.data ?? Status.loading;

        return StreamBuilder<PlayEntity?>(
          stream: controller.currentItemStream,
          initialData: controller.currentItem,
          builder: (context, currentItemSnapshot) {
            final currentItem = currentItemSnapshot.data;

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Expanded(
                    child: _buildContent(
                      loadingStatus: loadingStatus,
                      currentItem: currentItem,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // _buildMetadata(currentItem),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent({
    required Status loadingStatus,
    required PlayEntity? currentItem,
    required BuildContext context,
  }) {
    if (loadingStatus == Status.loading) {
      return _buildLoadingState(currentItem?.coverImage);
    }

    if (loadingStatus == Status.error) {
      return _buildErrorState(
        currentItem?.coverImage,
        onRetry: () {
          final currentIndex = controller.audioPlayer.currentIndex ?? 0;
          controller.playAtIndex(currentIndex);
        },
      );
    }

    if (loadingStatus == Status.noDataFound) {
      return _buildNoDataState(currentItem?.coverImage);
    }

    return _buildImage(currentItem?.coverImage);
  }

  Widget _buildMetadata(PlayEntity? currentItem) {
    return StreamBuilder<dynamic>(
      stream: controller.sequenceStateStream,
      builder: (context, snapshot) {
        final tag = snapshot.data?.currentSource?.tag;
        final mediaItem = tag is MediaItem ? tag : null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                mediaItem?.title ?? currentItem?.title ?? 'Unknown Title',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                mediaItem?.artist ?? currentItem?.creatorName ?? 'Unknown Artist',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (mediaItem?.album != null || currentItem?.categoryName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    mediaItem?.album ?? currentItem?.categoryName ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(String? imageUrl) {
    return _buildImageWithOverlay(
      imageUrl,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Loading media...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? imageUrl, {required VoidCallback onRetry}) {
    return _buildImageWithOverlay(
      imageUrl,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.red.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text(
                  'Playback Failed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap to retry',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.black,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState(String? imageUrl) {
    return _buildImageWithOverlay(
      imageUrl,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.music_off,
              color: Colors.white70,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'No media available',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CustomNetworkImage(
          imageUrl: imageUrl ?? "",
          borderRadius: BorderRadius.circular(16),
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildImageWithOverlay(String? imageUrl, Widget overlay) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl ?? "",
              borderRadius: BorderRadius.circular(16),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: overlay),
            ),
          ],
        ),
      ),
    );
  }
}
