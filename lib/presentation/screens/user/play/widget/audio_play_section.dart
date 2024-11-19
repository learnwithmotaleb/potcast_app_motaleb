import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:like_button/like_button.dart';
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
              thumbColor: isDarkMode?AppColors.whiteColor:AppColors.blackColor,
              progressBarColor: isDarkMode?AppColors.whiteColor:AppColors.blackColor,
              bufferedBarColor: AppColors.redColor,
              baseBarColor: isDarkMode?AppColors.whiteColor.withOpacity(0.1):AppColors.blackColor.withOpacity(0.1),
              onSeek: audioController.seekAudio,
            );
          }),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Assets.icons.audioLeft.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                    onPressed: audioController.skipBackward,
                    iconSize: 36,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Obx(() {
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
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Assets.icons.audioRight.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                      onPressed: audioController.skipForward,
                      iconSize: 36,
                    ),
                    LikeButton(
                      circleColor:
                      const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Iconsax.like_1,
                          color: isLiked ? Colors.red : (isDarkMode?AppColors.whiteColor:AppColors.blackColor),
                        );
                      },
                    ),
                  ],
                ),
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
