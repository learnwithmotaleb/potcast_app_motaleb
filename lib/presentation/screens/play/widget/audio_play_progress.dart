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

      double totalMillis = total.inMilliseconds.toDouble();
      double bufferedMillis = buffered.inMilliseconds.toDouble();
      double progressMillis = position.inMilliseconds.toDouble();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Progress Bar with Buffered Position
          Stack(
            children: [
              // Base line (Background)
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              // Buffered progress
              Positioned.fill(
                child: FractionallySizedBox(
                  widthFactor: totalMillis > 0 ? bufferedMillis / totalMillis : 0,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              ),
              // Current progress
              Positioned.fill(
                child: FractionallySizedBox(
                  widthFactor: totalMillis > 0 ? progressMillis / totalMillis : 0,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Row with Total and Current Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                _formatDuration(total),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
        ],
      );
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
