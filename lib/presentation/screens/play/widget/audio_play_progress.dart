import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class CenterOutBufferBar extends StatefulWidget {
  const CenterOutBufferBar({super.key});

  @override
  State<CenterOutBufferBar> createState() => _CenterOutBufferBarState();
}

class _CenterOutBufferBarState extends State<CenterOutBufferBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.5),
            ),
            child: FractionallySizedBox(
              widthFactor: _animation.value,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AudioPlayProgress extends StatelessWidget {
  const AudioPlayProgress({
    super.key,
    required this.controller,
  });

  final PodcastFeedController controller;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isLoading = controller.isLoading.value == Status.loading;
      final position = controller.currentPosition.value;
      final total = controller.totalDuration.value;
      final buffered = controller.bufferedPosition.value;

      if (isLoading || total == Duration.zero) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CenterOutBufferBar(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  "--:--",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        );
      }

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
                  widthFactor:
                      totalMillis > 0 ? bufferedMillis / totalMillis : 0,
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
              Positioned.fill(
                child: FractionallySizedBox(
                  widthFactor:
                      totalMillis > 0 ? progressMillis / totalMillis : 0,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                _formatDuration(total),
                style: const TextStyle(
                  color: Colors.white,
                ),
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
