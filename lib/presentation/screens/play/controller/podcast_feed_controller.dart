import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:video_player/video_player.dart';

import '../model/paging_next_key.dart';

class PodcastFeedController extends GetxController {
  final PagingController<PagingNextKey, PlayPodcastItem> pagingController =
      PagingController(firstPageKey: PagingNextKey(cursor: "", pageKey: 1));
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final Rx<VideoPlayerController?> videoPlayerController = Rx(null);
  final AudioPlayer audioPlayer = AudioPlayer();

  final RxBool isAudioMode = true.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isShowBottom = false.obs;

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;

  final RxString currentMediaId = ''.obs;
  final Rx<PlayPodcastItem> currentItem = PlayPodcastItem().obs;
  final RxBool isLike = false.obs;
  final RxBool isFavorite = false.obs;

  bool isLoadingMove = false;

  Future<void> getPodcast({
    String? cursor,
    required int pageKey,
    bool? reels,
    bool? popular,
  }) async {
    debugPrint('📡 getPodcast() called with cursor: $cursor, reels: $reels, popular: $popular');

    if (isLoadingMove) {
      debugPrint('❌ getPodcast() already loading, returning early');
      return;
    }

    isLoadingMove = true;
    debugPrint('🔄 getPodcast() setting isLoadingMove = true');

    try {
      debugPrint(
          '🌐 Making API request to: ${ApiUrl.playFeed(cursor: cursor, reels: reels, popular: popular)}');

      final response = await apiClient.get(
          url: ApiUrl.playFeed(
            cursor: cursor,
            reels: reels,
            popular: popular,
          ),
          showResult: true);

      debugPrint('📥 API Response received - Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final userServiceAll = PlayFeedModel.fromJson(response.body);
        final newItems = userServiceAll.data?.podcasts ?? [];
        final hasMore = userServiceAll.data?.hasMore ?? false;
        final String nextCursor = userServiceAll.data?.nextCursor ?? "";

        debugPrint('✅ getPodcast() Success:');
        debugPrint('   📊 New items count: ${newItems.length}');
        debugPrint('   🔄 Has more: $hasMore');
        debugPrint('   📍 Next cursor: $nextCursor');
        debugPrint('   📋 Current total items: ${pagingController.itemList?.length ?? 0}');

        if (hasMore && nextCursor.isNotEmpty && newItems.isNotEmpty) {
          debugPrint('📄 Appending page with ${newItems.length} items');
          pagingController.appendPage(
              newItems, PagingNextKey(cursor: nextCursor, pageKey: pageKey + 1));
        } else {
          debugPrint('🏁 Appending last page with ${newItems.length} items');
          pagingController.appendLastPage(newItems);
          debugPrint('   📋 Current total items: ${pagingController.itemList?.length ?? 0}');
        }

        if (pageKey == 1) {
          final items = pagingController.itemList;
          if (items != null && items.isNotEmpty) {
            final firstItem = items.first;

            if (currentMediaId.value != firstItem.id) {
              debugPrint("[Feed] Auto-playing first podcast ID: ${firstItem.id}");
              playPodcast(item: firstItem);
            } else {
              debugPrint("[Feed] First podcast already playing: ${firstItem.id}");
            }
          }
        }
      } else {
        debugPrint('❌ API Error: Status ${response.statusCode}');
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      debugPrint('💥 getPodcast() Exception: ${e.toString()}');
      debugPrint('📍 Stack trace: ${StackTrace.current}');
      pagingController.error = 'Network error: ${e.toString()}';
    } finally {
      isLoadingMove = false;
      debugPrint('✅ getPodcast() finished, isLoadingMove = false');
    }
  }

  final Rx<Status> isLoading = Status.loading.obs;

  loadingMethod(Status status) {
    debugPrint('🔄 Loading status changed: ${isLoading.value} → $status');
    isLoading.value = status;
  }

  Future<void> playPodcast({required PlayPodcastItem item}) async {
    debugPrint('🎵 playPodcast() called for item: ${item.id} - "${item.title}"');

    try {
      if (currentMediaId.value == item.id) {
        debugPrint("⚠️ Media ID ${item.id} is already playing, skipping");
        return;
      }

      debugPrint('📱 Setting current item and loading state');
      currentItem.value = item;
      loadingMethod(Status.loading);

      debugPrint('🧹 Cleaning up previous media resources');
      videoPlayerController.value?.removeListener(_updateVideoProgress);
      videoPlayerController.value?.dispose();
      audioPlayer.stop();
      videoPlayerController.value = null;

      debugPrint('🔍 Getting content type for URL: ${item.audioUrl}');
      final contentType = await getContentType(item.audioUrl);
      debugPrint('📁 Content type detected: $contentType');

      if (contentType != null) {
        final mediaItem = MediaItem(
          id: item.id ?? "",
          album: item.category?.name ?? "",
          title: item.title ?? "",
          artist: item.creator?.name ?? "",
          artUri: Uri.parse(item.coverImage ?? ""),
        );

        debugPrint('🎼 Created MediaItem: ${mediaItem.title} by ${mediaItem.artist}');

        if (contentType.startsWith('video')) {
          debugPrint('🎥 Content type is VIDEO, loading video and audio');
          _loadVideo(item.audioUrl ?? "").then((value) {
            if (value) {
              debugPrint('✅ Video loaded successfully, starting playback');
              loadingMethod(Status.completed);
              isPlaying.value = true;
              isAudioMode.value = false;
              videoPlayerController.value?.play();
              currentMediaId.value = item.id ?? "";
              debugPrint('🎬 Video playback started, currentMediaId: ${currentMediaId.value}');
            } else {
              debugPrint('❌ Video loading failed');
              currentMediaId.value = '';
              loadingMethod(Status.error);
            }
          });
          _loadAudio(url: item.audioUrl ?? "", media: mediaItem);
        } else if (contentType.startsWith('audio')) {
          debugPrint('🔊 Content type is AUDIO, loading audio only');
          final audioRes = await _loadAudio(url: item.audioUrl ?? "", media: mediaItem);
          if (audioRes) {
            debugPrint('✅ Audio loaded successfully, starting playback');
            loadingMethod(Status.completed);
            audioPlayer.play();
            isPlaying.value = true;
            currentMediaId.value = item.id ?? "";
            isAudioMode.value = true;
            debugPrint('🎵 Audio playback started, currentMediaId: ${currentMediaId.value}');
          } else {
            debugPrint('❌ Audio loading failed');
            currentMediaId.value = '';
            loadingMethod(Status.error);
          }
        } else {
          debugPrint('❓ Unknown content type: $contentType');
          currentMediaId.value = '';
          loadingMethod(Status.noDataFound);
        }
      } else {
        debugPrint('❌ Could not determine content type');
        currentMediaId.value = '';
        loadingMethod(Status.error);
      }
    } catch (e) {
      debugPrint("💥 playPodcast() Exception: ${e.toString()}");
      debugPrint('📍 Stack trace: ${StackTrace.current}');
      currentMediaId.value = '';
      loadingMethod(Status.error);
    }
  }

  void _updateVideoProgress() {
    if ((videoPlayerController.value?.value.isInitialized ?? false) && !isAudioMode.value) {
      final controller = videoPlayerController.value!;
      final position = controller.value.position;
      final duration = controller.value.duration;
      final buffered = controller.value.buffered.lastOrNull?.end ?? Duration.zero;

      currentPosition.value = position;
      totalDuration.value = duration;
      bufferedPosition.value = buffered;

      // Only log every 5 seconds to avoid spam
      if (position.inSeconds % 5 == 0) {
        debugPrint(
            '🎬 Video progress: ${_formatDuration(position)} / ${_formatDuration(duration)}');
      }

      if (controller.value.position >= controller.value.duration && !controller.value.isPlaying) {
        debugPrint('🏁 Video completed, playing next podcast');
        playNextPodcast();
      }
    }
  }

  Future<String?> getContentType(String? url) async {
    debugPrint('🔍 getContentType() called for URL: $url');

    if (url == null) {
      debugPrint('❌ getContentType() URL is null');
      return null;
    }

    try {
      debugPrint('🌐 Making HEAD request to: $url');
      final response = await http.head(Uri.parse(url));
      debugPrint('📥 HEAD response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        debugPrint('✅ Content-Type header: $contentType');
        return contentType;
      } else {
        debugPrint('❌ HEAD request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('💥 getContentType() Exception: ${e.toString()}');
    }
    return null;
  }

  Future<bool> _loadAudio({required String url, required MediaItem media}) async {
    final startTime = DateTime.now();
    debugPrint('🔊 _loadAudio() started at $startTime');
    debugPrint('   🎼 Media: "${media.title}" by ${media.artist}');
    debugPrint('   🌐 URL: $url');

    try {
      debugPrint('⚙️ Setting audio source...');
      await audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: media,
        ),
        preload: true,
      );

      debugPrint('⏯️ Seeking to position: ${_formatDuration(currentPosition.value)}');
      await audioPlayer.seek(currentPosition.value);
      debugPrint('✅ Audio source loaded successfully');
      return true;
    } catch (e) {
      debugPrint('❌ _loadAudio() error: $e');
      debugPrint('📍 Stack trace: ${StackTrace.current}');
      return false;
    } finally {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      debugPrint('✅ _loadAudio() finished at $endTime ⏱️ Duration: $duration ms');
    }
  }

  Future<bool> _loadVideo(String url) async {
    final startTime = DateTime.now();
    debugPrint('🎥 _loadVideo() started at $startTime');
    debugPrint('   🌐 URL: $url');

    try {
      debugPrint('⚙️ Creating VideoPlayerController...');
      videoPlayerController.value = VideoPlayerController.networkUrl(Uri.parse(url));

      debugPrint('🔧 Initializing video player...');
      await videoPlayerController.value?.initialize();

      debugPrint('👂 Adding progress listener...');
      videoPlayerController.value?.addListener(_updateVideoProgress);

      debugPrint('✅ Video controller initialized successfully');
      debugPrint('   📐 Video size: ${videoPlayerController.value?.value.size}');
      debugPrint(
          '   ⏱️ Video duration: ${_formatDuration(videoPlayerController.value?.value.duration ?? Duration.zero)}');

      return true;
    } catch (e) {
      debugPrint('❌ _loadVideo() error: $e');
      debugPrint('📍 Stack trace: ${StackTrace.current}');
      return false;
    } finally {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      debugPrint('✅ _loadVideo() finished at $endTime ⏱️ Duration: $duration ms');
    }
  }

  bool isActive = false;

  void toggleAudio() {
    debugPrint('🔄 toggleAudio() called');

    try {
      if (!(isAudioMode.value) &&
          videoPlayerController.value != null &&
          videoPlayerController.value!.value.isInitialized) {
        debugPrint('🎬→🔊 Switching from video to audio mode');
        currentPosition.value = videoPlayerController.value?.value.position ?? Duration.zero;
        debugPrint('   ⏯️ Current position: ${_formatDuration(currentPosition.value)}');

        videoPlayerController.value?.pause();
        debugPrint('   ⏸️ Video paused');

        isAudioMode.value = true;
        debugPrint('   🔊 Audio mode enabled');

        if (!audioPlayer.playing) {
          audioPlayer.seek(currentPosition.value);
          audioPlayer.play();
          debugPrint('   ▶️ Audio playback started at ${_formatDuration(currentPosition.value)}');
        }
      } else {
        debugPrint('❌ Video controller is not initialized or already in audio mode');
      }
    } catch (e) {
      debugPrint("💥 toggleAudio() Exception: ${e.toString()}");
    }
  }

  void toggleMode() {
    final startTime = DateTime.now();
    debugPrint('🔄 toggleMode() started at $startTime');
    debugPrint('   📊 Current mode: ${isAudioMode.value ? "Audio" : "Video"}');
    debugPrint('   🔒 isActive: $isActive');

    if (isActive) {
      debugPrint('⚠️ toggleMode() already active, returning');
      return;
    }

    try {
      isActive = true;
      debugPrint('🔒 Setting isActive = true');

      if (isAudioMode.value) {
        debugPrint('🔊→🎬 Switching from audio to video mode');

        if (audioPlayer.playing) {
          debugPrint('   ⏸️ Pausing audio player');

          if (videoPlayerController.value != null &&
              videoPlayerController.value!.value.isInitialized) {
            audioPlayer.pause();
            debugPrint('   🔊 Audio paused');

            isAudioMode.value = false;
            debugPrint('   🎬 Video mode enabled');

            videoPlayerController.value?.seekTo(currentPosition.value);
            debugPrint('   ⏯️ Video seeking to: ${_formatDuration(currentPosition.value)}');

            videoPlayerController.value?.play();
            debugPrint('   ▶️ Video playback started');
          } else {
            debugPrint('❌ Video controller is not initialized');
          }
        } else {
          debugPrint('   ℹ️ Audio player not playing, no action needed');
        }
      } else {
        debugPrint('🎬→🔊 Switching from video to audio mode');

        if (videoPlayerController.value != null &&
            videoPlayerController.value!.value.isInitialized) {
          currentPosition.value = videoPlayerController.value?.value.position ?? Duration.zero;
          debugPrint('   ⏯️ Current video position: ${_formatDuration(currentPosition.value)}');

          videoPlayerController.value?.pause();
          debugPrint('   ⏸️ Video paused');

          isAudioMode.value = true;
          debugPrint('   🔊 Audio mode enabled');

          if (!audioPlayer.playing) {
            audioPlayer.seek(currentPosition.value);
            debugPrint('   ⏯️ Audio seeking to: ${_formatDuration(currentPosition.value)}');

            audioPlayer.play();
            debugPrint('   ▶️ Audio playback started');
          }
        } else {
          debugPrint('❌ Video controller is not initialized');
        }
      }
    } catch (e) {
      debugPrint('💥 toggleMode() error: $e');
      debugPrint('📍 Stack trace: ${StackTrace.current}');
    } finally {
      final endTime = DateTime.now();
      isPlaying.value = true;
      isActive = false;
      final duration = endTime.difference(startTime).inMilliseconds;
      debugPrint('🔓 Setting isActive = false');
      debugPrint('▶️ Setting isPlaying = true');
      debugPrint('✅ toggleMode() finished at $endTime ⏱️ Duration: $duration ms');
    }
  }

  void togglePlayPause() {
    debugPrint('⏯️ togglePlayPause() called');
    debugPrint('   📊 Current mode: ${isAudioMode.value ? "Audio" : "Video"}');
    debugPrint('   ▶️ Currently playing: ${isPlaying.value}');

    try {
      if (isAudioMode.value) {
        debugPrint('🔊 Audio mode - toggling audio player');

        if (audioPlayer.playing) {
          debugPrint('   ⏸️ Pausing audio');
          audioPlayer.pause();
          isPlaying.value = false;
        } else {
          debugPrint('   ▶️ Playing audio');
          audioPlayer.play();
          isPlaying.value = true;
        }
      } else {
        debugPrint('🎬 Video mode - toggling video player');

        if (videoPlayerController.value?.value.isPlaying ?? false) {
          debugPrint('   ⏸️ Pausing video');
          videoPlayerController.value?.pause();
          isPlaying.value = false;
        } else {
          debugPrint('   ▶️ Playing video');
          videoPlayerController.value?.play();
          isPlaying.value = true;
        }
      }

      debugPrint('✅ togglePlayPause() completed - isPlaying: ${isPlaying.value}');
    } catch (e) {
      debugPrint('💥 togglePlayPause() Exception: ${e.toString()}');
    }
  }

  void seekAudio(Duration position) {
    debugPrint('⏯️ seekAudio() called - seeking to: ${_formatDuration(position)}');
    audioPlayer.seek(position);
  }

  void skipBackward() {
    const skipDuration = Duration(seconds: 15);
    debugPrint('⏪ skipBackward() called - skipping ${skipDuration.inSeconds}s');
    debugPrint('   📊 Current mode: ${isAudioMode.value ? "Audio" : "Video"}');
    debugPrint('   ⏯️ Current position: ${_formatDuration(currentPosition.value)}');

    if (isAudioMode.value) {
      final newPosition = currentPosition.value - skipDuration;
      final finalPosition = newPosition < Duration.zero ? Duration.zero : newPosition;
      debugPrint(
          '🔊 Audio skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)}');
      seekAudio(finalPosition);
    } else {
      final newPosition = currentPosition.value - skipDuration;
      final finalPosition = newPosition < Duration.zero ? Duration.zero : newPosition;

      if (videoPlayerController.value != null && videoPlayerController.value!.value.isInitialized) {
        debugPrint(
            '🎬 Video skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)}');
        videoPlayerController.value?.seekTo(finalPosition);
      } else {
        debugPrint('❌ Video controller not initialized');
      }
    }
  }

  void skipForward() {
    const skipDuration = Duration(seconds: 15);
    debugPrint('⏩ skipForward() called - skipping ${skipDuration.inSeconds}s');
    debugPrint('   📊 Current mode: ${isAudioMode.value ? "Audio" : "Video"}');
    debugPrint('   ⏯️ Current position: ${_formatDuration(currentPosition.value)}');

    if (isAudioMode.value) {
      final newPosition = currentPosition.value + skipDuration;
      final maxPosition = totalDuration.value;
      final finalPosition = newPosition > maxPosition ? maxPosition : newPosition;
      debugPrint(
          '🔊 Audio skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)} (max: ${_formatDuration(maxPosition)})');
      seekAudio(finalPosition);
    } else {
      final newPosition = currentPosition.value + skipDuration;

      if (videoPlayerController.value != null && videoPlayerController.value!.value.isInitialized) {
        final maxPosition = videoPlayerController.value!.value.duration;
        final finalPosition = newPosition > maxPosition ? maxPosition : newPosition;
        debugPrint(
            '🎬 Video skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)} (max: ${_formatDuration(maxPosition)})');
        videoPlayerController.value?.seekTo(finalPosition);
      } else {
        debugPrint('❌ Video controller not initialized');
      }
    }
  }

  void playNextPodcast() {
    debugPrint('⏭️ playNextPodcast() called');

    final currentItems = pagingController.itemList;
    debugPrint('   📋 Total items available: ${currentItems?.length ?? 0}');
    debugPrint('   🎵 Current media ID: ${currentMediaId.value}');

    if (currentItems == null || currentItems.isEmpty) {
      debugPrint('❌ No items available');
      return;
    }

    final currentIndex = currentItems.indexWhere((item) => item.id == currentMediaId.value);
    debugPrint('   📍 Current index: $currentIndex');
    debugPrint('   📊 Items length: ${currentItems.length}');

    if (currentIndex == -1) {
      debugPrint('❌ Current item not found in list');
      return;
    }

    if (currentIndex >= currentItems.length - 1) {
      debugPrint('🏁 At last item (index $currentIndex)');

      if (pagingController.nextPageKey != null) {
        debugPrint('📄 More pages available, next key: ${pagingController.nextPageKey}');
        // There are more pages, the paging controller will handle loading
        return;
      }

      debugPrint("🚫 No next podcast available - reached end");
      return;
    }

    final nextIndex = currentIndex + 1;
    final nextItem = currentItems[nextIndex];
    debugPrint('✅ Playing next: [$nextIndex] "${nextItem.title}" (ID: ${nextItem.id})');

    playPodcast(item: nextItem);
  }

  void playPreviousPodcast() {
    debugPrint('⏮️ playPreviousPodcast() called');

    final currentItems = pagingController.itemList;
    debugPrint('   📋 Total items available: ${currentItems?.length ?? 0}');
    debugPrint('   🎵 Current media ID: ${currentMediaId.value}');

    if (currentItems == null || currentItems.isEmpty) {
      debugPrint('❌ No items available');
      return;
    }

    final currentIndex = currentItems.indexWhere((item) => item.id == currentMediaId.value);
    debugPrint('   📍 Current index: $currentIndex');

    if (currentIndex <= 0) {
      debugPrint("🚫 No previous podcast available - at beginning (index: $currentIndex)");
      return;
    }

    final previousIndex = currentIndex - 1;
    final previousItem = currentItems[previousIndex];
    debugPrint(
        '✅ Playing previous: [$previousIndex] "${previousItem.title}" (ID: ${previousItem.id})');

    playPodcast(item: previousItem);
  }

  final RxBool likeLoading = false.obs;
  final RxBool favoriteLoading = false.obs;

  Future<bool> likePodcast({required String id, required bool current}) async {
    debugPrint('👍 likePodcast() called for ID: $id, current state: $current');

    try {
      if (likeLoading.value) {
        debugPrint('⚠️ Like operation already in progress');
        return current;
      }

      likeLoading.value = true;
      debugPrint('🔄 Setting likeLoading = true');

      debugPrint('🌐 Making like API request...');
      var response = await apiClient.post(url: ApiUrl.like(id: id), body: {}, showResult: true);
      debugPrint('📥 Like API response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final bool likeData = response.body?['data']?['like'] ?? false;
        debugPrint('✅ Like operation successful: $current → $likeData');
        return likeData;
      } else {
        debugPrint('❌ Like API failed with status: ${response.statusCode}');
        return current;
      }
    } catch (e) {
      debugPrint('💥 likePodcast() Exception: ${e.toString()}');
      return current;
    } finally {
      likeLoading.value = false;
      debugPrint('✅ Setting likeLoading = false');
    }
  }

  Future<bool> favoritePodcast({required String id, required bool current}) async {
    debugPrint('⭐ favoritePodcast() called for ID: $id, current state: $current');

    try {
      if (favoriteLoading.value) {
        debugPrint('⚠️ Favorite operation already in progress');
        return current;
      }

      favoriteLoading.value = true;
      debugPrint('🔄 Setting favoriteLoading = true');

      debugPrint('🌐 Making favorite API request...');
      var response = await apiClient.post(
          url: ApiUrl.favoriteAdd(), body: {"podcastId": id}, showResult: true);
      debugPrint('📥 Favorite API response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final bool favorite = response.body?['data']?['favorite'] ?? false;
        debugPrint('✅ Favorite operation successful: $current → $favorite');
        return favorite;
      } else {
        debugPrint('❌ Favorite API failed with status: ${response.statusCode}');
        return current;
      }
    } catch (e) {
      debugPrint('💥 favoritePodcast() Exception: ${e.toString()}');
      return current;
    } finally {
      favoriteLoading.value = false;
      debugPrint('✅ Setting favoriteLoading = false');
    }
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    debugPrint('🚀 PodcastFeedController.onInit() called');
    super.onInit();

    debugPrint('👂 Setting up audio player streams...');

    audioPlayer.positionStream.listen((pos) {
      if (isAudioMode.value) {
        currentPosition.value = pos;
        // Only log every 5 seconds to avoid spam
        if (pos.inSeconds % 5 == 0) {
          debugPrint('🔊 Audio position: ${_formatDuration(pos)}');
        }
      }
    });

    audioPlayer.durationStream.listen((dur) {
      if (isAudioMode.value && dur != null) {
        totalDuration.value = dur;
        debugPrint('⏱️ Audio duration set: ${_formatDuration(dur)}');
      }
    });

    audioPlayer.bufferedPositionStream.listen((buffered) {
      if (isAudioMode.value) {
        bufferedPosition.value = buffered;
        // Only log occasionally to avoid spam
        if (buffered.inSeconds % 10 == 0) {
          debugPrint('📊 Audio buffered: ${_formatDuration(buffered)}');
        }
      }
    });

    audioPlayer.playerStateStream.listen((state) {
      debugPrint('🎵 Audio player state changed: ${state.processingState}');

      if (isAudioMode.value && state.processingState == ProcessingState.completed) {
        debugPrint('🏁 Audio completed, playing next podcast');
        playNextPodcast();
      }
    });

    debugPrint('✅ PodcastFeedController initialization completed');
  }

  @override
  void onClose() {
    debugPrint('💀 PodcastFeedController.onClose() called');

    debugPrint('🧹 Cleaning up resources...');
    audioPlayer.dispose();
    videoPlayerController.value?.dispose();
    pagingController.dispose();

    debugPrint('✅ PodcastFeedController cleanup completed');
    super.onClose();
  }
}
