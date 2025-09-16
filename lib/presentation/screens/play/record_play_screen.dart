import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:video_player/video_player.dart';

import 'controller/podcast_play_controller.dart';

class RecordPlayScreen extends StatefulWidget {
  const RecordPlayScreen({super.key, required this.url});

  final String url;

  @override
  State<RecordPlayScreen> createState() => _RecordPlayScreenState();
}

class _RecordPlayScreenState extends State<RecordPlayScreen> {
  VideoPlayerController? _videoPlayerController;
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<bool> _isError = ValueNotifier(false);
  final ValueNotifier<bool> _isPlay = ValueNotifier(false);
  final ValueNotifier<bool> _showControls = ValueNotifier(true);
  final ValueNotifier<Duration> _currentPosition = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _totalDuration = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  final ValueNotifier<double> _volume = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();

    final feedController = Get.find<PodcastFeedController>();
    feedController.stopAudioIfPlaying();

    _initializeVideo(widget.url);
  }

  Future<void> _initializeVideo(String videoUrl) async {
    try {
      _isLoading.value = true;
      _isError.value = false;

      if (kDebugMode) {
        print(videoUrl);
      }

      final Uri uri = Uri.parse(videoUrl);
      _videoPlayerController = VideoPlayerController.networkUrl(uri);

      await _videoPlayerController!.initialize();

      // Set up listeners
      _videoPlayerController!.addListener(_videoListener);

      _isLoading.value = false;
      _totalDuration.value = _videoPlayerController!.value.duration;

      // Auto play
      _videoPlayerController!.play();
      _isPlay.value = true;

      // Hide controls after 3 seconds
      _hideControlsAfterDelay();
    } catch (e) {
      _isLoading.value = false;
      _isError.value = true;
      if (kDebugMode) {
        print('Error initializing video: $e');
      }
    }
  }

  void _videoListener() {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      _currentPosition.value = _videoPlayerController!.value.position;
      _isPlay.value = _videoPlayerController!.value.isPlaying;

      // Check if video ended
      if (_currentPosition.value >= _totalDuration.value && _totalDuration.value > Duration.zero) {
        _isPlay.value = false;
      }
    }
  }

  Future<void> togglePlayPause() async {
    try {
      final controller = _videoPlayerController;
      if (controller != null && controller.value.isInitialized) {
        if (controller.value.isPlaying) {
          await controller.pause();
        } else {
          await controller.play();
        }
        _showControlsTemporarily();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showControlsTemporarily() {
    _showControls.value = true;
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_isPlay.value) {
        _showControls.value = false;
      }
    });
  }

  void _seekToPosition(Duration position) {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      _videoPlayerController!.seekTo(position);
      _showControlsTemporarily();
    }
  }

  void _skipForward() {
    if (_videoPlayerController != null) {
      final newPosition = _currentPosition.value + const Duration(seconds: 10);
      final maxDuration = _totalDuration.value;
      if (newPosition <= maxDuration) {
        _seekToPosition(newPosition);
      } else {
        _seekToPosition(maxDuration);
      }
    }
  }

  void _skipBackward() {
    if (_videoPlayerController != null) {
      final newPosition = _currentPosition.value - const Duration(seconds: 10);
      if (newPosition >= Duration.zero) {
        _seekToPosition(newPosition);
      } else {
        _seekToPosition(Duration.zero);
      }
    }
  }

  void _toggleMute() {
    if (_videoPlayerController != null) {
      if (_isMuted.value) {
        _videoPlayerController!.setVolume(_volume.value);
        _isMuted.value = false;
      } else {
        _videoPlayerController!.setVolume(0.0);
        _isMuted.value = true;
      }
      _showControlsTemporarily();
    }
  }

  void _setVolume(double volume) {
    if (_videoPlayerController != null) {
      _volume.value = volume;
      if (!_isMuted.value) {
        _videoPlayerController!.setVolume(volume);
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    _isLoading.dispose();
    _isError.dispose();
    _isPlay.dispose();
    _showControls.dispose();
    _currentPosition.dispose();
    _totalDuration.dispose();
    _isMuted.dispose();
    _volume.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Streaming Record"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        top: false,
        child: ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const LoadingWidget();
            }
            return ValueListenableBuilder<bool>(
              valueListenable: _isError,
              builder: (context, isError, child) {
                if (isError) {
                  return Center(
                    child: NoInternetCard(onTap: () {
                      _initializeVideo(widget.url);
                    }),
                  );
                }

                return _videoPlayerController != null && _videoPlayerController!.value.isInitialized
                    ? _buildVideoPlayer()
                    : const Center(
                        child: Text(
                          "No data found",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    print(_videoPlayerController!.value.aspectRatio);
    return Center(
      child: AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video player
            VideoPlayer(_videoPlayerController!),

            // Tap area for controls
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _showControls.value = !_showControls.value;
                  if (_showControls.value) {
                    _hideControlsAfterDelay();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(),
              ),
            ),

            // Video controls overlay
            ValueListenableBuilder<bool>(
              valueListenable: _showControls,
              builder: (context, showControls, child) {
                return AnimatedOpacity(
                  opacity: showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: _isMuted,
                                builder: (context, isMuted, child) {
                                  return IconButton(
                                    onPressed: _toggleMute,
                                    icon: Icon(
                                      isMuted ? Iconsax.volume_cross : Iconsax.volume_high,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _skipBackward,
                              icon: const Icon(
                                Iconsax.backward_10_seconds,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 20),
                            ValueListenableBuilder<bool>(
                              valueListenable: _isPlay,
                              builder: (context, isPlay, child) {
                                return GestureDetector(
                                  onTap: togglePlayPause,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isPlay ? Iconsax.pause : Iconsax.play,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              onPressed: _skipForward,
                              icon: const Icon(
                                Iconsax.forward_10_seconds,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ValueListenableBuilder<Duration>(
                                valueListenable: _currentPosition,
                                builder: (context, currentPosition, child) {
                                  return ValueListenableBuilder<Duration>(
                                    valueListenable: _totalDuration,
                                    builder: (context, totalDuration, child) {
                                      return Slider(
                                        value: totalDuration.inMilliseconds > 0
                                            ? currentPosition.inMilliseconds.toDouble()
                                            : 0.0,
                                        max: totalDuration.inMilliseconds.toDouble(),
                                        onChanged: (value) {
                                          final position = Duration(milliseconds: value.toInt());
                                          _seekToPosition(position);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),

                              // Time display
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ValueListenableBuilder<Duration>(
                                    valueListenable: _currentPosition,
                                    builder: (context, currentPosition, child) {
                                      return Text(
                                        _formatDuration(currentPosition),
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      );
                                    },
                                  ),
                                  ValueListenableBuilder<Duration>(
                                    valueListenable: _totalDuration,
                                    builder: (context, totalDuration, child) {
                                      return Text(
                                        _formatDuration(totalDuration),
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
