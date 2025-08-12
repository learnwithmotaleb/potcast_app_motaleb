import 'package:audio_service/audio_service.dart';
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
import 'package:video_player/video_player.dart';

import '../model/paging_next_key.dart';

class PodcastFeedController extends GetxController {
  final PagingController<PagingNextKey, PlayPodcastItem> pagingController =
      PagingController(firstPageKey: PagingNextKey(cursor: "", pageKey: 1));
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final Rx<VideoPlayerController?> videoPlayerController = Rx(null);
  final AudioPlayer audioPlayer = AudioPlayer();
  final PageController pageController = PageController();

  final RxBool isAudioMode = true.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isShowBottom = false.obs;

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;

  final RxString currentMediaId = ''.obs;
  final Rx<PlayPodcastItem> currentItem = PlayPodcastItem().obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isLike = false.obs;
  final RxBool isFavorite = false.obs;

  bool isLoadingMove = false;
  bool isPageAnimating = false;

  Future<void> getPodcast({
    String? cursor,
    required int pageKey,
    bool? reels,
    bool? popular,
    String? firstPodcastId,
  }) async {
    debugPrint(
        '📡 getPodcast() called with cursor: $cursor, reels: $reels, popular: $popular');

    if (isLoadingMove) {
      debugPrint('❌ getPodcast() already loading, returning early');
      return;
    }

    isLoadingMove = true;
    debugPrint('🔄 getPodcast() setting isLoadingMove = true');

    try {
      debugPrint('🌐 Making API request to: ${ApiUrl.playFeed(
        cursor: cursor,
        reels: reels,
        popular: popular,
        pageKey: pageKey,
        firstPodcastId: firstPodcastId,
      )}');

      final response = await apiClient.get(
          url: ApiUrl.playFeed(
            cursor: cursor,
            reels: reels,
            popular: popular,
            pageKey: pageKey,
            firstPodcastId: firstPodcastId,
          ),
          showResult: true);

      debugPrint(
          '📥 API Response received - Status Code: ${response.body["data"]["podcasts"].length}');

      if (response.statusCode == 200) {
        final userServiceAll = PlayFeedModel.fromJson(response.body);
        final newItems = userServiceAll.data?.podcasts ?? [];
        final hasMore = userServiceAll.data?.hasMore ?? false;
        final String nextCursor = userServiceAll.data?.nextCursor ?? "";

        debugPrint('✅ getPodcast() Success:');
        debugPrint('   📊 New items count: ${newItems.length}');
        debugPrint('   🔄 Has more: $hasMore');
        debugPrint('   📍 Next cursor: $nextCursor');
        debugPrint(
            '   📋 Current total items: ${pagingController.itemList?.length ?? 0}');

        if (hasMore && nextCursor.isNotEmpty && newItems.isNotEmpty) {
          debugPrint('📄 Appending page with ${newItems.length} items');
          pagingController.appendPage(newItems,
              PagingNextKey(cursor: nextCursor, pageKey: pageKey + 1));
        } else {
          debugPrint('🏁 Appending last page with ${newItems.length} items');
          pagingController.appendLastPage(newItems);
          debugPrint(
              '   📋 Current total items: ${pagingController.itemList?.length ?? 0}');
        }

        if (pageKey == 1) {
          final items = pagingController.itemList;
          if (items != null && items.isNotEmpty) {
            final firstItem = items.first;
            currentIndex.value = 0;
            playPodcast(item: firstItem, updatePage: false);
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

  Future<void> playPodcast(
      {required PlayPodcastItem item, bool updatePage = true}) async {
    debugPrint(
        '🎵 playPodcast() called for item: ${item.id} - "${item.title}"');

    try {
/*      if (currentMediaId.value == item.id) {
        debugPrint("⚠️ Media ID ${item.id}/ ${currentMediaId.value} is already playing, skipping");
        return;
      }*/

      currentItem.value = item;
      isFavorite.value = item.isBookmark ?? false;
      loadingMethod(Status.loading);

      // Update page if needed and not already animating
      if (updatePage && !isPageAnimating) {
        final items = pagingController.itemList;
        if (items != null) {
          final index = items.indexWhere((i) => i.id == item.id);
          if (index != -1 && index != currentIndex.value) {
            debugPrint('📄 Updating page to index: $index');
            _animateToPage(index);
          }
        }
      }

      videoPlayerController.value?.removeListener(_updateVideoProgress);
      videoPlayerController.value?.dispose();
      audioPlayer.stop();
      videoPlayerController.value = null;

      debugPrint('🔍 Getting content type for URL: ${item.podcastUrl}');
      final contentType = await getContentType(item.podcastUrl);
      debugPrint('📁 Content type detected: $contentType');

      if (contentType != null) {
        final mediaItem = MediaItem(
          id: item.id ?? "",
          album: item.category?.name ?? "",
          title: item.title ?? "",
          artist: item.creator?.name ?? "",
          artUri: Uri.parse(item.coverImage ?? ""),
        );

        debugPrint(
            '🎼 Created MediaItem: ${mediaItem.title} by ${mediaItem.artist}');

        if (contentType.startsWith('video')) {
          _loadVideo(item.podcastUrl ?? "").then((value) {
            if (value) {
              loadingMethod(Status.completed);
              isPlaying.value = true;
              isAudioMode.value = false;
              videoPlayerController.value?.play();
              currentMediaId.value = item.id ?? "";
            } else {
              currentMediaId.value = '';
              loadingMethod(Status.error);
            }
          });
          _loadAudio(url: item.podcastUrl ?? "", media: mediaItem);
        } else if (contentType.startsWith('audio')) {
          final audioRes =
              await _loadAudio(url: item.podcastUrl ?? "", media: mediaItem);
          if (audioRes) {
            loadingMethod(Status.completed);
            audioPlayer.play();
            isPlaying.value = true;
            currentMediaId.value = item.id ?? "";
            isAudioMode.value = true;
          } else {
            currentMediaId.value = '';
            loadingMethod(Status.error);
          }
        } else {
          currentMediaId.value = '';
          loadingMethod(Status.noDataFound);
        }
      } else {
        currentMediaId.value = '';
        loadingMethod(Status.error);
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (isLoading.value == Status.completed) {
          debugPrint('⏰ 5 seconds passed, calling videoPodcast...');
          viewPodcast(id: item.id ?? "");
        }
      });
    } catch (e) {
      currentMediaId.value = '';
      loadingMethod(Status.error);
    }
  }

  // Helper method to animate to a specific page
  void _animateToPage(int index) {
    if (isPageAnimating) {
      return;
    }

    isPageAnimating = true;

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ).then((_) {
      isPageAnimating = false;
    }).catchError((error) {
      isPageAnimating = false;
    });
  }

  void _updateVideoProgress() {
    if ((videoPlayerController.value?.value.isInitialized ?? false) &&
        !isAudioMode.value) {
      final controller = videoPlayerController.value!;
      final position = controller.value.position;
      final duration = controller.value.duration;
      final buffered =
          controller.value.buffered.lastOrNull?.end ?? Duration.zero;

      currentPosition.value = position;
      totalDuration.value = duration;
      bufferedPosition.value = buffered;

      if (controller.value.position >= controller.value.duration &&
          !controller.value.isPlaying) {
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

  Future<bool> _loadAudio(
      {required String url, required MediaItem media}) async {
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

      debugPrint(
          '⏯️ Seeking to position: ${_formatDuration(currentPosition.value)}');
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
      debugPrint(
          '✅ _loadAudio() finished at $endTime ⏱️ Duration: $duration ms');
    }
  }

  Future<bool> _loadVideo(String url) async {
    final startTime = DateTime.now();
    debugPrint('🎥 _loadVideo() started at $startTime');
    debugPrint('   🌐 URL: $url');

    try {
      debugPrint('⚙️ Creating VideoPlayerController...');
      videoPlayerController.value =
          VideoPlayerController.networkUrl(Uri.parse(url));

      debugPrint('🔧 Initializing video player...');
      await videoPlayerController.value?.initialize();

      debugPrint('👂 Adding progress listener...');
      videoPlayerController.value?.addListener(_updateVideoProgress);

      debugPrint('✅ Video controller initialized successfully');
      debugPrint(
          '   📐 Video size: ${videoPlayerController.value?.value.size}');
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
      debugPrint(
          '✅ _loadVideo() finished at $endTime ⏱️ Duration: $duration ms');
    }
  }

  bool isActive = false;

/*  void toggleAudio() {
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
  }*/

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
          debugPrint(
              '   ⏯️ Current audio position: ${_formatDuration(currentPosition.value)}');

          // Pause audio if playing
          if (wasAudioPlaying) {
            audioPlayer.pause();
            debugPrint('   🔊 Audio paused');
          }

          // Switch to video mode
          isAudioMode.value = false;
          debugPrint('   🎬 Video mode enabled');

          // Initialize video if needed and seek to current position
          if (videoPlayerController.value != null &&
              videoPlayerController.value!.value.isInitialized) {
            await videoPlayerController.value?.seekTo(currentPosition.value);
            debugPrint(
                '   ⏯️ Video seeking to: ${_formatDuration(currentPosition.value)}');

            // If audio was playing, start video playback
            if (wasAudioPlaying) {
              videoPlayerController.value?.play();
              debugPrint('   ▶️ Video playback started');
              isPlaying.value = true;
            } else {
              debugPrint('   ⏸️ Video remains paused (audio was paused)');
              isPlaying.value = false;
            }
          } else {
            debugPrint('❌ Video controller is not initialized');
            isPlaying.value = false;
          }
        } else {
          // Switching from Video to Audio mode
          debugPrint('🎬→🔊 Switching from video to audio mode');

          // Store current playing state and position
          final wasVideoPlaying =
              videoPlayerController.value?.value.isPlaying ?? false;
          currentPosition.value =
              videoPlayerController.value?.value.position ?? Duration.zero;
          debugPrint('   ⏯️ Video was playing: $wasVideoPlaying');
          debugPrint(
              '   ⏯️ Current video position: ${_formatDuration(currentPosition.value)}');

          // Pause video if playing
          if (wasVideoPlaying) {
            videoPlayerController.value?.pause();
            debugPrint('   🎬 Video paused');
          }

          // Switch to audio mode
          isAudioMode.value = true;
          debugPrint('   🔊 Audio mode enabled');

          // Seek audio to current position
          await audioPlayer.seek(currentPosition.value);
          debugPrint(
              '   ⏯️ Audio seeking to: ${_formatDuration(currentPosition.value)}');

          // If video was playing, start audio playback
          if (wasVideoPlaying) {
            audioPlayer.play();
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
      debugPrint(
          '✅ toggleMode() finished at $endTime ⏱️ Duration: $duration ms');
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

      debugPrint(
          '✅ togglePlayPause() completed - isPlaying: ${isPlaying.value}');
    } catch (e) {
      debugPrint('💥 togglePlayPause() Exception: ${e.toString()}');
    }
  }

  void seekAudio(Duration position) {
    debugPrint(
        '⏯️ seekAudio() called - seeking to: ${_formatDuration(position)}');
    audioPlayer.seek(position);
  }

  void skipBackward() {
    const skipDuration = Duration(seconds: 15);
    debugPrint('⏪ skipBackward() called - skipping ${skipDuration.inSeconds}s');
    debugPrint('   📊 Current mode: ${isAudioMode.value ? "Audio" : "Video"}');
    debugPrint(
        '   ⏯️ Current position: ${_formatDuration(currentPosition.value)}');

    if (isAudioMode.value) {
      final newPosition = currentPosition.value - skipDuration;
      final finalPosition =
          newPosition < Duration.zero ? Duration.zero : newPosition;
      debugPrint(
          '🔊 Audio skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)}');
      seekAudio(finalPosition);
    } else {
      final newPosition = currentPosition.value - skipDuration;
      final finalPosition =
          newPosition < Duration.zero ? Duration.zero : newPosition;

      if (videoPlayerController.value != null &&
          videoPlayerController.value!.value.isInitialized) {
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
    debugPrint(
        '   ⏯️ Current position: ${_formatDuration(currentPosition.value)}');

    if (isAudioMode.value) {
      final newPosition = currentPosition.value + skipDuration;
      final maxPosition = totalDuration.value;
      final finalPosition =
          newPosition > maxPosition ? maxPosition : newPosition;
      debugPrint(
          '🔊 Audio skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)} (max: ${_formatDuration(maxPosition)})');
      seekAudio(finalPosition);
    } else {
      final newPosition = currentPosition.value + skipDuration;

      if (videoPlayerController.value != null &&
          videoPlayerController.value!.value.isInitialized) {
        final maxPosition = videoPlayerController.value!.value.duration;
        final finalPosition =
            newPosition > maxPosition ? maxPosition : newPosition;
        debugPrint(
            '🎬 Video skip: ${_formatDuration(currentPosition.value)} → ${_formatDuration(finalPosition)} (max: ${_formatDuration(maxPosition)})');
        videoPlayerController.value?.seekTo(finalPosition);
      } else {
        debugPrint('❌ Video controller not initialized');
      }
    }
  }

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

  // Updated to use PageController
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
      debugPrint(
          "🚫 No previous podcast available - at beginning (index: ${currentIndex.value})");
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
      var response = await apiClient.post(
          url: ApiUrl.like(id: id), body: {}, showResult: true);
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

  Future<bool> favoritePodcast(
      {required String id, required bool current}) async {
    debugPrint(
        '⭐ favoritePodcast() called for ID: $id, current state: $current');

    try {
      if (favoriteLoading.value) {
        debugPrint('⚠️ Favorite operation already in progress');
        return current;
      }

      favoriteLoading.value = true;
      debugPrint('🔄 Setting favoriteLoading = true');

      debugPrint('🌐 Making favorite API request...$id');
      var response =
          await apiClient.post(url: ApiUrl.favoriteAdd(id: id), body: {});
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

      if (isAudioMode.value &&
          state.processingState == ProcessingState.completed) {
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
    pageController.dispose(); // Don't forget to dispose PageController

    debugPrint('✅ PodcastFeedController cleanup completed');
    super.onClose();
  }
}
