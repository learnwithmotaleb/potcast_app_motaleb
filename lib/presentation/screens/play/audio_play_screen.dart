import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/screens/play/widget/audio_video_player_view.dart';
import 'widget/audio_play_bottom.dart';
import 'widget/audio_play_control.dart';
import 'widget/audio_play_progress.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({
    super.key,
    required this.audioPlayerModel,
  });

  final AudioPlayerModel audioPlayerModel;

  @override
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> {
  final controller = Get.find<AudioPlayController>();

  @override
  void initState() {
    controller.playPodcast(audioPlayModel: widget.audioPlayerModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // controller.loadAd(width: constant.maxWidth.toInt() - 20, height: constant.maxHeight.toInt());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.audioPlayerModel.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () => controller.toggleMode(),
            icon: const Icon(Iconsax.arrow_swap),
          ),
          IconButton(
            onPressed: () => controller.toggleMode(),
            icon: const Icon(Icons.report),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: AudioVideoPlayerView(
                imageUrl: widget.audioPlayerModel.image,
                isAudioMode: controller.isAudioMode,
                videoController: controller.videoPlayerController,
                loadingStatus: controller.loading,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 12,
                children: [
                  AudioPlayProgress(controller: controller),
                  AudioPlayControl(controller: controller),
                  AudioPlayBottom(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
