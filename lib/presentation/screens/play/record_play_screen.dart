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
  final ValueNotifier<bool> _showIcon = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    final feedController = Get.find<PodcastFeedController>();
    feedController.stopAudioIfPlaying();

    _initializeVideo(widget.url);
  }

  Future<void> _initializeVideo(String videoUrl) async {
    try {
      if (kDebugMode) {
        print(videoUrl);
      }
      final Uri uri = Uri.parse(videoUrl);
      _videoPlayerController = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) {
          _isLoading.value = false;
          _videoPlayerController?.play();
          _isPlay.value = true;
        }).catchError((error) {
          _isLoading.value = false;
          _isError.value = true;
          if (kDebugMode) {
            print('Video initialization error: $error');
          }
        });
    } catch (e) {
      _isLoading.value = false;
      _isError.value = true;
      if (kDebugMode) {
        print('Error initializing video: $e');
      }
    }
  }

  Future<void> togglePlayPause() async {
    try {
      final controller = _videoPlayerController;
      if (controller != null && controller.value.isInitialized) {
        if (controller.value.isPlaying) {
          controller.pause();
          _isPlay.value = false;
        } else {
          controller.play();
          _isPlay.value = true;
        }

        _showIcon.value = true;
        Future.delayed(const Duration(seconds: 2), () {
          _showIcon.value = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _isLoading.dispose();
    _isError.dispose();
    _isPlay.dispose();
    _showIcon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Streaming Record"),
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

                return _videoPlayerController != null
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video player
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => togglePlayPause(),
                        child: VideoPlayer(_videoPlayerController!),
                      ),
                    ),

                    // Fade animated play/pause icon
                    ValueListenableBuilder<bool>(
                      valueListenable: _showIcon,
                      builder: (context, showIcon, child) {
                        return AnimatedOpacity(
                          opacity: showIcon ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _isPlay,
                            builder: (context, isPlay, _) {
                              return Center(
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isPlay ? Iconsax.pause : Iconsax.play,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                  ],
                ) : const Center(child: Text("No data found"));
              },
            );
          },
        ),
      ),
    );
  }
}