import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/user/play/controller/user_play_controller.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class AudioPlaySection extends StatefulWidget {
  const AudioPlaySection({super.key});

  @override
  State<AudioPlaySection> createState() => _AudioPlaySectionState();
}

class _AudioPlaySectionState extends State<AudioPlaySection> {
  final audioController = Get.find<UserPlayController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          const Gap(24),
          Obx(() {
            final position = audioController.currentPosition.value;
            final total = audioController.totalDuration.value;

            return ProgressBar(
              progress: position,
              total: total,
              thumbColor: AppColors.whiteColor,
              progressBarColor: AppColors.whiteColor,
              bufferedBarColor: AppColors.redColor,
              baseBarColor: AppColors.whiteColor.withOpacity(0.1),
              onSeek: audioController.seekAudio,
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Assets.icons.audioLeft.svg(height: 20.w,width: 20.w),
                onPressed: audioController.skipBackward,
                iconSize: 36,
              ),
              Obx(() {
                return IconButton(
                  icon: Icon(
                    audioController.isPlaying.value ? Iconsax.pause : Icons.play_arrow,
                  ),
                  onPressed: () {
                    if (audioController.isPlaying.value) {
                      audioController.pauseAudio();
                    } else {
                      audioController.play();
                    }
                  },
                  iconSize: 48,
                );
              }),
              IconButton(
                icon: Assets.icons.audioRight.svg(height: 20.w,width: 20.w),
                onPressed: audioController.skipForward,
                iconSize: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
