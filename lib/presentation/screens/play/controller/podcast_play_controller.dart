/*
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

enum PlayMode { audio, video }
enum PlayerState { stopped, playing, paused, loading, buffering }

class PodcastPlayController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  // Video Player
  final Rx<BetterPlayerController?> betterPlayerController = Rx(null);

  // Audio Player
  final AudioPlayer audioPlayer = AudioPlayer();

  // Progress tracking
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;

  // Playlist data
  final RxList<PlayPodcastItem> podcastList = RxList<PlayPodcastItem>([]);
  final Rx<PlayPodcastItem?> currentItem = Rx<PlayPodcastItem?>(null);
  final RxInt currentIndex = 0.obs;

  // UI States
  final RxBool isLike = false.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<PlayerState> playerState = PlayerState.stopped.obs;
  final Rx<PlayMode> playMode = PlayMode.audio.obs;
  final RxBool isVideoAvailable = false.obs;
  final RxDouble playbackSpeed = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAudioSession();
    _setupAudioListeners();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    betterPlayerController.value?.dispose();
    super.onClose();
  }

  Future<void> _initializeAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (e) {
      print('Error initializing audio session: $e');
    }
  }

  // Setup audio player listeners
  void _setupAudioListeners() {
    // Position stream
    audioPlayer.positionStream.listen((position) {
      if (playMode.value == PlayMode.audio) {
        currentPosition.value = position;
      }
    });

    // Duration stream
    audioPlayer.durationStream.listen((duration) {
      if (playMode.value == PlayMode.audio && duration != null) {
        totalDuration.value = duration;
      }
    });

    // Buffered position stream
    audioPlayer.bufferedPositionStream.listen((buffered) {
      if (playMode.value == PlayMode.audio) {
        bufferedPosition.value = buffered;
      }
    });

    // Player state stream
    audioPlayer.playerStateStream.listen((state) {
      if (playMode.value == PlayMode.audio) {
        switch (state.processingState) {
          case ProcessingState.idle:
            playerState.value = PlayerState.stopped;
            break;
          case ProcessingState.loading:
          case ProcessingState.buffering:
            playerState.value = PlayerState.buffering;
            break;
          case ProcessingState.ready:
            playerState.value = state.playing ? PlayerState.playing : PlayerState.paused;
            break;
          case ProcessingState.completed:
            playerState.value = PlayerState.stopped;
            playNextPodcast();
            break;
        }
      }
    });
  }

  // Fetch podcast list from server
  Future<void> getPodcast({
    bool? reels,
    bool? popular,
    String? firstPodcastId,
    bool isAlbum = false,
    bool isPlaylist = false,
    String? id,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final String url = ApiUrl.playFeed(
        reels: reels,
        popular: popular,
        firstPodcastId: firstPodcastId,
        id: id,
        isAlbum: isAlbum,
        isPlaylist: isPlaylist,
      );

      final response = await fetchFromServer(url);

      if (response.statusCode == 200) {
        final playFeedModel = PlayFeedModel.fromJson(response.body);
        final newItems = playFeedModel.data?.podcasts ?? [];

        podcastList.value = newItems;

        // Auto-play first item if available
        if (newItems.isNotEmpty) {
          currentIndex.value = 0;
          currentItem.value = newItems[0];
          await playPodcast();
        }
      }
    } catch (e) {
      debugPrint('Error fetching podcasts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Response<dynamic>> fetchFromServer(String apiUrl) async {
    try {
      final response = await apiClient.get(
        url: apiUrl,
        showResult: true,
      );
      return response;
    } catch (_) {
      return const Response(statusCode: 503, statusText: 'No Internet Connection');
    }
  }

  // Main play function
  Future<void> playPodcast([int? index]) async {
    try {
      if (index != null) {
        currentIndex.value = index;
        currentItem.value = podcastList[index];
      }

      if (currentItem.value?.podcastUrl == null) return;

      playerState.value = PlayerState.loading;

      // Update UI states
      isLike.value = currentItem.value?.isLike ?? false;
      isFavorite.value = currentItem.value?.isBookmark ?? false;

      final url = currentItem.value!.podcastUrl!;
      isVideoAvailable.value = _isVideoUrl(url);

      // Start with audio mode by default
      playMode.value = PlayMode.audio;
      await _loadAudio();

    } catch (e) {
      print('Error playing podcast: $e');
      playerState.value = PlayerState.stopped;
    }
  }

  // Load audio with HLS support
  Future<void> _loadAudio() async {
    try {
      playerState.value = PlayerState.loading;

      final url = currentItem.value?.podcastUrl;
      if (url == null) return;

      // Stop video if playing
      if (betterPlayerController.value != null) {
        await betterPlayerController.value!.pause();
      }

      // Load and play audio
      await audioPlayer.setUrl(url);
      await audioPlayer.play();

    } catch (e) {
      print('Error loading audio: $e');
      playerState.value = PlayerState.stopped;
    }
  }

  // Load video with HLS support
  Future<void> _loadVideo(String url) async {
    try {
      playerState.value = PlayerState.loading;

      // Stop audio player
      await audioPlayer.stop();

      // Configure Better Player
      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
        liveStream: url.contains('.m3u8'),
        useAsmsSubtitles: true,
        videoFormat: BetterPlayerVideoFormat.hls,
      );

      const betterPlayerConfiguration = BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        systemOverlaysAfterFullScreen: SystemUiOverlay.values,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
      );

      if (betterPlayerController.value != null) {
        betterPlayerController.value!.dispose();
      }

      // Create new controller
      betterPlayerController.value = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource,
      );

      _updateVideoProgress();

    } catch (e) {
      print('Error loading video: $e');
      playerState.value = PlayerState.stopped;
    }
  }

  // Toggle between audio and video mode
  Future<void> toggleMode({required String url}) async {
    try {
      if (!isVideoAvailable.value) return;

      if (playMode.value == PlayMode.audio) {
        // Switch to video
        playMode.value = PlayMode.video;
        await _loadVideo(url);
      } else {
        // Switch to audio
        playMode.value = PlayMode.audio;
        await _loadAudio();
      }
    } catch (e) {
      print('Error toggling mode: $e');
    }
  }

  // Play/Pause functionality
  void togglePlayPause() {
    try {
      if (playMode.value == PlayMode.audio) {
        if (audioPlayer.playing) {
          audioPlayer.pause();
        } else {
          audioPlayer.play();
        }
      } else {
        if (betterPlayerController.value != null) {
          if (playerState.value == PlayerState.playing) {
            betterPlayerController.value!.pause();
          } else {
            betterPlayerController.value!.play();
          }
        }
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  // Seek to specific position
  void seekAudio(Duration position) {
    try {
      if (playMode.value == PlayMode.audio) {
        audioPlayer.seek(position);
      } else {
        betterPlayerController.value?.seekTo(position);
      }
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  // Skip backward (15 seconds)
  void skipBackward() {
    try {
      final currentPos = currentPosition.value;
      final newPosition = currentPos - const Duration(seconds: 15);
      final seekPosition = newPosition.isNegative ? Duration.zero : newPosition;
      seekAudio(seekPosition);
    } catch (e) {
      print('Error skipping backward: $e');
    }
  }

  // Skip forward (15 seconds)
  void skipForward() {
    try {
      final currentPos = currentPosition.value;
      final newPosition = currentPos + const Duration(seconds: 15);
      final maxPosition = totalDuration.value;
      final seekPosition = newPosition > maxPosition ? maxPosition : newPosition;
      seekAudio(seekPosition);
    } catch (e) {
      print('Error skipping forward: $e');
    }
  }

  // Play next podcast
  void playNextPodcast() {
    try {
      if (currentIndex.value < podcastList.length - 1) {
        final nextIndex = currentIndex.value + 1;
        playPodcast(nextIndex);
      } else {
        // Reached end of playlist
        playerState.value = PlayerState.stopped;
      }
    } catch (e) {
      print('Error playing next podcast: $e');
    }
  }

  // Play previous podcast
  void playPreviousPodcast() {
    try {
      if (currentIndex.value > 0) {
        final prevIndex = currentIndex.value - 1;
        playPodcast(prevIndex);
      }
    } catch (e) {
      print('Error playing previous podcast: $e');
    }
  }

  // Set playback speed
  void setPlaybackSpeed(double speed) {
    try {
      playbackSpeed.value = speed;
      if (playMode.value == PlayMode.audio) {
        audioPlayer.setSpeed(speed);
      }
      // Note: BetterPlayer speed control can be added if supported
    } catch (e) {
      print('Error setting playback speed: $e');
    }
  }

  // Update video progress
  void _updateVideoProgress() {
    betterPlayerController.value?.addEventsListener((event) {
      switch (event.betterPlayerEventType) {
        case BetterPlayerEventType.progress:
          if (playMode.value == PlayMode.video) {
            currentPosition.value = event.parameters?["progress"] ?? Duration.zero;
            totalDuration.value = event.parameters?["duration"] ?? Duration.zero;
            bufferedPosition.value = event.parameters?["buffered"] ?? Duration.zero;
          }
          break;
        case BetterPlayerEventType.play:
          if (playMode.value == PlayMode.video) {
            playerState.value = PlayerState.playing;
          }
          break;
        case BetterPlayerEventType.pause:
          if (playMode.value == PlayMode.video) {
            playerState.value = PlayerState.paused;
          }
          break;
        case BetterPlayerEventType.finished:
          playNextPodcast();
          break;
        default:
          break;
      }
    });
  }

  // Helper method to check if URL is video
  bool _isVideoUrl(String url) {
    final videoExtensions = ['.mp4', '.m4v', '.mov', '.avi', '.mkv', '.webm', '.m3u8'];
    return videoExtensions.any((ext) => url.toLowerCase().contains(ext)) ||
        url.contains('video') ||
        url.contains('.m3u8');
  }

  // Toggle like status
  Future<void> toggleLike() async {
    try {
      isLike.value = !isLike.value;
      // TODO: Call API to update like status
      // await apiClient.post(url: 'like_endpoint', body: {'podcastId': currentItem.value?.id});
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite() async {
    try {
      isFavorite.value = !isFavorite.value;
      // TODO: Call API to update favorite status
      // await apiClient.post(url: 'bookmark_endpoint', body: {'podcastId': currentItem.value?.id});
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Get formatted duration
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  // Get progress percentage
  double get progressPercentage {
    if (totalDuration.value.inMilliseconds <= 0) return 0.0;
    return currentPosition.value.inMilliseconds / totalDuration.value.inMilliseconds;
  }

  // Get buffered percentage
  double get bufferedPercentage {
    if (totalDuration.value.inMilliseconds <= 0) return 0.0;
    return bufferedPosition.value.inMilliseconds / totalDuration.value.inMilliseconds;
  }
}*/
