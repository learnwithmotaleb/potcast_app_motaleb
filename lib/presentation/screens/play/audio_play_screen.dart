import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/play/widget/audio_video_player_view.dart';
import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
import 'package:podcast/service/rewarded_ad_service.dart';
import 'controller/podcast_play_controller.dart';
import 'widget/audio_play_bottom.dart';
import 'widget/audio_play_control.dart';
import 'widget/audio_play_progress.dart';
import 'widget/play-app-bar-widget.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({
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
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> with WidgetsBindingObserver {
  late final PodcastFeedController feedController;
  late final SubscriptionController subscriptionController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    feedController = Get.find<PodcastFeedController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadPodcasts();
      if (!subscriptionController.hasActiveSubscription) {
        await RewardedAdService().loadAd();
      } else {
        debugPrint("✨ Premium user detected — skipping ad preload");
      }
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
        _syncUIState();
        break;
      case AppLifecycleState.detached:
        debugPrint('🔄 App detached');
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
      await feedController.getPodcast(
        firstPodcastId: widget.id,
        id: widget.id,
        isAlbum: widget.isAlbum,
        isPlaylist: widget.isPlaylist,
        popular: widget.popular,
        reels: widget.reels,
      );
    } catch (e) {
      debugPrint('❌ Failed to load podcasts: $e');
    }
  }

  void _syncUIState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpotifyStyleAppBar(
        feedController: feedController,
        fallbackTitle: widget.title,
        fallbackArtist: widget.artist,
        fallbackCategories: widget.categories,
        isCreator: widget.isCreator,
      ),
      body: Column(
        children: [
          const Gap(12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AudioVideoPlayerView(
                feedController: feedController,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AudioPlayProgress(controller: feedController),
                AudioPlayControl(controller: feedController),
                AudioPlayBottom(controller: feedController),
              ],
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }
}
