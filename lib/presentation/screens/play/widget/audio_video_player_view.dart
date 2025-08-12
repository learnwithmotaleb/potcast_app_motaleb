import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:video_player/video_player.dart';

class AudioVideoPlayerView extends StatelessWidget {
  const AudioVideoPlayerView({
    super.key,
    required this.feedController,
  });

  final PodcastFeedController feedController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Obx(() {
        final status = feedController.isLoading.value;
        final imageUrl = feedController.currentItem.value.coverImage;

        if (status == Status.loading) {
          return _buildImage(imageUrl);
        }

        if (status == Status.error) {
          return _buildImage(imageUrl);
        }

        if (feedController.isAudioMode.value) {
          return _buildImage(imageUrl);
        }

        final video = feedController.videoPlayerController.value;
        if (video != null && video.value.isInitialized) {
          return VideoPlayer(video);
        }
        return _buildImage(imageUrl);
      }),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return CustomNetworkImage(
      borderRadius: BorderRadius.circular(12),
      imageUrl: imageUrl,
    );
  }
}
