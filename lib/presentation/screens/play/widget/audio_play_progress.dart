import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class AudioPlayProgress extends StatefulWidget {
  const AudioPlayProgress({super.key});

  @override
  State<AudioPlayProgress> createState() => _AudioPlayProgressState();
}

class _AudioPlayProgressState extends State<AudioPlayProgress> {
  final controller = Get.find<AudioPlayController>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final position = controller.currentPosition.value;
      final total = controller.totalDuration.value;
      final buffered = controller.bufferedPosition.value;

      return ProgressBar(
        progress: position,
        total: total,
        buffered: buffered,
        thumbColor: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
        progressBarColor: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
        bufferedBarColor: isDarkMode ? AppColors.whiteColor.withOpacity(0.5) : AppColors.blackColor.withOpacity(0.5),
        baseBarColor: isDarkMode ? AppColors.whiteColor.withOpacity(0.1) : AppColors.blackColor.withOpacity(0.1),
        onSeek: controller.seekAudio,
      );
    });
  }
}
