import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart' show AppColors;

class RecordAudioWidget extends StatelessWidget {
  RecordAudioWidget({
    super.key,
    required this.playerController,
    required this.recorderController,
  });

  final PlayerController playerController;
  final RecorderController recorderController;
  final controller = Get.find<PodcastAudioController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      if (controller.createLoading.value) {
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.cloud_upload_rounded, size: 28),
                    const SizedBox(width: 8),
                    CustomText(
                      text: "uploading_video".tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    const Spacer(),
                    CustomText(
                      text:
                          "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ],
                ),
                const Gap(12),
                LinearProgressIndicator(
                  value: controller.uploadProgress.value,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(16),
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blueAccent,
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text:
                          "${controller.uploadedMB.value.toStringAsFixed(2)} MB / ${controller.totalMB.value.toStringAsFixed(2)} MB",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const Gap(8),
              ],
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade800, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Obx(() {
              if (controller.isPlaying.value) {
                return AudioFileWaveforms(
                  size: Size(width, 70),
                  playerController: playerController,
                  waveformType: WaveformType.long,
                  enableSeekGesture: true,
                  waveformData: playerController.waveformData,
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.grey,
                    liveWaveColor: Colors.white,
                  ),
                );
              }
              return AudioWaveforms(
                enableGesture: false,
                size: Size(width, 80),
                recorderController: recorderController,
                waveStyle: WaveStyle(
                  showMiddleLine: true,
                  extendWaveform: true,
                  spacing: 6,
                  showTop: true,
                  showBottom: true,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFBBD2C5),
                      Color(0xFF536976),
                      Color(0xFF292E49)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, width, 70)),
                ),
              );
            }),
          ),
          const Gap(24),
          Obx(() => _buildControlButtons(
              controller, playerController, recorderController)),
          const Gap(12),
        ],
      );
    });
  }
}

Widget _buildControlButtons(PodcastAudioController controller,
    PlayerController player, RecorderController recorder) {
  if (!controller.isRecording.value) {
    if (controller.recordedFilePath.value?.isNotEmpty ?? false) {
      return Column(
        children: [
          PrimaryButton(
            text: 'Start Recording',
            onPressed: () => controller.startRecording(player, recorder),
          ),
          if (controller.isPlaying.value)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  text: controller.isPausePlaying.value
                      ? "Resume Audio"
                      : "Pause Audio",
                  color: controller.isPausePlaying.value
                      ? Colors.green
                      : Colors.orangeAccent,
                  onPressed: () => controller.isPausePlaying.value
                      ? controller.resumeAudio(player)
                      : controller.pauseAudio(player),
                ),
                const Gap(8),
                PrimaryButton(
                  text: "Stop Audio",
                  color: Colors.red,
                  onPressed: () => controller.stopAudio(player),
                ),
              ],
            )
          else
            PrimaryButton(
              text: "Play Audio",
              onPressed: () => controller.playAudio(player),
            ),
          const Gap(8),
        ],
      );
    }

    return PrimaryButton(
      text: 'Start Recording',
      onPressed: () => controller.startRecording(player, recorder),
    );
  }

  if (controller.isPaused.value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryButton(
          text: "Resume",
          color: Colors.orangeAccent,
          onPressed: () => controller.resumeRecording(recorder),
        ),
        const Gap(8),
        PrimaryButton(
          text: "Stop",
          color: Colors.red,
          onPressed: () => controller.stopRecording(recorder),
        ),
      ],
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      PrimaryButton(
        text: "Pause",
        color: Colors.green,
        onPressed: () => controller.pauseRecording(recorder),
      ),
      const Gap(8),
      PrimaryButton(
        text: "Stop",
        color: Colors.red,
        onPressed: () => controller.stopRecording(recorder),
      ),
    ],
  );
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF2E2E2E),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(150, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        shadowColor: Colors.black,
      ),
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
