import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/service/rewarded_ad_service.dart';
import 'package:podcast/utils/app_const/app_const.dart';
// import 'package:video_player/video_player.dart'; // REMOVED: Video toggle feature

import '../model/comment_model.dart';

enum MediaType { audio, video }

class PodcastFeedController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  // Core data
  final RxList<PlayEntity> items = RxList([]);
  final Rx<PlayEntity?> currentItem = Rx<PlayEntity?>(null);

  final RxInt currentIndex = 0.obs;

  // Media players
  final AudioPlayer _audioPlayer = AudioPlayer();
  // final Rx<VideoPlayerController?> _videoPlayerController = Rx(null); // REMOVED: Video toggle feature
  ConcatenatingAudioSource? _playlist;

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

  // Store last used parameters for refresh
  bool? _lastReels;
  bool? _lastPopular;
  String? _lastFirstPodcastId;
  bool _lastIsAlbum = false;
  bool _lastIsPlaylist = false;
  String? _lastId;

  // Error handling & retry
  final RxInt retryCount = 0.obs;
  int _playCount = 0;
  final RxString lastError = ''.obs;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Internal state
  // bool _isSwitchingMode = false; // REMOVED: Video toggle feature
  StreamSubscription? _audioPositionSubscription;
  StreamSubscription? _audioDurationSubscription;
  StreamSubscription? _audioBufferedSubscription;
  StreamSubscription? _audioStateSubscription;
  // Timer? _videoPositionTimer; // REMOVED: Video toggle feature

  // Getters for safe access
  // VideoPlayerController? get videoPlayerController => _videoPlayerController.value; // REMOVED: Video toggle feature
  AudioPlayer get audioPlayer => _audioPlayer;
  bool get hasItems => items.isNotEmpty;
  bool get hasCurrentItem => currentItem.value != null;
  bool get canPlayNext => currentIndex.value < items.length - 1;

  void stopAudioIfPlaying() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    }
  }

  Future<void> getPodcast(
      {bool? reels,
      bool? popular,
      String? firstPodcastId,
      bool isAlbum = false,
      bool isPlaylist = false,
      String? id}) async {
    // Always stop and reinitialize audio, even if same podcast
    if (_audioPlayer.playing) {
      debugPrint('🛑 Stopping current audio before loading podcast');
      await _audioPlayer.stop();
      isPlaying.value = false;
    }

    // Force clear playlist so it rebuilds with new items
    _playlist = null;
    debugPrint('🗑️ Cleared existing playlist for fresh reload');

    _lastReels = reels;
    _lastPopular = popular;
    _lastFirstPodcastId = firstPodcastId;
    _lastIsAlbum = isAlbum;
    _lastIsPlaylist = isPlaylist;
    _lastId = id;

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

      print("object playPodcast 11");

      items.assignAll(
        newItems.map(PlayEntity.fromPodcast).whereType<PlayEntity>().toList(),
      );

      print("object playPodcast 1");

      isLoading.value = Status.completed;
      currentIndex.value = 0;

      print("object playPodcast 2");
      print("object playPodcast 3");
      await playPodcast(index: 0);
    }
  }

  Future<void> refreshPodcast(
      {bool? reels,
      bool? popular,
      String? firstPodcastId,
      bool isAlbum = false,
      bool isPlaylist = false,
      String? id}) async {
    // Don't show loading state - refresh silently
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
        showResult: false, // Don't show API result messages
      );
    }, 'refreshPodcast');

    if (response == null) {
      // Silently fail - don't update loading state
      return;
    }

    if (response.statusCode == 200) {
      final feed = PlayFeedModel.fromJson(response.body);
      final newItems = feed.data?.podcasts ?? [];

      if (newItems.isEmpty) {
        // Silently fail - don't update loading state
        return;
      }

      print("object refreshPodcast - updating items");

      // Convert new items to PlayEntity
      final newPlayEntities =
          newItems.map(PlayEntity.fromPodcast).whereType<PlayEntity>().toList();

      // Filter out duplicates based on ID to avoid adding same items
      // final existingIds = items.map((item) => item.id).toSet();
      // final uniqueNewItems = newPlayEntities.where((item) => !existingIds.contains(item.id)).toList();

      if (newPlayEntities.isNotEmpty) {
        // Add new unique items to the existing list
        items.addAll(newPlayEntities);
        print(
            "object refreshPodcast - added ${newPlayEntities.length} new items, total: ${items.length}");
      } else {
        print("object refreshPodcast - no new unique items to add");
      }
      // if (uniqueNewItems.isNotEmpty) {
      //   // Add new unique items to the existing list
      //   items.addAll(uniqueNewItems);
      //   print("object refreshPodcast - added ${uniqueNewItems.length} new items, total: ${items.length}");
      // } else {
      //   print("object refreshPodcast - no new unique items to add");
      // }

      // Don't auto-play on refresh - just update the data
      // Keep current playing state as is
    }
  }

  Future<void> playPodcast({required int index}) async {
    if (index < 0 || index >= items.length) {
      return;
    }

    print("object playPodcast");

    // Always stop and reinitialize, even if same podcast
    if (_audioPlayer.playing) {
      debugPrint(
          '🛑 Stopping current audio before playing podcast at index $index');
      await _audioPlayer.pause();
      isPlaying.value = false;
    }

    // Check if we need to refresh before playing
    await _checkAndRefreshIfNeeded();

    await _playPodcastWithRetry(index, 0);
  }

  Future<void> pauseForAd() async {
    if (!hasCurrentItem) return;

    try {
      debugPrint("🎯 Pausing playback for ad");

      // Always use audio player since video toggle is removed
      if (_audioPlayer.playing) {
        _audioPlayer.pause();
        debugPrint("⏸️ Audio paused for ad");
      }

      // REMOVED: Video pause for ads
      // if (isAudioMode.value) {
      //   if (_audioPlayer.playing) {
      //    _audioPlayer.pause();
      //     debugPrint("⏸️ Audio paused for ad");
      //   }
      // } else {
      //   final controller = videoPlayerController;
      //   if (controller != null && controller.value.isPlaying) {
      //    controller.pause();
      //     debugPrint("⏸️ Video paused for ad");
      //   }
      // }
    } catch (e, stackTrace) {
      _handleException('pauseForAd', e, stackTrace);
    }
  }

  /// Resume playback after ads
  Future<void> resumeAfterAd() async {
    if (!hasCurrentItem || loadingStatus.value != Status.completed) {
      debugPrint("⚠️ Cannot resume - no current item or not loaded");
      return;
    }

    try {
      debugPrint("🎯 Resuming playback after ad");

      // Always use audio player since video toggle is removed
      if (_audioPlayer.processingState != ProcessingState.idle) {
        _audioPlayer.play();
        isPlaying.value = true;
        debugPrint("▶️ Audio resumed after ad");
      } else {
        // Audio player lost state, reinitialize
        debugPrint("🔄 Audio player lost state, reinitializing...");
        await _reinitializeCurrentMedia();
      }

      // REMOVED: Video resume after ads
      // if (isAudioMode.value) {
      //   // Ensure audio player is in a valid state
      //   if (_audioPlayer.processingState != ProcessingState.idle) {
      //    _audioPlayer.play();
      //     isPlaying.value = true;
      //     debugPrint("▶️ Audio resumed after ad");
      //   } else {
      //     // Audio player lost state, reinitialize
      //     debugPrint("🔄 Audio player lost state, reinitializing...");
      //     await _reinitializeCurrentMedia();
      //   }
      // } else {
      //   final controller = videoPlayerController;
      //   if (controller != null && controller.value.isInitialized) {
      //    controller.play();
      //     isPlaying.value = true;
      //     debugPrint("▶️ Video resumed after ad");
      //   } else {
      //     // Video player lost state, reinitialize
      //     debugPrint("🔄 Video player lost state, reinitializing...");
      //     await _reinitializeCurrentMedia();
      //   }
      // }
    } catch (e, stackTrace) {
      _handleException('resumeAfterAd', e, stackTrace);
      // If resume fails, try to reinitialize
      await _reinitializeCurrentMedia();
    }
  }

  /// Reinitialize current media if state is lost
  Future<void> _reinitializeCurrentMedia() async {
    final currentIdx = currentIndex.value;
    if (currentIdx >= 0 && currentIdx < items.length) {
      debugPrint("🔧 Reinitializing media at index $currentIdx");
      await playPodcast(index: currentIdx);
    }
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

      // Always rebuild playlist to ensure fresh state
      try {
        await _buildPlaylist();
      } catch (e) {
        debugPrint('❌ Playlist build error caught: $e');
        _setLoadingStatus(Status.error);
        return;
      }

      // Double-check playlist was created
      if (_playlist == null) {
        debugPrint('❌ Playlist is null after build');
        _setLoadingStatus(Status.error);
        return;
      }

      final mediaUrl = item.podcastUrl;
      if (mediaUrl.isEmpty) {
        _setLoadingStatus(Status.noDataFound);
        return;
      }

      final mediaType = _getMediaType(mediaUrl);
      final mediaItem = _createMediaItem(item);

      bool success = false;
      debugPrint('🎵 Media type detected: $mediaType (playing as audio only)');

      // Always initialize as audio only (video toggle feature removed)
      success = await _initializeAudioPlayer(mediaUrl, mediaItem, true);
      debugPrint('🎵 Audio initialization result: $success');
      isAudioMode.value = true;

      // REMOVED: Video initialization - now audio only
      /*
      switch (mediaType) {
        case MediaType.audio:
          success = await _initializeAudioPlayer(mediaUrl, mediaItem, true);
          debugPrint('🎵 Audio initialization result: $success');
          isAudioMode.value = true;
          break;

        case MediaType.video:
          try {
            debugPrint('🎬 Starting parallel audio/video initialization...');
            // Initialize audio (to play) and video (no auto-play) in parallel
            final results = await Future.wait<bool>([
              _initializeAudioPlayer(mediaUrl, mediaItem, true),
              _initializeVideoPlayer(mediaUrl),
            ], eagerError: false).timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                debugPrint('⏱️ Initialization timeout! Falling back to audio only');
                return [true, false]; // Audio succeeded, video timed out
              },
            );

            debugPrint('🎬 Parallel initialization completed');
            final audioSuccess = results[0];
            final videoSuccess = results[1];
            debugPrint('🎵 Audio init result: $audioSuccess, Video init result: $videoSuccess');

            success = audioSuccess || videoSuccess;
            debugPrint('🎯 Combined success: $success');

            if (audioSuccess) {
              // Start in audio mode first, even if video is available
              isAudioMode.value = true;
              debugPrint('🎧 Starting video content in audio-first mode');
            } else if (videoSuccess) {
              // Audio failed; fall back to video mode
              isAudioMode.value = false;
              debugPrint('🎬 Audio failed, starting in video mode');
            } else {
              debugPrint('❌ Neither audio nor video initialized successfully');
            }
          } catch (e, st) {
            debugPrint('💥 Error initializing audio/video: $e\n$st');
            success = false;
          }
          break;
      }
      */

      debugPrint('🔍 Checking success flag: $success');
      if (success) {
        debugPrint(
            '✅ Media initialized successfully, setting status to completed');
        _setLoadingStatus(Status.completed);
        isPlaying.value = true;
        retryCount.value = 0;
        _trackView(item.id);

        _playCount++;
        if (_playCount % 3 == 0) {
          final subscriptionController = Get.find<SubscriptionController>();
          if (!subscriptionController.hasActiveSubscription) {
            await RewardedAdService().showAd(
              onEarnedReward: () {
                debugPrint("🎉 User earned reward from podcast playback");
              },
            );
          }
        }
        debugPrint(
            '▶️ Playing: ${item.title} (${isAudioMode.value ? 'Audio' : 'Video'} mode)');
      } else {
        debugPrint('❌ Success is false, throwing exception');
        throw Exception('Failed to initialize media player');
      }
    } catch (e, stackTrace) {
      _handleException('playPodcast', e, stackTrace);

      if (attempt < maxRetryAttempts - 1) {
        debugPrint(
            '🔄 Retrying podcast playback (${attempt + 1}/$maxRetryAttempts)...');
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
      Future<T> Function() operation, String operationName,
      [int maxAttempts = maxRetryAttempts]) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await operation();
      } catch (e, stackTrace) {
        _handleException(
            '$operationName (attempt ${attempt + 1})', e, stackTrace);

        if (attempt < maxAttempts - 1) {
          debugPrint(
              '🔄 Retrying $operationName (${attempt + 1}/$maxAttempts)...');
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
      // Always use audio playback since video toggle is removed
      await _toggleAudioPlayback();

      // REMOVED: Video playback toggle
      // if (isAudioMode.value) {
      //   await _toggleAudioPlayback();
      // } else {
      //   await _toggleVideoPlayback();
      // }
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

  // REMOVED: Video toggle feature
  /*
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
  */

  // REMOVED: Video toggle feature
  /*
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

    // Check if video controller exists and is for the current item
    if (videoPlayerController == null) {
      debugPrint('⚠️ Video controller not initialized, initializing now...');
      
      final currentUrl = currentItem.value?.podcastUrl ?? "";
      if (currentUrl.isNotEmpty) {
        final success = await _initializeVideoPlayer(currentUrl);
        
        if (!success) {
          debugPrint('❌ Failed to initialize video controller');
          isPlaying.value = false;
          // Fall back to audio mode
          isAudioMode.value = true;
          if (wasPlaying) {
            _audioPlayer.play();
          }
          return;
        }
      } else {
        debugPrint('❌ No URL available for video');
        isPlaying.value = false;
        isAudioMode.value = true;
        if (wasPlaying) {
          _audioPlayer.play();
        }
        return;
      }
    }

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
  */

  Duration _clampDuration(Duration position, Duration max) {
    if (position < Duration.zero) return Duration.zero;
    if (position > max) return max;
    return position;
  }

  Future<void> seek(Duration position) async {
    if (!hasCurrentItem) return;

    try {
      final clampedPosition = _clampDuration(position, totalDuration.value);

      // Always use audio player since video toggle is removed
      await _audioPlayer.seek(clampedPosition);
      // if (isAudioMode.value) {
      //   await _audioPlayer.seek(clampedPosition);
      // } else {
      //   await videoPlayerController?.seekTo(clampedPosition); // REMOVED: Video toggle feature
      // }

      currentPosition.value = clampedPosition;
      debugPrint('⏯️ Seeked to: ${_formatDuration(clampedPosition)}');
    } catch (e, stackTrace) {
      _handleException('seek', e, stackTrace);
    }
  }

  Future<void> skipBackward(
      {Duration duration = const Duration(seconds: 15)}) async {
    final newPosition = currentPosition.value - duration;
    final finalPosition =
        newPosition < Duration.zero ? Duration.zero : newPosition;
    await seek(finalPosition);
  }

  Future<void> skipForward(
      {Duration duration = const Duration(seconds: 15)}) async {
    final newPosition = currentPosition.value + duration;
    final finalPosition =
        newPosition > totalDuration.value ? totalDuration.value : newPosition;
    await seek(finalPosition);
  }

  // Check if we need to refresh podcast list when running low on content
  Future<void> _checkAndRefreshIfNeeded() async {
    final remainingItems = items.length - currentIndex.value - 1;

    // If empty or less than 3 items remaining, refresh the podcast list
    if (items.isEmpty || remainingItems < 3) {
      debugPrint(
          '🔄 Low on content (remaining: $remainingItems, total: ${items.length}, currentIndex: ${currentIndex.value}), refreshing podcast list...');

      // Call refreshPodcast with the same parameters used in the last getPodcast call
      await refreshPodcast(
        reels: _lastReels,
        popular: _lastPopular,
        firstPodcastId: _lastFirstPodcastId,
        isAlbum: _lastIsAlbum,
        isPlaylist: _lastIsPlaylist,
        id: _lastId,
      );

      debugPrint('✅ Podcast list refreshed successfully');
    }
  }

  Future<void> playNext() async {
    // Check if we need to refresh podcast list first (even if no next available)
    await _checkAndRefreshIfNeeded();

    if (!canPlayNext) {
      debugPrint('❌ No next podcast available');
      return;
    }

    // If using playlist, just seek to next index
    if (_playlist != null && isAudioMode.value) {
      final nextIndex = currentIndex.value + 1;
      if (nextIndex < _playlist!.children.length && nextIndex < items.length) {
        // CRITICAL FIX: Update UI state BEFORE seeking to prevent mismatch
        currentIndex.value = nextIndex;
        currentItem.value = items[nextIndex];
        isFavorite.value = items[nextIndex].isBookmark ?? false;
        isLike.value = items[nextIndex].isLike ?? false;

        await _audioPlayer.seekToNext();
        _trackView(items[nextIndex].id);
        debugPrint(
            '⏭️ Playlist: Moved to next track (index: $nextIndex) - ${items[nextIndex].title}');
        return;
      }
    }

    await playPodcast(index: currentIndex.value + 1);
  }

  Future<void> playPrevious() async {
    if (currentIndex.value <= 0) {
      debugPrint('❌ No previous podcast available');
      return;
    }

    // If using playlist, just seek to previous index
    if (_playlist != null && isAudioMode.value) {
      final prevIndex = currentIndex.value - 1;
      if (prevIndex >= 0 && prevIndex < items.length) {
        // CRITICAL FIX: Update UI state BEFORE seeking to prevent mismatch
        currentIndex.value = prevIndex;
        currentItem.value = items[prevIndex];
        isFavorite.value = items[prevIndex].isBookmark ?? false;
        isLike.value = items[prevIndex].isLike ?? false;

        await _audioPlayer.seekToPrevious();
        _trackView(items[prevIndex].id);
        debugPrint(
            '⏮️ Playlist: Moved to previous track (index: $prevIndex) - ${items[prevIndex].title}');
        return;
      }
    }

    await playPodcast(index: currentIndex.value - 1);
  }

  Future<bool> likePodcast(
      {required String id, required bool currentState}) async {
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

  Future<bool> favoritePodcast(
      {required String id, required bool currentState}) async {
    if (favoriteLoading.value) return currentState;

    try {
      favoriteLoading.value = true;

      final response = await _executeWithRetry(() async {
        return await apiClient.post(
          url: ApiUrl.favoriteAdd(id: id),
          body: {},
        );
      }, 'favoritePodcast');

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final newState = !currentState;
        isFavorite.value = newState;
        try {
          final favoriteController = Get.find<FavoriteController>();
          favoriteController.pagingController.refresh();
        } catch (_) {}

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
    debugPrint('📊 Loading status changed: ${loadingStatus.value} → $status');
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
    const videoExts = [
      '.mp4',
      '.mov',
      '.mkv',
      '.avi',
      '.webm',
      '.m4v',
      '.m3u8'
    ];
    const audioExts = ['.mp3', '.aac', '.m4a', '.wav', '.ogg', '.flac'];

    for (final ext in videoExts) {
      if (lowerUrl.contains(ext)) return MediaType.video;
    }
    for (final ext in audioExts) {
      if (lowerUrl.contains(ext)) return MediaType.audio;
    }
    return MediaType.audio;
  }

  MediaItem _createMediaItem(PlayEntity item) {
    return MediaItem(
      id: item.id ?? "",
      album: item.categoryName ?? "Podcast",
      title: item.title ?? "Unknown Title",
      artist: item.creatorName ?? "Unknown Artist",
      artUri: Uri.tryParse(item.coverImage ?? ""),
      duration: null,
      extras: {
        'url': item.podcastUrl,
      },
    );
  }

  Future<void> _disposePlayers() async {
    // REMOVED: Video player disposal - now audio only
    // Only dispose video player, keep audio player and playlist intact
    // try {
    //   _videoPositionTimer?.cancel();
    //   await _videoPlayerController.value?.dispose();
    // } catch (_) {}

    // _videoPlayerController.value = null;
    // Don't clear playlist - it should persist across track changes

    // CRITICAL FIX: Stop audio player if playing to prevent multiple songs playing
    try {
      if (_audioPlayer.playing) {
        debugPrint('🛑 Stopping audio player in _disposePlayers');
        await _audioPlayer.pause();
      }
    } catch (e) {
      debugPrint('⚠️ Error stopping audio in _disposePlayers: $e');
    }

    debugPrint('🔄 _disposePlayers called (video features removed)');
  }

  Future<void> _buildPlaylist() async {
    try {
      debugPrint('🔨 Building playlist with ${items.length} items...');
      final audioSources = <AudioSource>[];

      for (final item in items) {
        final mediaItem = _createMediaItem(item);
        final url = item.podcastUrl;
        if (url.isNotEmpty) {
          audioSources.add(
            AudioSource.uri(
              Uri.parse(url),
              tag: mediaItem,
            ),
          );
        }
      }

      if (audioSources.isEmpty) {
        debugPrint('⚠️ No audio sources to build playlist');
        _playlist = null;
        return;
      }

      _playlist = ConcatenatingAudioSource(children: audioSources);

      // Set audio source without auto-playing
      await _audioPlayer.setAudioSource(_playlist!,
          initialIndex: 0, preload: true);
      debugPrint(
          '✅ Playlist built successfully with ${audioSources.length} tracks');
    } catch (e, stackTrace) {
      debugPrint('💥 _buildPlaylist failed: $e');
      _handleException('_buildPlaylist', e, stackTrace);
      _playlist = null;
      rethrow; // Re-throw to let caller handle it
    }
  }

  Future<bool> _initializeAudioPlayer(
      String url, MediaItem mediaItem, bool play) async {
    try {
      debugPrint('🎵 _initializeAudioPlayer started (play=$play)');
      // If playlist exists, seek to the correct index instead of setting source
      if (_playlist != null &&
          currentIndex.value < _playlist!.children.length) {
        debugPrint(
            '🎵 Using playlist - seeking to index ${currentIndex.value}');

        // CRITICAL FIX: Ensure currentItem is synced BEFORE seeking
        if (currentIndex.value < items.length) {
          currentItem.value = items[currentIndex.value];
          debugPrint(
              '🎵 Synced currentItem to index ${currentIndex.value}: ${currentItem.value?.title}');
        }

        await _audioPlayer.seek(Duration.zero, index: currentIndex.value);
        debugPrint('🎵 Seek completed');
        if (play) {
          debugPrint('🎵 Starting playback...');
          _audioPlayer.play();
          debugPrint('🎵 Playback started');
        }
        debugPrint('✅ _initializeAudioPlayer returning true (playlist mode)');
        return true;
      } else {
        // Fallback: single track mode (shouldn't happen with playlist)
        debugPrint('⚠️ Playlist not available, using single track mode');
        await _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(url), tag: mediaItem),
          preload: true,
        );
        if (play) {
          _audioPlayer.play();
        }
        debugPrint(
            '✅ _initializeAudioPlayer returning true (single track mode)');
        return true;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ _initializeAudioPlayer exception: $e');
      _handleException('_initializeAudioPlayer', e, stackTrace);
      return false;
    }
  }

  // REMOVED: Video toggle feature
  /*
  Future<bool> _initializeVideoPlayer(String url) async {
    try {
      debugPrint('📺 _initializeVideoPlayer started');
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));

      debugPrint('📺 Initializing video controller...');
      await controller.initialize();
      debugPrint('📺 Video controller initialized');

      _videoPlayerController.value = controller;
      _setupVideoPlayerListeners();
      debugPrint('✅ _initializeVideoPlayer returning true');
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ _initializeVideoPlayer exception: $e');
      _handleException('_initializeVideoPlayer', e, stackTrace);
      return false;
    }
  }
  */

  Future<void> _toggleAudioPlayback() async {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      isPlaying.value = false;
    } else {
      _audioPlayer.play();
      isPlaying.value = true;
    }
  }

  // REMOVED: Video toggle feature
  /*
  Future<void> _toggleVideoPlayback() async {
    final controller = videoPlayerController;
    if (controller == null) {
      await _fallbackToAudio();
      return;
    }

    try {
      if (controller.value.isPlaying) {
       controller.pause();
        isPlaying.value = false;
      } else {
        controller.play();
        isPlaying.value = true;
      }
    } catch (e) {
      debugPrint('❌ Video playback failed, falling back to audio: $e');
      await _fallbackToAudio();
    }
  }
  */

  // REMOVED: Video toggle feature - fallback no longer needed
  /*
  Future<void> _fallbackToAudio() async {
    try {
      final item = currentItem.value;
      if (item?.podcastUrl == null) return;

      final mediaItem = _createMediaItem(item!);
      final success = await _initializeAudioPlayer(item.podcastUrl, mediaItem, false);

      if (success) {
        isAudioMode.value = true;
        _audioPlayer.play();
        isPlaying.value = true;
        debugPrint('🎧 Successfully switched to audio fallback');
      }
    } catch (e, stackTrace) {
      _handleException('_fallbackToAudio', e, stackTrace);
      isPlaying.value = false;
    }
  }
  */

  void _setupAudioPlayerListeners() {
    _audioPositionSubscription?.cancel();
    _audioDurationSubscription?.cancel();
    _audioBufferedSubscription?.cancel();
    _audioStateSubscription?.cancel();

    _audioPositionSubscription = _audioPlayer.positionStream.listen((position) {
      // Always update position since we're audio-only now
      currentPosition.value = position;
      // if (isAudioMode.value) {
      //   currentPosition.value = position;
      // }
    });

    _audioDurationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration.value = duration;
        debugPrint("🎵 Audio duration set: ${_formatDuration(duration)}");
      }
    });

    _audioBufferedSubscription =
        _audioPlayer.bufferedPositionStream.listen((buffered) {
      // Always update buffered position since we're audio-only now
      bufferedPosition.value = buffered;
      // if (isAudioMode.value) {
      //   bufferedPosition.value = buffered;
      // }
    });

    _audioStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (isAudioMode.value) {
        final isPlayerPlaying = state.playing;
        final processingState = state.processingState;

        isPlaying.value = isPlayerPlaying;

        if (processingState == ProcessingState.completed) {
          debugPrint("🎵 Audio playback completed, playing next...");
          // Playlist will auto-advance, just update UI
          if (_playlist == null || currentIndex.value >= items.length - 1) {
            playNext();
          }
        }
      }
    });

    // Listen to current index changes from playlist
    _audioPlayer.currentIndexStream.listen((index) async {
      if (index != null && index < items.length) {
        // CRITICAL FIX: Always sync UI with playlist index, even if it matches currentIndex
        // This ensures UI stays in sync when manually seeking in playlist
        final indexChanged = index != currentIndex.value;

        if (indexChanged) {
          debugPrint('🎵 Playlist auto-advanced to index: $index');
        } else {
          debugPrint('🎵 Playlist index confirmed: $index');
        }

        currentIndex.value = index;
        currentItem.value = items[index];
        isFavorite.value = items[index].isBookmark ?? false;
        isLike.value = items[index].isLike ?? false;

        // Only track view if index actually changed (to avoid duplicate tracking)
        if (indexChanged) {
          _trackView(items[index].id);
        }

        // Check if we need to refresh when playlist auto-advances
        await _checkAndRefreshIfNeeded();
      }
    });
  }

  // REMOVED: Video toggle feature
  /*
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
  */

  Future<void> _trackView(String id) async {
    if (id.isEmpty) return;

    await _executeWithRetry(() async {
      final response = await apiClient.post(
        url: ApiUrl.viewPodcast(id: id),
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

  Future<void> refreshPodcasts(
      {bool? reels,
      bool? popular,
      String? firstPodcastId,
      bool isAlbum = false,
      bool isPlaylist = false,
      String? id}) async {
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

  /// Stop audio when app is closed/terminated
  void stopAudioOnAppClose() {
    try {
      debugPrint('🛑 Stopping audio playback - App is closing');
      _audioPlayer.stop();
      // _videoPlayerController.value?.pause(); // REMOVED: Video toggle feature
      isPlaying.value = false;
    } catch (e) {
      debugPrint('⚠️ Error stopping audio on app close: $e');
    }
  }

  @override
  void onClose() {
    _audioPositionSubscription?.cancel();
    _audioDurationSubscription?.cancel();
    _audioBufferedSubscription?.cancel();
    _audioStateSubscription?.cancel();
    // _videoPositionTimer?.cancel(); // REMOVED: Video toggle feature

    _audioPlayer.dispose();
    // _videoPlayerController.value?.dispose(); // REMOVED: Video toggle feature
    _playlist = null;

    super.onClose();
    debugPrint('🔄 PodcastFeedController disposed');
  }
}
