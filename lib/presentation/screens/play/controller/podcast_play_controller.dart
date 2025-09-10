import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:video_player/video_player.dart';

import '../model/comment_model.dart';

enum MediaType { audio, video }

class PodcastFeedController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  // Core data
  final RxList<PlayPodcastItem> items = RxList([]);
  final Rx<PlayPodcastItem?> currentItem = Rx<PlayPodcastItem?>(null);
  final RxInt currentIndex = 0.obs;

  // Media players
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rx<VideoPlayerController?> _videoPlayerController = Rx(null);

  // Playback state
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;
  final RxBool isAudioMode = true.obs;
  final RxBool isPlaying = false.obs;
  final Rx<Status> loadingStatus = Status.loading.obs;

  // User interactions
  final RxBool isLike = false.obs;
  final RxBool isFavorite = false.obs;
  final RxBool likeLoading = false.obs;
  final RxBool favoriteLoading = false.obs;
  final Rx<Status> isLoading = Status.loading.obs;

  // Error handling & retry
  final RxInt retryCount = 0.obs;
  final RxString lastError = ''.obs;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Internal state
  bool _isSwitchingMode = false;
  StreamSubscription? _audioPositionSubscription;
  StreamSubscription? _audioDurationSubscription;
  StreamSubscription? _audioBufferedSubscription;
  StreamSubscription? _audioStateSubscription;
  Timer? _videoPositionTimer;

  // Getters for safe access
  VideoPlayerController? get videoPlayerController => _videoPlayerController.value;
  AudioPlayer get audioPlayer => _audioPlayer;
  bool get hasItems => items.isNotEmpty;
  bool get hasCurrentItem => currentItem.value != null;
  bool get canPlayNext => currentIndex.value < items.length - 1;

  Future<void> getPodcast({bool? reels, bool? popular, String? firstPodcastId, bool isAlbum = false, bool isPlaylist = false, String? id}) async {
    try {
      isLoading.value = Status.loading;
      _clearError();

      final response = await _executeWithRetry(() async {
        return await apiClient.get(
          url: ApiUrl.playFeed(
            reels: reels,
            popular: popular,
            firstPodcastId: firstPodcastId,
            id: id,
            isAlbum: isAlbum,
            isPlaylist: isPlaylist,
          ),
          showResult: true,
        );
      }, 'getPodcast');

      if (response == null) {
        isLoading.value = Status.noDataFound;
        return;
      }

      if (response.statusCode == 200) {
        final feed = PlayFeedModel.fromJson(response.body);
        final newItems = feed.data?.podcasts ?? [];

        if (newItems.isEmpty) {
          isLoading.value = Status.noDataFound;
          return;
        }

        final shouldSkipPlay = _shouldSkipPlayback(newItems.first);

        items.assignAll(newItems);
        currentIndex.value = 0;

        isLoading.value = Status.completed;

        if (!shouldSkipPlay) {
          await playPodcast(index: 0);
        }
      }
    } catch (_) {
      isLoading.value = Status.error;
    }
  }

  bool _shouldSkipPlayback(PlayPodcastItem newItem) {
    if (currentItem.value == null) return false;

    final currentId = currentItem.value?.id;
    final newId = newItem.id;

    if (currentId == null || newId == null) return false;

    return currentId == newId && loadingStatus.value == Status.completed;
  }

  Future<void> playPodcast({required int index}) async {
    if (index < 0 || index >= items.length) {
      return;
    }

    await _playPodcastWithRetry(index, 0);
  }

  Future<void> _playPodcastWithRetry(int index, int attempt) async {
    if (attempt >= maxRetryAttempts) {
      debugPrint('❌ Max retry attempts reached for podcast at index $index');
      _setLoadingStatus(Status.error);
      return;
    }

    try {
      _setLoadingStatus(Status.loading);
      _clearError();

      final item = items[index];
      currentItem.value = item;
      currentIndex.value = index;

      _resetPlaybackState();

      isFavorite.value = item.isBookmark ?? false;
      isLike.value = item.isLike ?? false;

      await _disposePlayers();

      final mediaUrl = item.podcastUrl ?? "";
      if (mediaUrl.isEmpty) {
        _setLoadingStatus(Status.noDataFound);
        return;
      }

      final mediaType = _getMediaType(mediaUrl);
      final mediaItem = _createMediaItem(item);

      bool success = false;
      switch (mediaType) {
        case MediaType.audio:
          success = await _initializeAudioPlayer(mediaUrl, mediaItem, true);
          isAudioMode.value = true;
          break;

        case MediaType.video:
          try {
            final results = await Future.wait<bool>([
              _initializeAudioPlayer(mediaUrl, mediaItem, false),
              _initializeVideoPlayer(mediaUrl),
            ], eagerError: false);

            final audioSuccess = results[0];
            final videoSuccess = results[1];

            success = audioSuccess || videoSuccess;

            if (videoSuccess) {
              isAudioMode.value = false;
              await _audioPlayer.pause();
            } else if (audioSuccess) {
              isAudioMode.value = true;
              debugPrint('🎧 Video failed, falling back to audio mode');
            } else {
              debugPrint('❌ Neither audio nor video initialized successfully');
            }
          } catch (e, st) {
            debugPrint('💥 Error initializing audio/video: $e\n$st');
            success = false;
          }
          break;
      }


      if (success) {
        _setLoadingStatus(Status.completed);
        isPlaying.value = true;
        retryCount.value = 0;
        _trackView(item.id ?? "");

        debugPrint('▶️ Playing: ${item.title} (${isAudioMode.value ? 'Audio' : 'Video'} mode)');
      } else {
        throw Exception('Failed to initialize media player');
      }
    } catch (e, stackTrace) {
      _handleException('playPodcast', e, stackTrace);

      if (attempt < maxRetryAttempts - 1) {
        debugPrint('🔄 Retrying podcast playback (${attempt + 1}/$maxRetryAttempts)...');
        await Future.delayed(retryDelay);
        await _playPodcastWithRetry(index, attempt + 1);
      } else {
        if (canPlayNext) {
          debugPrint('⏭️ Current podcast failed, trying next one...');
          await Future.delayed(const Duration(milliseconds: 500));
          await _playPodcastWithRetry(index + 1, 0);
        } else {
          _setLoadingStatus(Status.error);
        }
      }
    }
  }

  Future<T?> _executeWithRetry<T>(
      Future<T> Function() operation,
      String operationName,
      [int maxAttempts = maxRetryAttempts]
      ) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await operation();
      } catch (e, stackTrace) {
        _handleException('$operationName (attempt ${attempt + 1})', e, stackTrace);

        if (attempt < maxAttempts - 1) {
          debugPrint('🔄 Retrying $operationName (${attempt + 1}/$maxAttempts)...');
          await Future.delayed(retryDelay);
        } else {
          _setError('Failed after $maxAttempts attempts: $e');
        }
      }
    }
    return null;
  }

  Future<void> togglePlayPause() async {
    if (loadingStatus.value == Status.loading || !hasCurrentItem) {
      return;
    }

    try {
      if (isAudioMode.value) {
        await _toggleAudioPlayback();
      } else {
        await _toggleVideoPlayback();
      }
    } catch (e, stackTrace) {
      _handleException('togglePlayPause', e, stackTrace);
      isPlaying.value = false;

      // Try to recover by reloading current item
      if (hasCurrentItem) {
        debugPrint('🔧 Attempting to recover playback...');
        await playPodcast(index: currentIndex.value);
      }
    }
  }

  Future<void> toggleMode() async {
    debugPrint("🔄 toggleMode() called");

    if (_isSwitchingMode) {
      debugPrint("⚠️ Already switching mode, skipping...");
      return;
    }
    if (!hasCurrentItem) {
      debugPrint("⚠️ No current item available, skipping...");
      return;
    }

    final currentUrl = currentItem.value?.podcastUrl ?? "";
    if (currentUrl.isEmpty) {
      debugPrint("⚠️ Podcast URL is empty, skipping...");
      return;
    }

    if (_getMediaType(currentUrl) != MediaType.video) {
      debugPrint('❌ Content is audio-only. Toggle not available.');
      return;
    }

    try {
      debugPrint("🚀 Starting mode switch...");
      _isSwitchingMode = true;

      if (isAudioMode.value) {
        debugPrint("🎧 Currently in Audio Mode → Switching to Video Mode...");
        await _switchToVideoMode();
      } else {
        debugPrint("🎬 Currently in Video Mode → Switching to Audio Mode...");
        await _switchToAudioMode();
      }
    } catch (e, stackTrace) {
      _handleException('toggleMode', e, stackTrace);
    } finally {
      _isSwitchingMode = false;
      debugPrint("✅ toggleMode() finished");
    }
  }

  Future<void> _switchToVideoMode() async {
    debugPrint("🎬 _switchToVideoMode() called");

    final wasPlaying = _audioPlayer.playing;
    final position = _audioPlayer.position;
    debugPrint("⏯️ Audio wasPlaying=$wasPlaying at position=$position");

    // Always pause audio when switching to video
    if (wasPlaying) {
      debugPrint("⏸️ Pausing audio before switching to video...");
      _audioPlayer.pause();
    }

    isAudioMode.value = false;
    debugPrint("📺 AudioMode=false → VideoMode=true");

    if (videoPlayerController != null) {
      debugPrint("🎥 Video controller available, seeking to $position...");
      await videoPlayerController!.seekTo(position);

      if (wasPlaying) {
        debugPrint("▶️ Resuming video playback from $position...");
        videoPlayerController!.play();
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
      }
    } else {
      debugPrint('❌ Video controller not initialized');
      isPlaying.value = false;
    }

    debugPrint("✅ _switchToVideoMode() finished");
  }

  Future<void> _switchToAudioMode() async {
    try {
      debugPrint("🎧 _switchToAudioMode() called");

      final controller = videoPlayerController;
      final wasPlaying = controller?.value.isPlaying ?? false;
      final position = controller?.value.position ?? Duration.zero;
      debugPrint("⏯️ Video wasPlaying=$wasPlaying at position=$position");

      // Always pause video when switching to audio
      if (wasPlaying && controller != null) {
        debugPrint("⏸️ Pausing video before switching to audio...");
        controller.pause();
      }

      isAudioMode.value = true;
      debugPrint("🎵 VideoMode=false → AudioMode=true");

      // Ensure audio player is ready and seek to current position
      debugPrint("📍 Seeking audio player to $position");
      await _audioPlayer.seek(position);

      if (wasPlaying) {
        debugPrint("▶️ Resuming audio playback from $position...");
        _audioPlayer.play();
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
      }

      debugPrint("✅ _switchToAudioMode() finished");
    } catch (e, stackTrace) {
      debugPrint("❌ Error in _switchToAudioMode: ${e.toString()}");
      _handleException('_switchToAudioMode', e, stackTrace);
    }
  }

  Duration _clampDuration(Duration position, Duration max) {
    if (position < Duration.zero) return Duration.zero;
    if (position > max) return max;
    return position;
  }

  Future<void> seek(Duration position) async {
    if (!hasCurrentItem) return;

    try {
      final clampedPosition = _clampDuration(position, totalDuration.value);

      if (isAudioMode.value) {
        await _audioPlayer.seek(clampedPosition);
      } else {
        await videoPlayerController?.seekTo(clampedPosition);
      }

      currentPosition.value = clampedPosition;
      debugPrint('⏯️ Seeked to: ${_formatDuration(clampedPosition)}');
    } catch (e, stackTrace) {
      _handleException('seek', e, stackTrace);
    }
  }

  Future<void> skipBackward({Duration duration = const Duration(seconds: 15)}) async {
    final newPosition = currentPosition.value - duration;
    final finalPosition = newPosition < Duration.zero ? Duration.zero : newPosition;
    await seek(finalPosition);
  }

  Future<void> skipForward({Duration duration = const Duration(seconds: 15)}) async {
    final newPosition = currentPosition.value + duration;
    final finalPosition = newPosition > totalDuration.value ? totalDuration.value : newPosition;
    await seek(finalPosition);
  }

  Future<void> playNext() async {
    if (!canPlayNext) {
      debugPrint('❌ No next podcast available');
      return;
    }
    await playPodcast(index: currentIndex.value + 1);
  }

  Future<bool> likePodcast({required String id, required bool currentState}) async {
    if (likeLoading.value) return currentState;

    try {
      likeLoading.value = true;

      final response = await _executeWithRetry(() async {
        return await apiClient.post(
          url: ApiUrl.like(id: id),
          body: {},
          showResult: true,
        );
      }, 'likePodcast');

      if (response != null && response.statusCode == 200) {
        final newState = response.body?['data']?['isLike'] ?? false;
        isLike.value = newState;
        return newState;
      } else {
        _handleApiError('likePodcast', response?.statusCode ?? 0);
        return currentState;
      }
    } catch (e, stackTrace) {
      _handleException('likePodcast', e, stackTrace);
      return currentState;
    } finally {
      likeLoading.value = false;
    }
  }

  Future<bool> favoritePodcast({required String id, required bool currentState}) async {
    if (favoriteLoading.value) return currentState;

    try {
      favoriteLoading.value = true;

      final response = await _executeWithRetry(() async {
        return await apiClient.post(
          url: ApiUrl.favoriteAdd(id: id),
          body: {},
        );
      }, 'favoritePodcast');

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final newState = !currentState;
        isFavorite.value = newState;
        try {
          final favoriteController = Get.find<FavoriteController>();
          favoriteController.pagingController.refresh();
        } catch (_) {
        }

        return newState;
      } else {
        _handleApiError('favoritePodcast', response?.statusCode ?? 0);
        return currentState;
      }
    } catch (e, stackTrace) {
      _handleException('favoritePodcast', e, stackTrace);
      return currentState;
    } finally {
      favoriteLoading.value = false;
    }
  }

  Future<void> getComments({
    required String id,
    required int page,
    required PagingController<int, CommentItem> commentsPagingController,
  }) async {
    try {
      final response = await _executeWithRetry(() async {
        return await apiClient.get(
          url: ApiUrl.comments(id: id, page: page),
          showResult: true,
        );
      }, 'getComments');

      if (response != null && response.statusCode == 200) {
        final comments = CommentModel.fromJson(response.body);
        final newItems = comments.data?.result ?? [];

        if (newItems.isNotEmpty) {
          commentsPagingController.appendPage(newItems, page + 1);
        } else {
          commentsPagingController.appendLastPage(newItems);
        }
      } else {
        commentsPagingController.error = "Failed to load comments";
      }
    } catch (e, stackTrace) {
      _handleException('getComments', e, stackTrace);
      commentsPagingController.error = "Error loading comments";
    }
  }

  Future<void> addComment({
    required String id,
    required TextEditingController commentController,
    required PagingController<int, CommentItem> commentsPagingController,
  }) async {
    if (commentController.text.trim().isEmpty) return;

    try {
      final response = await _executeWithRetry(() async {
        return await apiClient.post(
          url: ApiUrl.commentsAdd(),
          body: {
            "podcast": id,
            "text": commentController.text.trim(),
          },
          showResult: true,
        );
      }, 'addComment');

      if (response != null && response.statusCode == 200) {
        commentsPagingController.refresh();
        commentController.clear();
      } else {
        commentsPagingController.error = "Failed to add comment";
      }
    } catch (e, stackTrace) {
      _handleException('addComment', e, stackTrace);
      commentsPagingController.error = "Error adding comment";
    }
  }

  void _resetPlaybackState() {
    currentPosition.value = Duration.zero;
    totalDuration.value = Duration.zero;
    bufferedPosition.value = Duration.zero;
    isPlaying.value = false;
  }

  void _setLoadingStatus(Status status) {
    loadingStatus.value = status;
  }

  void _setError(String error) {
    lastError.value = error;
    debugPrint('❌ Error: $error');
  }

  void _clearError() {
    lastError.value = '';
    retryCount.value = 0;
  }

  MediaType getMediaType(String url) {
    return _getMediaType(url);
  }

  MediaType _getMediaType(String url) {
    final lowerUrl = url.toLowerCase();
    const videoExts = ['.mp4', '.mov', '.mkv', '.avi', '.webm', '.m4v', '.m3u8'];
    const audioExts = ['.mp3', '.aac', '.m4a', '.wav', '.ogg', '.flac'];

    for (final ext in videoExts) {
      if (lowerUrl.contains(ext)) return MediaType.video;
    }
    for (final ext in audioExts) {
      if (lowerUrl.contains(ext)) return MediaType.audio;
    }
    return MediaType.audio;
  }

  MediaItem _createMediaItem(PlayPodcastItem item) {
    return MediaItem(
      id: item.id ?? "",
      album: item.category?.name ?? "",
      title: item.title ?? "",
      artist: item.creator?.name ?? "",
      artUri: Uri.tryParse(item.coverImage ?? ""),
    );
  }

  Future<void> _disposePlayers() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}

    try {
      _videoPositionTimer?.cancel();
      await _videoPlayerController.value?.dispose();
    } catch (_) {}

    _videoPlayerController.value = null;
  }

  Future<bool> _initializeAudioPlayer(String url, MediaItem mediaItem, bool play) async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(url), tag: mediaItem),
        preload: true,
      );
      if(play){
        _audioPlayer.play();
      }
      return true;
    } catch (e, stackTrace) {
      _handleException('_initializeAudioPlayer', e, stackTrace);
      return false;
    }
  }

  Future<bool> _initializeVideoPlayer(String url) async {
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));

      await controller.initialize();

      _videoPlayerController.value = controller;
      _setupVideoPlayerListeners();

      controller.play();
      return true;
    } catch (e, stackTrace) {
      _handleException('_initializeVideoPlayer', e, stackTrace);
      return false;
    }
  }

  Future<void> _toggleAudioPlayback() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      isPlaying.value = false;
    } else {
      await _audioPlayer.play();
      isPlaying.value = true;
    }
  }

  Future<void> _toggleVideoPlayback() async {
    final controller = videoPlayerController;
    if (controller == null) {
      await _fallbackToAudio();
      return;
    }

    try {
      if (controller.value.isPlaying) {
        await controller.pause();
        isPlaying.value = false;
      } else {
        await controller.play();
        isPlaying.value = true;
      }
    } catch (e) {
      debugPrint('❌ Video playback failed, falling back to audio: $e');
      await _fallbackToAudio();
    }
  }

  Future<void> _fallbackToAudio() async {
    try {
      final item = currentItem.value;
      if (item?.podcastUrl == null) return;

      final mediaItem = _createMediaItem(item!);
      final success = await _initializeAudioPlayer(item.podcastUrl!, mediaItem, false);

      if (success) {
        isAudioMode.value = true;
        await _audioPlayer.play();
        isPlaying.value = true;
        debugPrint('🎧 Successfully switched to audio fallback');
      }
    } catch (e, stackTrace) {
      _handleException('_fallbackToAudio', e, stackTrace);
      isPlaying.value = false;
    }
  }

  void _setupAudioPlayerListeners() {
    _audioPositionSubscription?.cancel();
    _audioDurationSubscription?.cancel();
    _audioBufferedSubscription?.cancel();
    _audioStateSubscription?.cancel();

    _audioPositionSubscription = _audioPlayer.positionStream.listen((position) {
      if (isAudioMode.value) {
        currentPosition.value = position;
      }
    });

    _audioDurationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration.value = duration;
        debugPrint("🎵 Audio duration set: ${_formatDuration(duration)}");
      }
    });

    _audioBufferedSubscription = _audioPlayer.bufferedPositionStream.listen((buffered) {
      if (isAudioMode.value) {
        bufferedPosition.value = buffered;
      }
    });

    _audioStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (isAudioMode.value) {
        final isPlayerPlaying = state.playing;
        final processingState = state.processingState;

        isPlaying.value = isPlayerPlaying;

        if (processingState == ProcessingState.completed) {
          debugPrint("🎵 Audio playback completed, playing next...");
          playNext();
        }
      }
    });
  }

  void _setupVideoPlayerListeners() {
    final controller = videoPlayerController;
    if (controller == null) return;

    // Cancel existing timer
    _videoPositionTimer?.cancel();

    // Position and duration updates
    _videoPositionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!isAudioMode.value && controller.value.isInitialized) {
        currentPosition.value = controller.value.position;

        // Only update total duration if it's not already set or if it's different
        if (totalDuration.value != controller.value.duration) {
          totalDuration.value = controller.value.duration;
          debugPrint("📺 Video duration set: ${_formatDuration(controller.value.duration)}");
        }

        // Update buffered position
        final buffered = controller.value.buffered;
        if (buffered.isNotEmpty) {
          bufferedPosition.value = buffered.last.end;
        }

        // Check if video ended
        if (controller.value.position >= controller.value.duration &&
            controller.value.duration > Duration.zero) {
          debugPrint("📺 Video playback completed, playing next...");
          playNext();
        }
      }
    });

    // Listen to player state changes
    controller.addListener(() {
      if (!isAudioMode.value && controller.value.isInitialized) {
        isPlaying.value = controller.value.isPlaying;
      }
    });
  }

  Future<void> _trackView(String id) async {
    if (id.isEmpty) return;

    await _executeWithRetry(() async {
      final response = await apiClient.post(
        url: ApiUrl.videPodcast(id: id),
        body: {},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to track view: ${response.statusCode}');
      }

      return response;
    }, 'trackView');
  }

  void _handleException(String method, dynamic error, StackTrace stackTrace) {
    debugPrint('💥 $method Exception: $error');
    debugPrint('📍 Stack trace: $stackTrace');
    _setError('$method: $error');
  }

  void _handleApiError(String method, int statusCode) {
    debugPrint('❌ $method API Error: Status $statusCode');
    _setError('$method API Error: Status $statusCode');
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Future<void> retryCurrentPodcast() async {
    if (hasCurrentItem) {
      await playPodcast(index: currentIndex.value);
    }
  }

  Future<void> refreshPodcasts({
    bool? reels,
    bool? popular,
    String? firstPodcastId,
    bool isAlbum = false,
    bool isPlaylist = false,
    String? id
  }) async {
    await getPodcast(
      reels: reels,
      popular: popular,
      firstPodcastId: firstPodcastId,
      isAlbum: isAlbum,
      isPlaylist: isPlaylist,
      id: id,
    );
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 PodcastFeedController initialized');
    _setupAudioPlayerListeners();
  }

  @override
  void onClose() {
    _audioPositionSubscription?.cancel();
    _audioDurationSubscription?.cancel();
    _audioBufferedSubscription?.cancel();
    _audioStateSubscription?.cancel();
    _videoPositionTimer?.cancel();

    _audioPlayer.dispose();
    _videoPlayerController.value?.dispose();

    super.onClose();
    debugPrint('🔄 PodcastFeedController disposed');
  }
}