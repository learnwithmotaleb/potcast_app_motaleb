import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';

class AudioPlayProgress extends StatelessWidget {
  const AudioPlayProgress({
    super.key,
    required this.controller,
  });

  final AudioPlayController controller;

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
          Stack(
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Positioned.fill(
                child: FractionallySizedBox(
                  widthFactor: totalMillis > 0 ? bufferedMillis / totalMillis : 0,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
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
          const SizedBox(height: 10),
          // Row with Total and Current Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
              ),
              Text(
                _formatDuration(total),
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
