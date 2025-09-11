import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/dialog/custom_dialog.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class RecordAudioWidget extends StatefulWidget {
  const RecordAudioWidget({
    super.key,
    required this.playerController,
    required this.recorderController,
  });

  final PlayerController playerController;
  final RecorderController recorderController;

  @override
  State<RecordAudioWidget> createState() => _RecordAudioWidgetState();
}

class _RecordAudioWidgetState extends State<RecordAudioWidget> with TickerProviderStateMixin {
  final controller = Get.find<PodcastAudioController>();
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Timer? _recordingTimer;
  final ValueNotifier<Duration> _recordingDuration = ValueNotifier(Duration.zero);
  DateTime? _recordingStartTime;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();

    _listenToRecordingState();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();

    _recordingTimer?.cancel();
    _recordingDuration.dispose();
    super.dispose();
  }

  void _listenToRecordingState() {
    ever(controller.isRecording, (bool isRecording) {
      if (isRecording) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });

    ever(controller.isPaused, (bool isPaused) {
      if (isPaused) {
        _pauseTimer();
      } else if (controller.isRecording.value) {
        _resumeTimer();
      }
    });
  }

  void _startTimer() {
    _recordingStartTime = DateTime.now();
    _recordingDuration.value = Duration.zero;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_recordingStartTime != null) {
        final elapsed = DateTime.now().difference(_recordingStartTime!);
        _recordingDuration.value = elapsed;
      }
    });
  }

  void _pauseTimer() {
    _recordingTimer?.cancel();
  }

  void _resumeTimer() {
    if (_recordingStartTime != null) {
      final currentDuration = _recordingDuration.value;
      _recordingStartTime = DateTime.now().subtract(currentDuration);

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final elapsed = DateTime.now().difference(_recordingStartTime!);
        _recordingDuration.value = elapsed;
      });
    }
  }

  void _stopTimer() {
    _recordingTimer?.cancel();
    _recordingStartTime = null;
  }

  void _resetTimer() {
    _recordingTimer?.cancel();
    _recordingDuration.value = Duration.zero;
    _recordingStartTime = null;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.createLoading.value) {
        return _buildUploadingCard();
      }

      return FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F0F23),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(),
                const Gap(20),
                _buildWaveformSection(width),
                const Gap(24),
                _buildControlSection(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Obx(() {
      String status = "Ready to Record";
      Color statusColor = Colors.grey;
      IconData statusIcon = Icons.mic_none;

      if (controller.isRecording.value) {
        status = controller.isPaused.value ? "Recording Paused" : "Recording...";
        statusColor = controller.isPaused.value ? Colors.orange : Colors.red;
        statusIcon = controller.isPaused.value ? Icons.pause_circle : Icons.fiber_manual_record;
      } else if (controller.recordedFilePath.value?.isNotEmpty ?? false) {
        status = controller.isPlaying.value ? "Playing" : "Recording Complete";
        statusColor = controller.isPlaying.value ? Colors.green : Colors.blue;
        statusIcon = controller.isPlaying.value ? Icons.play_circle : Icons.check_circle;
      }

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 24,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Podcast Recording",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const Gap(4),
                CustomText(
                  text: status,
                  fontSize: 14,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          if (controller.isRecording.value) _buildRecordingTimer(),
        ],
      );
    });
  }

  Widget _buildRecordingTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              if (controller.isRecording.value && !controller.isPaused.value) {
                _pulseController.repeat(reverse: true);
              } else {
                _pulseController.stop();
              }
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          const Gap(8),
          ValueListenableBuilder<Duration>(
            valueListenable: _recordingDuration,
            builder: (context, duration, child) {
              return CustomText(
                text: _formatDuration(duration),
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformSection(double width) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Obx(() {
          if (controller.isPlaying.value) {
            return AudioFileWaveforms(
              size: Size(width, 120),
              playerController: widget.playerController,
              waveformType: WaveformType.fitWidth,
              enableSeekGesture: true,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: Colors.grey.withOpacity(0.3),
                liveWaveColor: Colors.deepPurple,
                seekLineColor: Colors.white,
                seekLineThickness: 2,
                waveCap: StrokeCap.round,
              ),
            );
          }
          return AudioWaveforms(
            enableGesture: false,
            size: Size(width, 120),
            recorderController: widget.recorderController,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              extendWaveform: true,
              spacing: 4,
              showTop: true,
              showBottom: true,
              waveCap: StrokeCap.round,
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.withOpacity(0.8),
                  Colors.purpleAccent,
                  Colors.pinkAccent.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(Rect.fromLTWH(0, 0, width, 120)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildControlSection() {
    return Obx(() {
      if (!controller.isRecording.value) {
        if (controller.recordedFilePath.value?.isNotEmpty ?? false) {
          return _buildPlaybackControls();
        }
        return _buildStartRecordingButton();
      }
      return _buildRecordingControls();
    });
  }

  Widget _buildStartRecordingButton() {
    return GestureDetector(
      onTapDown: (_) => _scaleController.reverse(),
      onTapUp: (_) => _scaleController.forward(),
      onTapCancel: () => _scaleController.forward(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    _resetTimer();
                    controller.startRecording(
                      widget.playerController,
                      widget.recorderController,
                    );
                  },
                  child: const Center(
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecordingControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: controller.isPaused.value ? Icons.play_arrow : Icons.pause,
          color: Colors.orange,
          onTap: controller.isPaused.value
              ? () => controller.resumeRecording(widget.recorderController)
              : () => controller.pauseRecording(widget.recorderController),
        ),
        _buildControlButton(
          icon: Icons.stop,
          color: Colors.red,
          onTap: () => controller.stopRecording(widget.recorderController),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.mic,
          color: Colors.blue,
          onTap: () {
            showCustomAnimatedDialog(
              context: context,
              title: "Reset Recording",
              subtitle: "Do you really want to reset the recording? This action cannot be undone and your current ${_formatDuration(_recordingDuration.value)} recording will be lost.",
              actionButton: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Keep Recording",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetTimer(); // Reset timer
                      controller.startRecording(
                        widget.playerController,
                        widget.recorderController,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Reset & Record",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        if (controller.isPlaying.value)
          _buildControlButton(
            icon: controller.isPausePlaying.value ? Icons.play_arrow : Icons.pause,
            color: Colors.green,
            onTap: controller.isPausePlaying.value
                ? () => controller.resumeAudio(widget.playerController)
                : () => controller.pauseAudio(widget.playerController),
          )
        else
          _buildControlButton(
            icon: Icons.play_arrow,
            color: Colors.green,
            onTap: () => controller.playAudio(widget.playerController),
          ),
        if (controller.isPlaying.value)
          _buildControlButton(
            icon: Icons.stop,
            color: Colors.red,
            onTap: () => controller.stopAudio(widget.playerController),
          ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadingCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.cloud_upload_rounded,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "uploading_video".tr,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const Gap(4),
                    const CustomText(
                      text: "Please wait while we process your audio...",
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Obx(() => CustomText(
                    text: "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  )),
            ],
          ),
          const Gap(16),
          Obx(() => LinearProgressIndicator(
                value: controller.uploadProgress.value,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              )),
          const Gap(12),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "${controller.uploadedMB.value.toStringAsFixed(2)} MB",
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(
                    text: "${controller.totalMB.value.toStringAsFixed(2)} MB",
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
