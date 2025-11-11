import 'package:flutter/material.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class StreamAudioPlayProgress extends StatelessWidget {
  const StreamAudioPlayProgress({
    super.key,
    required this.controller,
  });

  final PodcastManuallyPlayController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Status>(
      stream: controller.loadingStatusStream,
      initialData: controller.loadingStatus,
      builder: (context, statusSnapshot) {
        final loadingStatus = statusSnapshot.data ?? Status.loading;

        return StreamBuilder<Duration>(
          stream: controller.positionStream,
          initialData: Duration.zero,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;

            return StreamBuilder<Duration?>(
              stream: controller.durationStream,
              initialData: controller.audioPlayer.duration,
              builder: (context, durationSnapshot) {
                final total = durationSnapshot.data ?? Duration.zero;

                return StreamBuilder<Duration>(
                  stream: controller.bufferedPositionStream,
                  initialData: Duration.zero,
                  builder: (context, bufferedSnapshot) {
                    final buffered = bufferedSnapshot.data ?? Duration.zero;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressBar(
                          loadingStatus: loadingStatus,
                          position: position,
                          total: total,
                          buffered: buffered,
                          hasCurrentItem: controller.currentItem != null,
                          context: context,
                        ),
                        _buildTimeLabels(
                          loadingStatus: loadingStatus,
                          position: position,
                          total: total,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProgressBar({
    required Status loadingStatus,
    required Duration position,
    required Duration total,
    required Duration buffered,
    required bool hasCurrentItem,
    required BuildContext context,
  }) {
    if (loadingStatus == Status.loading || !hasCurrentItem) {
      return Container(
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2.5),
          child: LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ),
      );
    }

    if (loadingStatus == Status.error) {
      return Container(
        height: 5,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(2.5),
        ),
      );
    }

    double totalMillis = total.inMilliseconds.toDouble();
    double bufferedPercent = totalMillis > 0 ? (buffered.inMilliseconds / totalMillis).clamp(0.0, 1.0) : 0.0;
    double progressPercent = totalMillis > 0 ? (position.inMilliseconds / totalMillis).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTapDown: (details) => _handleSeek(details, total, context),
      child: SizedBox(
        height: 20,
        child: Center(
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.5),
            ),
            child: Stack(
              children: [
                // Buffered indicator
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: bufferedPercent,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ),
                // Progress indicator
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: progressPercent,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ),
                // Progress thumb
                if (progressPercent > 0)
                  Positioned(
                    left: (MediaQuery.of(context).size.width - 48) * progressPercent - 6,
                    top: -2.5,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLabels({
    required Status loadingStatus,
    required Duration position,
    required Duration total,
  }) {
    if (loadingStatus == Status.loading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          Text(
            "--:--",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    if (loadingStatus == Status.error) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Error",
            style: TextStyle(
              color: Colors.red.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          Text(
            "--:--",
            style: TextStyle(
              color: Colors.red.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDuration(position),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          _formatDuration(total),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _handleSeek(TapDownDetails details, Duration total, BuildContext context) {
    if (total == Duration.zero || controller.currentItem == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final percentage = (localPosition.dx / renderBox.size.width).clamp(0.0, 1.0);
    final seekPosition = Duration(
      milliseconds: (total.inMilliseconds * percentage).round(),
    );

    controller.seek(seekPosition);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
