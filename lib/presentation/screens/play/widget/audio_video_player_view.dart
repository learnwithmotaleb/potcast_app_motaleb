import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:video_player/video_player.dart';

class AudioVideoPlayerView extends StatelessWidget {
  const AudioVideoPlayerView({
    super.key,
    required this.imageUrl,
    required this.isAudioMode,
    required this.videoController,
    required this.loadingStatus,
  });

  final String imageUrl;
  final RxBool isAudioMode;
  final Rx<Status> loadingStatus;
  final Rx<VideoPlayerController?> videoController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Obx(() {
        final status = loadingStatus.value;

        if (status == Status.loading) {
          return _buildImage();
        }

        if (status == Status.error) {
          return _buildImage();
        }

        if (isAudioMode.value) {
          return _buildImage();
        }

        final video = videoController.value;
        if (video != null && video.value.isInitialized) {
          return AspectRatio(
            aspectRatio: video.value.aspectRatio,
            child: VideoPlayer(video),
          );
        }
        return _buildImage();
      }),
    );
  }

  Widget _buildImage() {
    return CustomNetworkImage(
      borderRadius: BorderRadius.circular(12),
      imageUrl: imageUrl,
    );
  }
}
