import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/utils/app_const/app_const.dart';

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

        if (status == Status.loading ||
            status == Status.error ||
            feedController.isAudioMode.value) {
          return _buildImage(imageUrl);
        }

        final controller = feedController.betterPlayerController.value;
        if (controller != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BetterPlayer(controller: controller),
          );
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
