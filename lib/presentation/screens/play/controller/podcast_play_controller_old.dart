// import 'dart:async';
// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:podcast/core/dependency/path.dart';
// import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
// import 'package:podcast/presentation/screens/play/model/play_entity.dart';
// import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
// import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
// import 'package:podcast/service/api_service.dart';
// import 'package:podcast/service/api_url.dart';
// import 'package:podcast/service/rewarded_ad_service.dart';
// import 'package:podcast/utils/app_const/app_const.dart';

// import '../model/comment_model.dart';

// enum MediaType { audio, video}

// class PodcastFeedController extends GetxController {
//   final ApiClient apiClient = serviceLocator<ApiClient>();

//   // Core data
//   final Rx<PlayEntity?> currentItem = Rx<PlayEntity?>(null);

//   final RxInt currentIndex = 0.obs;

//   // Media players
//   final AudioPlayer _audioPlayer;
//   ConcatenatingAudioSource? _playlist;

//   // Playback state
//   final Rx<Duration> currentPosition = Duration.zero.obs;
//   final Rx<Duration> totalDuration = Duration.zero.obs;
//   final Rx<Duration> bufferedPosition = Duration.zero.obs;
//   final RxBool isPlaying = false.obs;
//   final Rx<Status> loadingStatus = Status.loading.obs;

//   // User interactions
//   final RxBool isLike = false.obs;
//   final RxBool isFavorite = false.obs;
//   final RxBool likeLoading = false.obs;
//   final RxBool favoriteLoading = false.obs;
//   final Rx<Status> isLoading = Status.loading.obs;

//   // Error handling & retry
//   final RxInt retryCount = 0.obs;
//   int _playCount = 0;
//   final RxString lastError = ''.obs;
//   static const int maxRetryAttempts = 3;
//   static const Duration retryDelay = Duration(seconds: 2);

//   // Internal state
//   StreamSubscription? _audioPositionSubscription;
//   StreamSubscription? _audioDurationSubscription;
//   StreamSubscription? _audioBufferedSubscription;
//   StreamSubscription? _audioStateSubscription;

//   // Getters for safe access
//   AudioPlayer get audioPlayer => _audioPlayer;
//   bool get hasItems => items.isNotEmpty;
//   bool get hasCurrentItem => currentItem.value != null;
//   bool get canPlayNext => currentIndex.value < items.length - 1;

//   void stopAudioIfPlaying() {
//     if (audioPlayer.playing) {
//       audioPlayer.pause();
//     }
//   }

//   Future<void> getPodcast({bool? reels, bool? popular, String? firstPodcastId, bool isAlbum = false, bool isPlaylist = false, String? id}) async {
//     isLoading.value = Status.loading;
//     _clearError();

//     final response = await _executeWithRetry(() async {
//       return await apiClient.get(
//         url: ApiUrl.playFeed(
//           reels: reels,
//           popular: popular,
//           firstPodcastId: firstPodcastId,
//           id: id,
//           isAlbum: isAlbum,
//           isPlaylist: isPlaylist,
//         ),
//         showResult: true,
//       );
//     }, 'getPodcast');

//     if (response == null) {
//       isLoading.value = Status.noDataFound;
//       return;
//     }

//     if (response.statusCode == 200) {
//       final feed = PlayFeedModel.fromJson(response.body);
//       final newItems = feed.data?.podcasts ?? [];

//       if (newItems.isEmpty) {
//         isLoading.value = Status.noDataFound;
//         return;
//       }

//       print("object playPodcast 11");

//       items.assignAll(
//         newItems.map(PlayEntity.fromPodcast).whereType<PlayEntity>().toList(),
//       );

//       print("object playPodcast 1");

//       final shouldSkipPlay = _shouldSkipPlayback(items.first);
//       isLoading.value = Status.completed;
//       currentIndex.value = 0;

//       print("object playPodcast 2");

//       if (!shouldSkipPlay) {
//         print("object playPodcast 3");
//         await playPodcast(index: 0);
//       }
//     }
//   }


//   bool _shouldSkipPlayback(PlayEntity newItem) {
//     if (currentItem.value == null) return false;

//     final currentId = currentItem.value?.id;
//     final newId = newItem.id;

//     if (currentId == null) return false;

//     return currentId == newId && loadingStatus.value == Status.completed;
//   }

//   Future<void> playPodcast({required int index}) async {
//     if (index < 0 || index >= items.length) {
//       return;
//     }

//     print("object playPodcast");

//     await _playPodcastWithRetry(index, 0);
//   }

//   Future<void> pauseForAd() async {
//     if (!hasCurrentItem) return;

//     try {
//       debugPrint("🎯 Pausing playback for ad");

//       if (isAudioMode.value) {
//         if (_audioPlayer.playing) {
//          _audioPlayer.pause();
//           debugPrint("⏸️ Audio paused for ad");
//         }
//       } else {
//         final controller = videoPlayerController;
//         if (controller != null && controller.value.isPlaying) {
//          controller.pause();
//           debugPrint("⏸️ Video paused for ad");
//         }
//       }
//     } catch (e, stackTrace) {
//       _handleException('pauseForAd', e, stackTrace);
//     }
//   }

//   /// Resume playback after ads
//   Future<void> resumeAfterAd() async {
//     if (!hasCurrentItem || loadingStatus.value != Status.completed) {
//       debugPrint("⚠️ Cannot resume - no current item or not loaded");
//       return;
//     }

//     try {
//       debugPrint("🎯 Resuming playback after ad");

//       if (isAudioMode.value) {
//         // Ensure audio player is in a valid state
//         if (_audioPlayer.processingState != ProcessingState.idle) {
//          _audioPlayer.play();
//           isPlaying.value = true;
//           debugPrint("▶️ Audio resumed after ad");
//         } else {
//           // Audio player lost state, reinitialize
//           debugPrint("🔄 Audio player lost state, reinitializing...");
//           await _reinitializeCurrentMedia();
//         }
//       } else {
//         final controller = videoPlayerController;
//         if (controller != null && controller.value.isInitialized) {
//          controller.play();
//           isPlaying.value = true;
//           debugPrint("▶️ Video resumed after ad");
//         } else {
//           // Video player lost state, reinitialize
//           debugPrint("🔄 Video player lost state, reinitializing...");
//           await _reinitializeCurrentMedia();
//         }
//       }
//     } catch (e, stackTrace) {
//       _handleException('resumeAfterAd', e, stackTrace);
//       // If resume fails, try to reinitialize
//       await _reinitializeCurrentMedia();
//     }
//   }

//   /// Reinitialize current media if state is lost
//   Future<void> _reinitializeCurrentMedia() async {
//     final currentIdx = currentIndex.value;
//     if (currentIdx >= 0 && currentIdx < items.length) {
//       debugPrint("🔧 Reinitializing media at index $currentIdx");
//       await playPodcast(index: currentIdx);
//     }
//   }


//   Future<void> _playPodcastWithRetry(int index, int attempt) async {
//     if (attempt >= maxRetryAttempts) {
//       debugPrint('❌ Max retry attempts reached for podcast at index $index');
//       _setLoadingStatus(Status.error);
//       return;
//     }

//     try {
//       _setLoadingStatus(Status.loading);
//       _clearError();

//       final item = items[index];
//       currentItem.value = item;
//       currentIndex.value = index;

//       _resetPlaybackState();

//       isFavorite.value = item.isBookmark ?? false;
//       isLike.value = item.isLike ?? false;

//       await _disposePlayers();

//       // Build playlist if not already built or if items changed
//       if (_playlist == null || _playlist!.children.length != items.length) {
//         try {
//           await _buildPlaylist();
//         } catch (e) {
//           debugPrint('❌ Playlist build error caught: $e');
//           _setLoadingStatus(Status.error);
//           return;
//         }
        
//         // Double-check playlist was created
//         if (_playlist == null) {
//           debugPrint('❌ Playlist is null after build');
//           _setLoadingStatus(Status.error);
//           return;
//         }
//       }

//       final mediaUrl = item.podcastUrl;
//       if (mediaUrl.isEmpty) {
//         _setLoadingStatus(Status.noDataFound);
//         return;
//       }

//       final mediaItem = _createMediaItem(item);

//       // Always initialize as audio-first (simplified approach)
//       debugPrint('🎵 Initializing as audio-first mode');
//       final success = await _initializeAudioPlayer(mediaUrl, mediaItem, true);
//       debugPrint('🎵 Audio initialization result: $success');
      
//       // Always start in audio mode - video will be loaded on-demand when toggle is clicked
//       isAudioMode.value = true;

//       debugPrint('🔍 Checking success flag: $success');
//       if (success) {
//         debugPrint('✅ Media initialized successfully, setting status to completed');
//         _setLoadingStatus(Status.completed);
//         isPlaying.value = true;
//         retryCount.value = 0;
//         _trackView(item.id);

//         _playCount++;
//         if (_playCount % 3 == 0) {
//           final subscriptionController = Get.find<SubscriptionController>();
//           if (!subscriptionController.hasActiveSubscription) {
//             await RewardedAdService().showAd(
//               onEarnedReward: () {
//                 debugPrint("🎉 User earned reward from podcast playback");
//               },
//             );
//           }
//         }
//         debugPrint('▶️ Playing: ${item.title} (${isAudioMode.value ? 'Audio' : 'Video'} mode)');
//       } else {
//         debugPrint('❌ Success is false, throwing exception');
//         throw Exception('Failed to initialize media player');
//       }
//     } catch (e, stackTrace) {
//       _handleException('playPodcast', e, stackTrace);

//       if (attempt < maxRetryAttempts - 1) {
//         debugPrint('🔄 Retrying podcast playback (${attempt + 1}/$maxRetryAttempts)...');
//         await Future.delayed(retryDelay);
//         await _playPodcastWithRetry(index, attempt + 1);
//       } else {
//         if (canPlayNext) {
//           debugPrint('⏭️ Current podcast failed, trying next one...');
//           await Future.delayed(const Duration(milliseconds: 500));
//           await _playPodcastWithRetry(index + 1, 0);
//         } else {
//           _setLoadingStatus(Status.error);
//         }
//       }
//     }
//   }

//   Future<T?> _executeWithRetry<T>(Future<T> Function() operation, String operationName, [int maxAttempts = maxRetryAttempts]) async {
//     for (int attempt = 0; attempt < maxAttempts; attempt++) {
//       try {
//         return await operation();
//       } catch (e, stackTrace) {
//         _handleException('$operationName (attempt ${attempt + 1})', e, stackTrace);

//         if (attempt < maxAttempts - 1) {
//           debugPrint('🔄 Retrying $operationName (${attempt + 1}/$maxAttempts)...');
//           await Future.delayed(retryDelay);
//         } else {
//           _setError('Failed after $maxAttempts attempts: $e');
//         }
//       }
//     }
//     return null;
//   }

//   Future<void> togglePlayPause() async {
//     if (loadingStatus.value == Status.loading || !hasCurrentItem) {
//       return;
//     }

//     try {
//       if (isAudioMode.value) {
//         await _toggleAudioPlayback();
//       } else {
//         await _toggleVideoPlayback();
//       }
//     } catch (e, stackTrace) {
//       _handleException('togglePlayPause', e, stackTrace);
//       isPlaying.value = false;

//       // Try to recover by reloading current item
//       if (hasCurrentItem) {
//         debugPrint('🔧 Attempting to recover playback...');
//         await playPodcast(index: currentIndex.value);
//       }
//     }
//   }

//   /// Switch to video mode (load video on-demand)
//   Future<bool> switchToVideoMode() async {
//     if (!hasCurrentItem) return false;
    
//     final currentUrl = currentItem.value?.podcastUrl ?? "";
//     if (currentUrl.isEmpty) return false;
    
//     if (_getMediaType(currentUrl) != MediaType.video) {
//       debugPrint('❌ Content is audio-only. Video not available.');
//       return false;
//     }

//     try {
//       debugPrint("🎬 Switching to video mode...");
      
//       final wasPlaying = _audioPlayer.playing;
//       final position = _audioPlayer.position;
      
//       // Pause audio
//       if (wasPlaying) {
//         _audioPlayer.pause();
//       }
      
//       // Initialize video controller
//       final success = await _initializeVideoPlayer(currentUrl);
//       if (!success) {
//         debugPrint('❌ Failed to initialize video');
//         // Resume audio if video failed
//         if (wasPlaying) {
//           _audioPlayer.play();
//         }
//         return false;
//       }
      
//       // Switch to video mode
//       isAudioMode.value = false;
      
//       // Sync position and playback state
//       await videoPlayerController!.seekTo(position);
//       if (wasPlaying) {
//         videoPlayerController!.play();
//         isPlaying.value = true;
//       }
      
//       debugPrint("✅ Successfully switched to video mode");
//       return true;
      
//     } catch (e, stackTrace) {
//       debugPrint('❌ Error switching to video mode: $e');
//       _handleException('switchToVideoMode', e, stackTrace);
//       return false;
//     }
//   }

//   /// Switch back to audio mode (dispose video controller)
//   Future<void> switchToAudioMode() async {
//     if (!hasCurrentItem) return;
    
//     try {
//       debugPrint("🎧 Switching to audio mode...");
      
//       bool wasPlaying = false;
//       Duration position = Duration.zero;
      
//       // Get state from video if available
//       if (videoPlayerController != null) {
//         wasPlaying = videoPlayerController!.value.isPlaying;
//         position = videoPlayerController!.value.position;
        
//         // Pause and dispose video controller
//         if (wasPlaying) {
//           videoPlayerController!.pause();
//         }
//         videoPlayerController!.dispose();
//         _videoPlayerController.value = null;
//         debugPrint("🗑️ Video controller disposed");
//       }
      
//       // Switch to audio mode
//       isAudioMode.value = true;
      
//       // Sync audio position and resume if needed
//       await _audioPlayer.seek(position);
//       if (wasPlaying) {
//         _audioPlayer.play();
//         isPlaying.value = true;
//       }
      
//       debugPrint("✅ Successfully switched to audio mode");
      
//     } catch (e, stackTrace) {
//       debugPrint('❌ Error switching to audio mode: $e');
//       _handleException('switchToAudioMode', e, stackTrace);
//     }
//   }



//   Duration _clampDuration(Duration position, Duration max) {
//     if (position < Duration.zero) return Duration.zero;
//     if (position > max) return max;
//     return position;
//   }

//   Future<void> seek(Duration position) async {
//     if (!hasCurrentItem) return;

//     try {
//       final clampedPosition = _clampDuration(position, totalDuration.value);

//       if (isAudioMode.value) {
//         await _audioPlayer.seek(clampedPosition);
//       } else {
//         await videoPlayerController?.seekTo(clampedPosition);
//       }

//       currentPosition.value = clampedPosition;
//       debugPrint('⏯️ Seeked to: ${_formatDuration(clampedPosition)}');
//     } catch (e, stackTrace) {
//       _handleException('seek', e, stackTrace);
//     }
//   }

//   Future<void> skipBackward({Duration duration = const Duration(seconds: 15)}) async {
//     final newPosition = currentPosition.value - duration;
//     final finalPosition = newPosition < Duration.zero ? Duration.zero : newPosition;
//     await seek(finalPosition);
//   }

//   Future<void> skipForward({Duration duration = const Duration(seconds: 15)}) async {
//     final newPosition = currentPosition.value + duration;
//     final finalPosition = newPosition > totalDuration.value ? totalDuration.value : newPosition;
//     await seek(finalPosition);
//   }

//   Future<void> playNext() async {
//     if (!canPlayNext) {
//       debugPrint('❌ No next podcast available');
//       return;
//     }
    
//     // If using playlist, just seek to next index
//     if (_playlist != null && isAudioMode.value) {
//       final nextIndex = currentIndex.value + 1;
//       if (nextIndex < _playlist!.children.length) {
//         await _audioPlayer.seekToNext();
//         currentIndex.value = nextIndex;
//         currentItem.value = items[nextIndex];
//         isFavorite.value = items[nextIndex].isBookmark ?? false;
//         isLike.value = items[nextIndex].isLike ?? false;
//         _trackView(items[nextIndex].id);
//         debugPrint('⏭️ Playlist: Moved to next track (index: $nextIndex)');
//         return;
//       }
//     }
    
//     await playPodcast(index: currentIndex.value + 1);
//   }

//   Future<void> playPrevious() async {
//     if (currentIndex.value <= 0) {
//       debugPrint('❌ No previous podcast available');
//       return;
//     }
    
//     // If using playlist, just seek to previous index
//     if (_playlist != null && isAudioMode.value) {
//       final prevIndex = currentIndex.value - 1;
//       if (prevIndex >= 0) {
//         await _audioPlayer.seekToPrevious();
//         currentIndex.value = prevIndex;
//         currentItem.value = items[prevIndex];
//         isFavorite.value = items[prevIndex].isBookmark ?? false;
//         isLike.value = items[prevIndex].isLike ?? false;
//         _trackView(items[prevIndex].id);
//         debugPrint('⏮️ Playlist: Moved to previous track (index: $prevIndex)');
//         return;
//       }
//     }
    
//     await playPodcast(index: currentIndex.value - 1);
//   }

//   Future<bool> likePodcast({required String id, required bool currentState}) async {
//     if (likeLoading.value) return currentState;

//     try {
//       likeLoading.value = true;

//       final response = await _executeWithRetry(() async {
//         return await apiClient.post(
//           url: ApiUrl.like(id: id),
//           body: {},
//           showResult: true,
//         );
//       }, 'likePodcast');

//       if (response != null && response.statusCode == 200) {
//         final newState = response.body?['data']?['isLike'] ?? false;
//         isLike.value = newState;
//         return newState;
//       } else {
//         _handleApiError('likePodcast', response?.statusCode ?? 0);
//         return currentState;
//       }
//     } catch (e, stackTrace) {
//       _handleException('likePodcast', e, stackTrace);
//       return currentState;
//     } finally {
//       likeLoading.value = false;
//     }
//   }

//   Future<bool> favoritePodcast({required String id, required bool currentState}) async {
//     if (favoriteLoading.value) return currentState;

//     try {
//       favoriteLoading.value = true;

//       final response = await _executeWithRetry(() async {
//         return await apiClient.post(
//           url: ApiUrl.favoriteAdd(id: id),
//           body: {},
//         );
//       }, 'favoritePodcast');

//       if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
//         final newState = !currentState;
//         isFavorite.value = newState;
//         try {
//           final favoriteController = Get.find<FavoriteController>();
//           favoriteController.pagingController.refresh();
//         } catch (_) {
//         }

//         return newState;
//       } else {
//         _handleApiError('favoritePodcast', response?.statusCode ?? 0);
//         return currentState;
//       }
//     } catch (e, stackTrace) {
//       _handleException('favoritePodcast', e, stackTrace);
//       return currentState;
//     } finally {
//       favoriteLoading.value = false;
//     }
//   }

//   Future<void> getComments({
//     required String id,
//     required int page,
//     required PagingController<int, CommentItem> commentsPagingController,
//   }) async {
//     try {
//       final response = await _executeWithRetry(() async {
//         return await apiClient.get(
//           url: ApiUrl.comments(id: id, page: page),
//           showResult: true,
//         );
//       }, 'getComments');

//       if (response != null && response.statusCode == 200) {
//         final comments = CommentModel.fromJson(response.body);
//         final newItems = comments.data?.result ?? [];

//         if (newItems.isNotEmpty) {
//           commentsPagingController.appendPage(newItems, page + 1);
//         } else {
//           commentsPagingController.appendLastPage(newItems);
//         }
//       } else {
//         commentsPagingController.error = "Failed to load comments";
//       }
//     } catch (e, stackTrace) {
//       _handleException('getComments', e, stackTrace);
//       commentsPagingController.error = "Error loading comments";
//     }
//   }

//   Future<void> addComment({
//     required String id,
//     required TextEditingController commentController,
//     required PagingController<int, CommentItem> commentsPagingController,
//   }) async {
//     if (commentController.text.trim().isEmpty) return;

//     try {
//       final response = await _executeWithRetry(() async {
//         return await apiClient.post(
//           url: ApiUrl.commentsAdd(),
//           body: {
//             "podcast": id,
//             "text": commentController.text.trim(),
//           },
//           showResult: true,
//         );
//       }, 'addComment');

//       if (response != null && response.statusCode == 200) {
//         commentsPagingController.refresh();
//         commentController.clear();
//       } else {
//         commentsPagingController.error = "Failed to add comment";
//       }
//     } catch (e, stackTrace) {
//       _handleException('addComment', e, stackTrace);
//       commentsPagingController.error = "Error adding comment";
//     }
//   }

//   void _resetPlaybackState() {
//     currentPosition.value = Duration.zero;
//     totalDuration.value = Duration.zero;
//     bufferedPosition.value = Duration.zero;
//     isPlaying.value = false;
//   }

//   void _setLoadingStatus(Status status) {
//     debugPrint('📊 Loading status changed: ${loadingStatus.value} → $status');
//     loadingStatus.value = status;
//   }

//   void _setError(String error) {
//     lastError.value = error;
//     debugPrint('❌ Error: $error');
//   }

//   void _clearError() {
//     lastError.value = '';
//     retryCount.value = 0;
//   }

//   MediaType getMediaType(String url) {
//     return _getMediaType(url);
//   }

//   MediaType _getMediaType(String url) {
//     final lowerUrl = url.toLowerCase();
//     const videoExts = ['.mp4', '.mov', '.mkv', '.avi', '.webm', '.m4v', '.m3u8'];
//     const audioExts = ['.mp3', '.aac', '.m4a', '.wav', '.ogg', '.flac'];

//     for (final ext in videoExts) {
//       if (lowerUrl.contains(ext)) return MediaType.video;
//     }
//     for (final ext in audioExts) {
//       if (lowerUrl.contains(ext)) return MediaType.audio;
//     }
//     return MediaType.audio;
//   }

//   MediaItem _createMediaItem(PlayEntity item) {
//     return MediaItem(
//       id: item.id ?? "",
//       album: item.categoryName ?? "",
//       title: item.title ?? "",
//       artist: item.creatorName ?? "",
//       artUri: Uri.tryParse(item.coverImage ?? ""),
//     );
//   }

//   Future<void> _disposePlayers() async {
//     // Only dispose video player, keep audio player and playlist intact
//     try {
//       _videoPositionTimer?.cancel();
//       await _videoPlayerController.value?.dispose();
//     } catch (_) {}

//     _videoPlayerController.value = null;
//     // Don't clear playlist - it should persist across track changes
//   }

//   Future<void> _buildPlaylist() async {
//     try {
//       debugPrint('🔨 Building playlist with ${items.length} items...');
//       final audioSources = <AudioSource>[];
      
//       for (final item in items) {
//         final mediaItem = _createMediaItem(item);
//         final url = item.podcastUrl;
//         if (url.isNotEmpty) {
//           audioSources.add(
//             AudioSource.uri(
//               Uri.parse(url),
//               tag: mediaItem,
//             ),
//           );
//         }
//       }

//       if (audioSources.isEmpty) {
//         debugPrint('⚠️ No audio sources to build playlist');
//         _playlist = null;
//         return;
//       }

//       _playlist = ConcatenatingAudioSource(children: audioSources);
      
//       // Set audio source without auto-playing
//       await _audioPlayer.setAudioSource(_playlist!, initialIndex: 0, preload: true);
//       debugPrint('✅ Playlist built successfully with ${audioSources.length} tracks');
//     } catch (e, stackTrace) {
//       debugPrint('💥 _buildPlaylist failed: $e');
//       _handleException('_buildPlaylist', e, stackTrace);
//       _playlist = null;
//       rethrow; // Re-throw to let caller handle it
//     }
//   }

//   Future<bool> _initializeAudioPlayer(String url, MediaItem mediaItem, bool play) async {
//     try {
//       debugPrint('🎵 _initializeAudioPlayer started (play=$play)');
//       // If playlist exists, seek to the correct index instead of setting source
//       if (_playlist != null && currentIndex.value < _playlist!.children.length) {
//         debugPrint('🎵 Using playlist - seeking to index ${currentIndex.value}');
//         await _audioPlayer.seek(Duration.zero, index: currentIndex.value);
//         debugPrint('🎵 Seek completed');
//         if (play) {
//           debugPrint('🎵 Starting playback...');
//          _audioPlayer.play();
//           debugPrint('🎵 Playback started');
//         }
//         debugPrint('✅ _initializeAudioPlayer returning true (playlist mode)');
//         return true;
//       } else {
//         // Fallback: single track mode (shouldn't happen with playlist)
//         debugPrint('⚠️ Playlist not available, using single track mode');
//         await _audioPlayer.setAudioSource(
//           AudioSource.uri(Uri.parse(url), tag: mediaItem),
//           preload: true,
//         );
//         if (play) {
//           _audioPlayer.play();
//         }
//         debugPrint('✅ _initializeAudioPlayer returning true (single track mode)');
//         return true;
//       }
//     } catch (e, stackTrace) {
//       debugPrint('❌ _initializeAudioPlayer exception: $e');
//       _handleException('_initializeAudioPlayer', e, stackTrace);
//       return false;
//     }
//   }

//   Future<bool> _initializeVideoPlayer(String url) async {
//     try {
//       debugPrint('📺 _initializeVideoPlayer started');
//       final controller = VideoPlayerController.networkUrl(Uri.parse(url));

//       debugPrint('📺 Initializing video controller...');
//       await controller.initialize();
//       debugPrint('📺 Video controller initialized');

//       _videoPlayerController.value = controller;
//       _setupVideoPlayerListeners();
//       debugPrint('✅ _initializeVideoPlayer returning true');
//       return true;
//     } catch (e, stackTrace) {
//       debugPrint('❌ _initializeVideoPlayer exception: $e');
//       _handleException('_initializeVideoPlayer', e, stackTrace);
//       return false;
//     }
//   }

//   Future<void> _toggleAudioPlayback() async {
//     if (_audioPlayer.playing) {
//       _audioPlayer.pause();
//       isPlaying.value = false;
//     } else {
//       _audioPlayer.play();
//       isPlaying.value = true;
//     }
//   }

//   Future<void> _toggleVideoPlayback() async {
//     final controller = videoPlayerController;
//     if (controller == null) {
//       await _fallbackToAudio();
//       return;
//     }

//     try {
//       if (controller.value.isPlaying) {
//        controller.pause();
//         isPlaying.value = false;
//       } else {
//         controller.play();
//         isPlaying.value = true;
//       }
//     } catch (e) {
//       debugPrint('❌ Video playback failed, falling back to audio: $e');
//       await _fallbackToAudio();
//     }
//   }

//   Future<void> _fallbackToAudio() async {
//     try {
//       final item = currentItem.value;
//       if (item?.podcastUrl == null) return;

//       final mediaItem = _createMediaItem(item!);
//       final success = await _initializeAudioPlayer(item.podcastUrl, mediaItem, false);

//       if (success) {
//         isAudioMode.value = true;
//         _audioPlayer.play();
//         isPlaying.value = true;
//         debugPrint('🎧 Successfully switched to audio fallback');
//       }
//     } catch (e, stackTrace) {
//       _handleException('_fallbackToAudio', e, stackTrace);
//       isPlaying.value = false;
//     }
//   }

//   void _setupAudioPlayerListeners() {
//     _audioPositionSubscription?.cancel();
//     _audioDurationSubscription?.cancel();
//     _audioBufferedSubscription?.cancel();
//     _audioStateSubscription?.cancel();

//     _audioPositionSubscription = _audioPlayer.positionStream.listen((position) {
//       if (isAudioMode.value) {
//         currentPosition.value = position;
//       }
//     });

//     _audioDurationSubscription = _audioPlayer.durationStream.listen((duration) {
//       if (duration != null) {
//         totalDuration.value = duration;
//         debugPrint("🎵 Audio duration set: ${_formatDuration(duration)}");
//       }
//     });

//     _audioBufferedSubscription = _audioPlayer.bufferedPositionStream.listen((buffered) {
//       if (isAudioMode.value) {
//         bufferedPosition.value = buffered;
//       }
//     });

//     _audioStateSubscription = _audioPlayer.playerStateStream.listen((state) {
//       if (isAudioMode.value) {
//         final isPlayerPlaying = state.playing;
//         final processingState = state.processingState;

//         isPlaying.value = isPlayerPlaying;

//         if (processingState == ProcessingState.completed) {
//           debugPrint("🎵 Audio playback completed, playing next...");
//           // Playlist will auto-advance, just update UI
//           if (_playlist == null || currentIndex.value >= items.length - 1) {
//             playNext();
//           }
//         }
//       }
//     });

//     // Listen to current index changes from playlist
//     _audioPlayer.currentIndexStream.listen((index) {
//       if (index != null && index != currentIndex.value && index < items.length) {
//         debugPrint('🎵 Playlist auto-advanced to index: $index');
//         currentIndex.value = index;
//         currentItem.value = items[index];
//         isFavorite.value = items[index].isBookmark ?? false;
//         isLike.value = items[index].isLike ?? false;
//         _trackView(items[index].id);
//       }
//     });
//   }

//   void _setupVideoPlayerListeners() {
//     final controller = videoPlayerController;
//     if (controller == null) return;

//     // Cancel existing timer
//     _videoPositionTimer?.cancel();

//     // Position and duration updates
//     _videoPositionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!isAudioMode.value && controller.value.isInitialized) {
//         currentPosition.value = controller.value.position;

//         // Only update total duration if it's not already set or if it's different
//         if (totalDuration.value != controller.value.duration) {
//           totalDuration.value = controller.value.duration;
//           debugPrint("📺 Video duration set: ${_formatDuration(controller.value.duration)}");
//         }

//         // Update buffered position
//         final buffered = controller.value.buffered;
//         if (buffered.isNotEmpty) {
//           bufferedPosition.value = buffered.last.end;
//         }

//         // Check if video ended
//         if (controller.value.position >= controller.value.duration &&
//             controller.value.duration > Duration.zero) {
//           debugPrint("📺 Video playback completed, playing next...");
//           playNext();
//         }
//       }
//     });

//     // Listen to player state changes
//     controller.addListener(() {
//       if (!isAudioMode.value && controller.value.isInitialized) {
//         isPlaying.value = controller.value.isPlaying;
//       }
//     });
//   }

//   Future<void> _trackView(String id) async {
//     if (id.isEmpty) return;

//     await _executeWithRetry(() async {
//       final response = await apiClient.post(
//         url: ApiUrl.videPodcast(id: id),
//         body: {},
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Failed to track view: ${response.statusCode}');
//       }

//       return response;
//     }, 'trackView');
//   }

//   void _handleException(String method, dynamic error, StackTrace stackTrace) {
//     debugPrint('💥 $method Exception: $error');
//     debugPrint('📍 Stack trace: $stackTrace');
//     _setError('$method: $error');
//   }

//   void _handleApiError(String method, int statusCode) {
//     debugPrint('❌ $method API Error: Status $statusCode');
//     _setError('$method API Error: Status $statusCode');
//   }

//   String _formatDuration(Duration duration) {
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes.remainder(60);
//     final seconds = duration.inSeconds.remainder(60);

//     if (hours > 0) {
//       return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//     } else {
//       return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//     }
//   }

//   Future<void> retryCurrentPodcast() async {
//     if (hasCurrentItem) {
//       await playPodcast(index: currentIndex.value);
//     }
//   }

//   Future<void> refreshPodcasts({
//     bool? reels,
//     bool? popular,
//     String? firstPodcastId,
//     bool isAlbum = false,
//     bool isPlaylist = false,
//     String? id
//   }) async {
//     await getPodcast(
//       reels: reels,
//       popular: popular,
//       firstPodcastId: firstPodcastId,
//       isAlbum: isAlbum,
//       isPlaylist: isPlaylist,
//       id: id,
//     );
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     debugPrint('🚀 PodcastFeedController initialized');
//     _setupAudioPlayerListeners();
//   }

//   /// Stop audio when app is closed/terminated
//   void stopAudioOnAppClose() {
//     try {
//       debugPrint('🛑 Stopping audio playback - App is closing');
//       _audioPlayer.stop();
//       _videoPlayerController.value?.pause();
//       isPlaying.value = false;
//     } catch (e) {
//       debugPrint('⚠️ Error stopping audio on app close: $e');
//     }
//   }

//   @override
//   void onClose() {
//     _audioPositionSubscription?.cancel();
//     _audioDurationSubscription?.cancel();
//     _audioBufferedSubscription?.cancel();
//     _audioStateSubscription?.cancel();
//     _videoPositionTimer?.cancel();

//     _audioPlayer.dispose();
//     _videoPlayerController.value?.dispose();
//     _playlist = null;

//     super.onClose();
//     debugPrint('🔄 PodcastFeedController disposed');
//   }
// }