import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/play/model/comment_model.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class PodcastManuallyPlayController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final AudioPlayer _audioPlayer = serviceLocator<AudioPlayer>();

  final _loadingStatusController = StreamController<Status>.broadcast();
  final _currentItemController = StreamController<PlayEntity?>.broadcast();
  final _itemsController = StreamController<List<PlayEntity>>.broadcast();

  StreamSubscription<int?>? _indexSubscription;
  StreamSubscription<SequenceState?>? _sequenceSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool _listenersSetup = false;

  List<AudioSource> audioSources = [];
  final List<PlayEntity> _items = [];
  PlayEntity? _currentItem;
  Status _loadingStatus = Status.loading;

  final RxBool isLike = false.obs;
  final RxBool isFavorite = false.obs;
  final RxBool likeLoading = false.obs;
  final RxBool favoriteLoading = false.obs;

  bool? _lastReels;
  bool? _lastPopular;
  String? _lastFirstPodcastId;
  bool _lastIsAlbum = false;
  bool _lastIsPlaylist = false;
  String? _lastId;

  AudioPlayer get audioPlayer => _audioPlayer;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get bufferedPositionStream =>
      _audioPlayer.bufferedPositionStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;
  Stream<int?> get currentIndexStream => _audioPlayer.currentIndexStream;
  Stream<SequenceState?> get sequenceStateStream =>
      _audioPlayer.sequenceStateStream;

  // Custom streams
  Stream<Status> get loadingStatusStream => _loadingStatusController.stream;
  Stream<PlayEntity?> get currentItemStream => _currentItemController.stream;
  Stream<List<PlayEntity>> get itemsStream => _itemsController.stream;

  PlayEntity? get currentItem => _currentItem;
  List<PlayEntity> get items => _items;
  Status get loadingStatus => _loadingStatus;
  bool get hasItems => _items.isNotEmpty;

  Future<void> getPodcast({
    bool? reels,
    bool? popular,
    String? firstPodcastId,
    bool isAlbum = false,
    bool isPlaylist = false,
    String? id,
    bool updateMainStatus = false,
  }) async {
    try {

      if (firstPodcastId != null &&
          _currentItem != null &&
          _currentItem!.id == firstPodcastId &&
          _audioPlayer.playing) {
        debugPrint('⏭️ Skipping reload - Song already playing: ${_currentItem!.title}');
        return;
      }

      _lastReels = reels;
      _lastPopular = popular;
      _lastFirstPodcastId = firstPodcastId;
      _lastIsAlbum = isAlbum;
      _lastIsPlaylist = isPlaylist;
      _lastId = id;

      if (updateMainStatus) {
        _updateLoadingStatus(Status.loading);
      }

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

        if (newItems.isEmpty) {
          if (updateMainStatus) {
            _updateLoadingStatus(Status.noDataFound);
          }
          return;
        }

        final newPlayEntities = newItems
            .map(PlayEntity.fromPodcast)
            .whereType<PlayEntity>()
            .toList();

        audioSources.clear();
        _items.clear();

        _items.addAll(newPlayEntities);
        _itemsController.add(_items);

        final newAudioSources = <AudioSource>[];
        for (final item in newPlayEntities) {
          final mediaItem = _createMediaItem(item);
          final url = item.podcastUrl;
          if (url.isNotEmpty) {
            newAudioSources.add(
              AudioSource.uri(
                Uri.parse(url),
                tag: mediaItem,
              ),
            );
          }
        }

        audioSources.addAll(newAudioSources);
          await _audioPlayer.setAudioSource(
            ConcatenatingAudioSource(children: audioSources),
            initialIndex: 0,
            preload: true,
          );

          if (_items.isNotEmpty) {
            _currentItem = _items[0];
            _currentItemController.add(_currentItem);

            isFavorite.value = _currentItem?.isBookmark ?? false;
            isLike.value = _currentItem?.isLike ?? false;
          }
          if (updateMainStatus) {
          _updateLoadingStatus(Status.completed);
        }

        if (_audioPlayer.playing) {
        debugPrint('🛑 Stopping current audio before loading podcast');
        await _audioPlayer.stop();
      }
         _audioPlayer.play();
      } else {
        debugPrint('❌ API Error: Status code ${response.statusCode}');
        if (updateMainStatus) {
          _updateLoadingStatus(Status.error);
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading podcast: $e');
      if (updateMainStatus) {
        _updateLoadingStatus(Status.error);
      }
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  bool isCall = false;

  Future<void> seekToNext() async {
    try{
      if(isCall)return;
      isCall = true;

      if (_audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();
      await Future.delayed(const Duration(seconds: 1));
    }else{
        loadMorePodcasts();
      }
    }catch(e){
      debugPrint('❌ Error seeking to next: $e');
    } finally {
      isCall = false;
    }
  }

  Future<void> seekToPrevious() async {
    if (_audioPlayer.hasPrevious) {
      await _audioPlayer.seekToPrevious();
    }
  }

  Future<void> skipForward(
      {Duration duration = const Duration(seconds: 15)}) async {
    final currentPos = _audioPlayer.position;
    final totalDur = _audioPlayer.duration ?? Duration.zero;
    final newPosition = currentPos + duration;

    if (newPosition < totalDur) {
      await seek(newPosition);
    } else {
      await seek(totalDur);
    }
  }

  Future<void> skipBackward(
      {Duration duration = const Duration(seconds: 15)}) async {
    final currentPos = _audioPlayer.position;
    final newPosition = currentPos - duration;

    if (newPosition > Duration.zero) {
      await seek(newPosition);
    } else {
      await seek(Duration.zero);
    }
  }

  Future<void> playAtIndex(int index) async {
    if (index >= 0 && index < audioSources.length) {
      await _audioPlayer.seek(Duration.zero, index: index);
      await _audioPlayer.play();
    }
  }

  void _updateLoadingStatus(Status status) {
    _loadingStatus = status;
    _loadingStatusController.add(status);
  }

  void _setupListeners() {
    if (_listenersSetup) {
      debugPrint('⚠️ Listeners already set up, skipping...');
      return;
    }

    _indexSubscription?.cancel();
    _sequenceSubscription?.cancel();
    _playerStateSubscription?.cancel();

    _indexSubscription = _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < _items.length) {
        _currentItem = _items[index];
        _currentItemController.add(_currentItem);

        isFavorite.value = _currentItem?.isBookmark ?? false;
        isLike.value = _currentItem?.isLike ?? false;

        debugPrint('📻 Current item changed to: ${_currentItem?.title}');

        _checkAndLoadMore(index);
      }
    });

    _sequenceSubscription = _audioPlayer.sequenceStateStream.listen((state) {
      final tag = state.currentSource?.tag;
      if (tag is MediaItem) {
        debugPrint('🎵 Playing: ${tag.title}');
      }
    });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        debugPrint('🎯 Playlist completed - Auto-loading more podcasts');
        _autoLoadMorePodcasts();
      }
    });

    _listenersSetup = true;
    debugPrint('✅ Listeners successfully set up');
  }

  void _checkAndLoadMore(int currentIndex) {
    if (_items.length < 4) {
      debugPrint('🛑 Auto-load skipped — playlist too short (${_items.length} items).');
      return;
    }

    final remainingItems = _items.length - currentIndex;
    if (remainingItems <= preloadThreshold && !_isLoadingMore) {
      debugPrint('📥 Pre-loading more podcasts ($remainingItems items remaining)');
      _autoLoadMorePodcasts();
    }
  }

  bool _isLoadingMore = false;

  int preloadThreshold = 3;

  bool autoLoadEnabled = true;

  Future<void> _autoLoadMorePodcasts() async {
    if (!autoLoadEnabled || _isLoadingMore || _items.isEmpty) return;

    _isLoadingMore = true;

    try {

      await getPodcast(
        reels: _lastReels,
        popular: _lastPopular,
        firstPodcastId: _lastFirstPodcastId,
        id: _lastId,
        isAlbum: _lastIsAlbum,
        isPlaylist: _lastIsPlaylist,
      );

      debugPrint('✅ Auto-loaded more podcasts. Total: ${_items.length}');
    } catch (e) {
      debugPrint('❌ Failed to auto-load more podcasts: $e');
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMorePodcasts() async {
    return _autoLoadMorePodcasts();
  }

  bool get isLoadingMore => _isLoadingMore;

  MediaItem _createMediaItem(PlayEntity? item) {
    return MediaItem(
      id: item?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      album: item?.categoryName ?? "Podcast",
      title: item?.title ?? "Unknown Title",
      artist: item?.creatorName ?? "Unknown Artist",
      artUri: Uri.tryParse(item?.coverImage ?? ""),
      duration: null,
      extras: {
        'url': item?.podcastUrl,
        'categoryName': item?.categoryName,
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    debugPrint('🚀 PodcastManuallyPlayController initialized');
  }

  void _handleException(String method, dynamic error, StackTrace stackTrace) {
    debugPrint('💥 $method Exception: $error');
    debugPrint('📍 Stack trace: $stackTrace');
  }

  void _handleApiError(String method, int statusCode) {
    debugPrint('❌ $method API Error: Status $statusCode');
  }

  @override
  void onClose() {
    _indexSubscription?.cancel();
    _sequenceSubscription?.cancel();
    _playerStateSubscription?.cancel();

    _listenersSetup = false;

    _loadingStatusController.close();
    _currentItemController.close();
    _itemsController.close();
    debugPrint('🛑 PodcastManuallyPlayController disposed (AudioPlayer kept alive)');
    super.onClose();
  }

  Future<bool> likePodcast(
      {required String id, required bool currentState}) async {
    if (likeLoading.value) return currentState;

    try {
      likeLoading.value = true;

      final response = await apiClient.post(
        url: ApiUrl.like(id: id),
        body: {},
        showResult: true,
      );

      if (response.statusCode == 200) {
        final newState = response.body?['data']?['isLike'] ?? false;
        isLike.value = newState;
        return newState;
      } else {
        _handleApiError('likePodcast', response.statusCode ?? 0);
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

      final response = await apiClient.post(
        url: ApiUrl.favoriteAdd(id: id),
        body: {},
      );

      if ((response.statusCode == 200 || response.statusCode == 201)) {
        final newState = !currentState;
        isFavorite.value = newState;
        try {
          final favoriteController = Get.find<FavoriteController>();
          favoriteController.pagingController.refresh();
        } catch (_) {}

        return newState;
      } else {
        _handleApiError('favoritePodcast', response.statusCode ?? 0);
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
      final response = await apiClient.get(
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
      final response = await apiClient.post(
        url: ApiUrl.commentsAdd(),
        body: {
          "podcast": id,
          "text": commentController.text.trim(),
        },
        showResult: true,
      );

      if (response.statusCode == 200) {
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
}
