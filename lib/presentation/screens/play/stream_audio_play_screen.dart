import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/screens/play/widget/stream_audio_play_bottom.dart';
import 'package:podcast/presentation/screens/play/widget/stream_audio_play_control.dart';
import 'package:podcast/presentation/screens/play/widget/stream_audio_play_progress.dart';
import 'package:podcast/presentation/screens/play/widget/stream_audio_video_player_view.dart';
import 'package:podcast/presentation/screens/play/widget/stream_glassmorphism_toggle_widget.dart';

class StreamAudioPlayScreen extends StatefulWidget {
  const StreamAudioPlayScreen({
    super.key,
    required this.id,
    required this.title,
    this.categories,
    required this.image,
    this.artist,
    required this.duration,
    required this.url,
    required this.reels,
    required this.popular,
    required this.isAlbum,
    required this.isPlaylist,
    required this.isCreator,
  });

  final String id;
  final String title;
  final String? categories;
  final String image;
  final String? artist;
  final String duration;
  final String url;
  final bool reels;
  final bool popular;
  final bool isAlbum;
  final bool isPlaylist;
  final bool isCreator;

  @override
  State<StreamAudioPlayScreen> createState() => _StreamAudioPlayScreenState();
}

class _StreamAudioPlayScreenState extends State<StreamAudioPlayScreen>
    with WidgetsBindingObserver {
  late final PodcastManuallyPlayController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<PodcastManuallyPlayController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadPodcasts();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        debugPrint('🔄 App paused - Audio continues in background');
        break;
      case AppLifecycleState.resumed:
        debugPrint('🔄 App resumed - Syncing UI state');
        setState(() {});
        break;
      case AppLifecycleState.detached:
        debugPrint('🔄 App detached - Stopping audio playback');
        controller.pause();
        break;
      case AppLifecycleState.inactive:
        debugPrint('🔄 App inactive');
        break;
      case AppLifecycleState.hidden:
        debugPrint('🔄 App hidden');
        break;
    }
  }

  Future<void> _loadPodcasts() async {
    try {
      await controller.getPodcast(
        id: widget.id,
        firstPodcastId: widget.id,
        popular: widget.popular,
        reels: widget.reels,
        updateMainStatus: true,
      );
    } catch (e) {
      debugPrint('❌ Failed to load podcasts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: StreamBuilder(
            stream: controller.currentItemStream,
            initialData: controller.currentItem,
            builder: (context, snapshot) {
              final currentItem = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentItem?.title ?? widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    buildCategoryOrArtistText(
                        isCreator: widget.isCreator,
                        artist: widget.artist,
                        categoryName: currentItem?.categoryName),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
          actions: [
            StreamGlassMorphismToggle(
              controller: controller,
            ),
          ],
        ),
        body: Column(
          children: [
            const Gap(12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: StreamAudioVideoPlayerView(
                  controller: controller,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamAudioPlayProgress(controller: controller),
                  const Gap(12),
                  StreamAudioPlayControl(controller: controller),
                  const Gap(8),
                  StreamAudioPlayBottom(controller: controller),
                  const Gap(4),
                  // Loading more indicator
                  // StreamLoadingMoreIndicator(controller: controller),
                ],
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  String buildCategoryOrArtistText({
    required bool isCreator,
    String? artist,
    String? categoryName,
  }) {
    if (isCreator) {
      // If creator: show artist name, fallback to category name
      return (artist != null && artist.isNotEmpty) ? artist : (categoryName ?? '');
    } else {
      // If not creator: show category name only
      return categoryName ?? '';
    }
  }
}
