/*
import 'package:audio_service/audio_service.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import '../model/comment_model.dart';
import '../model/paging_next_key.dart';

enum MediaType { audio, video, unknown }

class PodcastFeedController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  final RxList<PlayPodcastItem> items = RxList([]);
  final Rx<PlayPodcastItem> currentItem = PlayPodcastItem().obs;

  final Rx<BetterPlayerController?> betterPlayerController = Rx(null);
  final AudioPlayer audioPlayer = AudioPlayer();

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;

  final RxBool isLike = false.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isAudioMode = true.obs;
  final RxBool isPlaying = false.obs;

  RxBool isGetPodcastLoading = false.obs;

  Future<void> getPodcast({
    bool? reels,
    bool? popular,
    String? firstPodcastId,
    bool isAlbum = false,
    bool isPlaylist = false,
    String? id,
  }) async {
    if (isGetPodcastLoading.value) return;
    isGetPodcastLoading.value = true;

    try {
      final response = await apiClient.get(
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

      if (response.statusCode == 200) {
        final feed = PlayFeedModel.fromJson(response.body);
        final newItems = feed.data?.podcasts ?? [];

        items.assignAll(newItems);

        if (newItems.isNotEmpty) {
          playPodcast(item: newItems.first);
        }

        debugPrint('✅ getPodcast() Fetched ${newItems.length} podcast items');
      } else {
        debugPrint('❌ getPodcast() API Error: Status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('💥 getPodcast() Exception: ${e.toString()}');
    } finally {
      isGetPodcastLoading.value = false;
    }
  }

  final Rx<Status> isLoading = Status.loading.obs;
  void loadingMethod(Status status) => isLoading.value = status;
  bool isActive = false;

  Future<void> playPodcast({required PlayPodcastItem item}) async {
    currentItem.value = item;
    isFavorite.value = item.isBookmark ?? false;
    isLike.value = item.isLike ?? false;

    loadingMethod(Status.loading);
    await _disposePlayers();
    final mediaType = getMediaType(item.podcastUrl ?? "");

    final mediaItem = MediaItem(
      id: item.id ?? "",
      album: item.category?.name ?? "",
      title: item.title ?? "",
      artist: item.creator?.name ?? "",
      artUri: Uri.parse(item.coverImage ?? ""),
    );

    try {
      bool success = false;

      switch (mediaType) {
        case MediaType.audio:
          success = await _loadAudio(url: item.podcastUrl ?? "", media: mediaItem);
          isAudioMode.value = true;
          break;

        case MediaType.video:
          success = await _loadVideo(item.podcastUrl ?? "");
          isAudioMode.value = false;
          break;

        case MediaType.unknown:
          loadingMethod(Status.noDataFound);
          return;
      }

      if (success) {
        loadingMethod(Status.completed);
        isPlaying.value = true;
        debugPrint('▶️ Playing ${mediaItem.title}');
      } else {
        loadingMethod(Status.error);
      }
    } catch (_) {
      loadingMethod(Status.error);
    }
  }

  Future<void> _disposePlayers() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.dispose();
    } catch (_) {}
    try {
      betterPlayerController.value?.dispose();
    } catch (_) {}
    betterPlayerController.value = null;
  }

  MediaType getMediaType(String url) {
    final lowerUrl = url.toLowerCase();
    final videoExts = ['.mp4', '.mov', '.mkv', '.avi', '.webm', '.m4v', '.m3u8'];
    final audioExts = ['.mp3', '.aac', '.m4a', '.wav', '.ogg', '.flac'];

    if (videoExts.any((ext) => lowerUrl.endsWith(ext))) return MediaType.video;
    if (audioExts.any((ext) => lowerUrl.endsWith(ext))) return MediaType.audio;

    return MediaType.unknown;
  }

  Future<bool> _loadAudio({required String url, required MediaItem media}) async {
    try {
      await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(url), tag: media),
        preload: true,
      );
      await audioPlayer.seek(currentPosition.value);

      await audioPlayer.play();
      return true;
    } catch (e) {
      debugPrint('❌ _loadAudio failed: $e');
      return false;
    }
  }

  Future<bool> _loadVideo(String url) async {
    try {
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 2000,
          maxBufferMs: 10000,
          bufferForPlaybackMs: 1000,
          bufferForPlaybackAfterRebufferMs: 2000,
        ),
      );

      final controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          looping: false,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enablePlaybackSpeed: true,
            enableQualities: true,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );

      betterPlayerController.value = controller;
      return true;
    } catch (e) {
      debugPrint('❌ _loadVideo failed: $e');
      return false;
    }
  }

  Future<void> togglePlayPause() async {
    if (isLoading.value == Status.loading) {
      debugPrint('⏳ Still loading, ignoring toggle...');
      return;
    }

    try {
      if (isAudioMode.value) {
        if (audioPlayer.playing) {
          await audioPlayer.pause();
          isPlaying.value = false;
        } else {
          await audioPlayer.play();
          isPlaying.value = true;
        }
      } else {
        final controller = betterPlayerController.value;
        if (controller == null) {
          debugPrint('⚠️ Video controller is null, falling back to audio...');
          await _fallbackToAudio();
          return;
        }

        try {
          final playing = controller.isPlaying() ?? false;
          if (playing) {
            await controller.pause();
            isPlaying.value = false;
          } else {
            await controller.play();
            isPlaying.value = true;
          }
        } catch (e) {
          debugPrint('❌ Video play failed, falling back to audio. Error: $e');
          await _fallbackToAudio();
        }
      }

      debugPrint('✅ togglePlayPause() completed - isPlaying: ${isPlaying.value}');
    } catch (e, st) {
      debugPrint('💥 togglePlayPause() Exception: $e');
      debugPrint('📍 Stack trace: $st');
      isPlaying.value = false;
    }
  }

  Future<void> _fallbackToAudio() async {
    try {
      final item = currentItem.value;
      if (item.podcastUrl == null || item.podcastUrl!.isEmpty) {
        debugPrint('⚠️ No podcast URL available for fallback');
        return;
      }

      final mediaItem = MediaItem(
        id: item.id ?? "",
        album: item.category?.name ?? "",
        title: item.title ?? "",
        artist: item.creator?.name ?? "",
        artUri: Uri.parse(item.coverImage ?? ""),
      );

      final audioRes = await _loadAudio(url: item.podcastUrl!, media: mediaItem);
      if (audioRes) {
        isAudioMode.value = true;
        await audioPlayer.play();
        isPlaying.value = true;
        debugPrint('🎧 Successfully switched to audio fallback mode');
      } else {
        debugPrint('❌ Fallback to audio also failed');
        isPlaying.value = false;
      }
    } catch (e, st) {
      debugPrint('💥 _fallbackToAudio() Exception: $e');
      debugPrint('📍 Stack trace: $st');
      isPlaying.value = false;
    }
  }

  Future<void> toggleMode({required String url}) async {
    if (isActive)return;

    try {
      final contentType = getMediaType(url);

*/
/*      // ✅ Only allow toggle if video content
      if (contentType. || !contentType.startsWith('video')) {
        debugPrint('❌ Content is audio-only. Toggle not possible.');
        return;
      }*//*


      isActive = true;

      if (isAudioMode.value) {
        final wasAudioPlaying = audioPlayer.playing;
        currentPosition.value = audioPlayer.position;

        if (wasAudioPlaying) {
          await audioPlayer.pause();
        }

        isAudioMode.value = false;

        if (betterPlayerController.value != null) {
          await betterPlayerController.value!.seekTo(currentPosition.value);
          if (wasAudioPlaying) {
            await betterPlayerController.value!.play();
            debugPrint('   ▶️ Video playback started');
            isPlaying.value = true;
          } else {
            debugPrint('   ⏸️ Video remains paused (audio was paused)');
            isPlaying.value = false;
          }
        } else {
          debugPrint('❌ BetterPlayer controller is not initialized');
          isPlaying.value = false;
        }
      } else {
        // 🎬→🔊 Switching from Video to Audio
        debugPrint('🎬→🔊 Switching from video to audio mode');

        final wasVideoPlaying = betterPlayerController.value?.isPlaying() ?? false;
        currentPosition.value = await betterPlayerController.value?.videoPlayerController?.position ?? Duration.zero;

        debugPrint('   ⏯️ Video was playing: $wasVideoPlaying');
        debugPrint('   ⏯️ Current video position: ${_formatDuration(currentPosition.value)}');

        if (wasVideoPlaying) {
          await betterPlayerController.value?.pause();
          debugPrint('   🎬 Video paused');
        }

        isAudioMode.value = true;
        debugPrint('   🔊 Audio mode enabled');

        await audioPlayer.seek(currentPosition.value);
        debugPrint('   ⏯️ Audio seeking to: ${_formatDuration(currentPosition.value)}');

        if (wasVideoPlaying) {
          await audioPlayer.play();
          debugPrint('   ▶️ Audio playback started');
          isPlaying.value = true;
        } else {
          debugPrint('   ⏸️ Audio remains paused (video was paused)');
          isPlaying.value = false;
        }
      }
    } catch (e, st) {
      debugPrint('💥 toggleMode() error: $e');
      debugPrint('📍 Stack trace: $st');
    } finally {
      isActive = false;
    }
  }



  void _updateVideoProgress() {
    betterPlayerController.value?.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        currentPosition.value = event.parameters?["progress"] ?? Duration.zero;
        totalDuration.value = event.parameters?["duration"] ?? Duration.zero;
        bufferedPosition.value = event.parameters?["buffered"] ?? Duration.zero;
      }

      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        playNextPodcast();
      }
    });
  }

  Future<void> toggleMode({required String url}) async {
    final startTime = DateTime.now();
    debugPrint('🔄 toggleMode() started at $startTime');
    debugPrint('   📊 Current mode: ${isAudioMode.value ? "Audio" : "Video"}');
    debugPrint('   🔒 isActive: $isActive / $url');

    if (isActive) {
      debugPrint('⚠️ toggleMode() already active, returning');
      return;
    }

    try {
      final contentType = await getContentType(url);
      if (contentType != null && contentType.startsWith('video')) {
        isActive = true;
        debugPrint('🔒 Setting isActive = true');

        if (isAudioMode.value) {
          // Switching from Audio to Video mode
          debugPrint('🔊→🎬 Switching from audio to video mode');

          // Store current playing state and position
          final wasAudioPlaying = audioPlayer.playing;
          currentPosition.value = audioPlayer.position;
          debugPrint('   ⏯️ Audio was playing: $wasAudioPlaying');
          debugPrint('   ⏯️ Current audio position: ${_formatDuration(currentPosition.value)}');

          // Pause audio if playing
          if (wasAudioPlaying) {
            audioPlayer.pause();
            debugPrint('   🔊 Audio paused');
          }

          // Switch to video mode
          isAudioMode.value = false;
          debugPrint('   🎬 Video mode enabled');

          // Initialize video if needed and seek to current position
          if (betterPlayerController.value != null) {
            // Seek video to same position
            await betterPlayerController.value!.seekTo(currentPosition.value);
            debugPrint('   ⏯️ Video seeking to: ${_formatDuration(currentPosition.value)}');

            if (wasAudioPlaying) {
              betterPlayerController.value!.play();
              debugPrint('   ▶️ Video playback started');
              isPlaying.value = true;
            } else {
              debugPrint('   ⏸️ Video remains paused (audio was paused)');
              isPlaying.value = false;
            }
          } else {
            debugPrint('❌ BetterPlayer controller is not initialized');
            isPlaying.value = false;
          }
        } else {
          // 🎬→🔊 Switching from Video to Audio
          debugPrint('🎬→🔊 Switching from video to audio mode');

          final wasVideoPlaying = betterPlayerController.value?.isPlaying() ?? false;
          currentPosition.value =
              await betterPlayerController.value?.videoPlayerController?.position ?? Duration.zero;
          debugPrint('   ⏯️ Video was playing: $wasVideoPlaying');
          debugPrint('   ⏯️ Current video position: ${_formatDuration(currentPosition.value)}');

          if (wasVideoPlaying) {
            await betterPlayerController.value?.pause();
            debugPrint('   🎬 Video paused');
          }

          isAudioMode.value = true;
          debugPrint('   🔊 Audio mode enabled');

          await audioPlayer.seek(currentPosition.value);
          debugPrint('   ⏯️ Audio seeking to: ${_formatDuration(currentPosition.value)}');

          if (wasVideoPlaying) {
            await audioPlayer.play();
            debugPrint('   ▶️ Audio playback started');
            isPlaying.value = true;
          } else {
            debugPrint('   ⏸️ Audio remains paused (video was paused)');
            isPlaying.value = false;
          }
        }
      } else {
        debugPrint('❌ Content is not video, cannot toggle modes');
      }
    } catch (e) {
      debugPrint('💥 toggleMode() error: $e');
      debugPrint('📍 Stack trace: ${StackTrace.current}');
    } finally {
      final endTime = DateTime.now();
      isActive = false;
      final duration = endTime.difference(startTime).inMilliseconds;
      debugPrint('🔓 Setting isActive = false');
      debugPrint('▶️ Final isPlaying state: ${isPlaying.value}');
      debugPrint('✅ toggleMode() finished at $endTime ⏱️ Duration: $duration ms');
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
      // 🎵 Audio mode
      final newPosition = currentPosition.value - skipDuration;
      final finalPosition = newPosition < Duration.zero ? Duration.zero : newPosition;
      debugPrint(
        '🔊 Audio skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)}',
      );
      seekAudio(finalPosition);
    } else {
      // 🎬 Video mode
      final newPosition = currentPosition.value - skipDuration;
      final finalPosition = newPosition < Duration.zero ? Duration.zero : newPosition;

      final controller = betterPlayerController.value;
      if (controller != null) {
        debugPrint(
          '🎬 Video skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)}',
        );
        controller.seekTo(finalPosition);
      } else {
        debugPrint('❌ BetterPlayer controller not initialized');
      }
    }
  }

*/
/*  void skipForward() {
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
  }*//*


  // Updated to use PageController
  void playNextPodcast() {
    debugPrint('⏭️ playNextPodcast() called');

    final currentItems = pagingController.itemList;
    debugPrint('   📋 Total items available: ${currentItems?.length ?? 0}');
    debugPrint('   📍 Current index: ${currentIndex.value}');

    if (currentItems == null || currentItems.isEmpty) {
      debugPrint('❌ No items available');
      return;
    }

    final nextIndex = currentIndex.value + 1;

    if (nextIndex >= currentItems.length) {
      debugPrint('🏁 At last item (index ${currentIndex.value})');

      if (pagingController.nextPageKey != null) {
        debugPrint('📄 More pages available, loading next page...');
        // This will trigger the page request listener
        return;
      }

      debugPrint("🚫 No next podcast available - reached end");
      return;
    }

    debugPrint('📄 Navigating to next page: $nextIndex');
    currentIndex.value = nextIndex;
    _animateToPage(nextIndex);
  }

  void playPreviousPodcast() {
    debugPrint('⏮️ playPreviousPodcast() called');

    final currentItems = pagingController.itemList;
    debugPrint('   📋 Total items available: ${currentItems?.length ?? 0}');
    debugPrint('   📍 Current index: ${currentIndex.value}');

    if (currentItems == null || currentItems.isEmpty) {
      debugPrint('❌ No items available');
      return;
    }

    if (currentIndex.value <= 0) {
      debugPrint("🚫 No previous podcast available - at beginning (index: ${currentIndex.value})");
      return;
    }

    final previousIndex = currentIndex.value - 1;
    debugPrint('📄 Navigating to previous page: $previousIndex');
    currentIndex.value = previousIndex;
    _animateToPage(previousIndex);
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
        final bool likeData = response.body?['data']?['isLike'] ?? false;
        debugPrint('✅ Like operation successful: $current → $likeData');
        isLike.value = likeData;
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

      debugPrint('🌐 Making favorite API request...$id');
      var response = await apiClient.post(url: ApiUrl.favoriteAdd(id: id), body: {});
      debugPrint('📥 Favorite API response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bool newBookmarkState = !current;
        isFavorite.value = newBookmarkState;
        final favoriteController = Get.find<FavoriteController>();
        favoriteController.pagingController.refresh();
        return newBookmarkState;
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

  Future<void> viewPodcast({required String id}) async {
    int attempts = 0;

    while (attempts < 5) {
      try {
        var response = await apiClient.post(
          url: ApiUrl.videPodcast(id: id),
          body: {},
        );

        if (response.statusCode == 200) {
          return;
        }
      } catch (_) {}

      attempts++;

      if (attempts < 5) {
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  Future<void> getComments({
    required String id,
    required int page,
    required PagingController<int, CommentItem> commentsPagingController,
  }) async {
    try {
      print("---------------------ID-S only ID -${id ?? ""}");
      var response = await apiClient.get(
        url: ApiUrl.comments(id: id, page: page),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final comments = CommentModel.fromJson(response.body);
        final newItems = comments.data?.result ?? [];

        if (newItems.isNotEmpty) {
          commentsPagingController.appendPage(newItems, page + 1);
        } else {
          commentsPagingController.appendLastPage(newItems);
        }
      } else {
        commentsPagingController.error = "";
      }
    } catch (_) {
      commentsPagingController.error = "";
    }
  }

  Future<void> addComments({
    required String id,
    required TextEditingController comments,
    required PagingController<int, CommentItem> commentsPagingController,
  }) async {
    try {
      var response = await apiClient.post(
        url: ApiUrl.commentsAdd(),
        body: {
          "podcast": id,
          "text": comments.text,
        },
        showResult: true,
      );

      if (response.statusCode == 200) {
        commentsPagingController.refresh();
        comments.clear();
      } else {
        commentsPagingController.error = "";
      }
    } catch (_) {
      commentsPagingController.error = "";
    }
  }

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
    audioPlayer.dispose();
    betterPlayerController.value?.dispose();
    super.onClose();
  }
}
*/
