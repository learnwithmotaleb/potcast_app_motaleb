import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/play/model/podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:video_player/video_player.dart';

class AudioPlayController extends GetxController{
  final ApiClient apiClient = serviceLocator();
  final Rx<VideoPlayerController?> videoPlayerController = Rx(null);
  final AudioPlayer audioPlayer = AudioPlayer();

  final Rx<bool> isAudioMode = true.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isShowBottom = false.obs;

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;

  final Rx<PodcastModel> postModel = PodcastModel().obs;
  final RxString currentMediaId = ''.obs;
  final RxBool isLike = false.obs;
  final RxBool isFavorite = false.obs;

  /// ============================= GET Podcast Details Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  Future<void> playPodcast({required String id, String? url, bool isNextPodcast = false}) async {
    try{
      if (!isNextPodcast && currentMediaId.value == id) {
        print("Media ID $id is already playing");
        return;
      }

      loadingMethod(Status.loading);
      videoPlayerController.value?.removeListener(_updateVideoProgress);
      videoPlayerController.value?.dispose();
      audioPlayer.stop();
      videoPlayerController.value = null;

      var response = await apiClient.post(url: url ?? ApiUrl.play(id: id), body: {}, showResult: true);
      if (response.statusCode == 200) {
        postModel.value = PodcastModel.fromJson(response.body);
        isLike.value = postModel.value.data?.isLiked?? false;
        isFavorite.value = postModel.value.data?.isFavorite?? false;
        final contentUrl = postModel.value.data?.podcast?.audio ?? "";

        final contentType = await getContentType(contentUrl);

        if (contentType != null) {
          final mediaItem = MediaItem(
            id: postModel.value.data?.podcast?.id??"",
            album:  postModel.value.data?.podcast?.category?.title??"",
            title:  postModel.value.data?.podcast?.title??"",
            artist:  postModel.value.data?.podcast?.creator?.user?.name??"",
            artUri: Uri.parse(postModel.value.data?.podcast?.cover??""),
          );

          if (contentType.startsWith('video')) {
            _loadVideo(contentUrl).then((value){
              if (value) {
                loadingMethod(Status.completed);
                isPlaying.value = true;
                isAudioMode.value = false;
                videoPlayerController.value?.play();
                currentMediaId.value = postModel.value.data?.podcast?.id??"";
              } else {
                currentMediaId.value = '';
                loadingMethod(Status.error);
              }
            });
            _loadAudio(url: contentUrl, media: mediaItem);
          } else if (contentType.startsWith('audio')) {
            final audioRes = await _loadAudio(url: contentUrl, media: mediaItem);
            if (audioRes) {
              loadingMethod(Status.completed);
              audioPlayer.play();
              isPlaying.value = true;
              currentMediaId.value = postModel.value.data?.podcast?.id??"";
              isAudioMode.value = true;
            } else {
              currentMediaId.value = '';
              loadingMethod(Status.error);
            }
          }else{
            currentMediaId.value = '';
            loadingMethod(Status.noDataFound);
          }
        } else {
          currentMediaId.value = '';
          loadingMethod(Status.error);
        }
      } else {
        currentMediaId.value = '';
        if (response.statusCode == 503) {
          loadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          loadingMethod(Status.noDataFound);
        } else {
          loadingMethod(Status.error);
        }
      }
    }catch(e){
      currentMediaId.value = '';
      loadingMethod(Status.error);
    }
  }

  Future<bool> _loadAudio({required String url, required MediaItem media}) async {
    final startTime = DateTime.now();
    print('🔊 _loadAudio() started at $startTime');

    try {
      await audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: media,
        ),
        preload: true,
      );
      await audioPlayer.seek(currentPosition.value);
      return true;
    } catch (e) {
      print('❌ _loadAudio() error: $e');
      return false;
    } finally {
      final endTime = DateTime.now();
      print('✅ _loadAudio() finished at $endTime ⏱️ Duration: ${endTime.difference(startTime).inMilliseconds} ms');
    }
  }

  Future<bool> _loadVideo(String url) async {
    final startTime = DateTime.now();
    print('🎥 _loadVideo() started at $startTime');

    try {
      videoPlayerController.value = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoPlayerController.value?.initialize();
      videoPlayerController.value?.addListener(_updateVideoProgress);
      return true;
    } catch (e) {
      print('❌ _loadVideo() error: $e');
      return false;
    } finally {
      final endTime = DateTime.now();
      print('✅ _loadVideo() finished at $endTime ⏱️ Duration: ${endTime.difference(startTime).inMilliseconds} ms');
    }
  }

  void _updateVideoProgress() {
    if ((videoPlayerController.value?.value.isInitialized ?? false) && !isAudioMode.value) {
      final controller = videoPlayerController.value!;
      currentPosition.value = controller.value.position;
      totalDuration.value = controller.value.duration ?? Duration.zero;
      bufferedPosition.value = controller.value.buffered.lastOrNull?.end ?? Duration.zero;

      if (controller.value.position >= controller.value.duration && !controller.value.isPlaying) {
        playNext();
      }
    }
  }

  Future<String?> getContentType(String? url) async {
    if(url == null) {
      return null;
    }
    final startTime = DateTime.now();
    print('📄 getContentType() started at $startTime');

    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.headers['content-type'];
      }
    } catch (e) {
      print('❌ getContentType() error: $e');
    } finally {
      final endTime = DateTime.now();
      print('✅ getContentType() finished at $endTime ⏱️ Duration: ${endTime.difference(startTime).inMilliseconds} ms');
    }

    return null;
  }

  void seekAudio(Duration position) => audioPlayer.seek(position);

  void skipBackward() {
    const skipDuration = Duration(minutes: 15);
    if (isAudioMode.value) {
      final newPosition = currentPosition.value - skipDuration;
      seekAudio(newPosition < Duration.zero ? Duration.zero : newPosition);
    } else {
      final newPosition = currentPosition.value - skipDuration;
      if (videoPlayerController.value != null && videoPlayerController.value!.value.isInitialized) {
        videoPlayerController.value?.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
      }
    }
  }

  bool isActive = false;

  void toggleAudio(){
    try{
      if (!(isAudioMode.value) && videoPlayerController.value != null && videoPlayerController.value!.value.isInitialized) {
        currentPosition.value = videoPlayerController.value?.value.position ?? Duration.zero;
        videoPlayerController.value?.pause();
        isAudioMode.value = true;
        if (!audioPlayer.playing) {
          audioPlayer.seek(currentPosition.value);
          audioPlayer.play();
        }
      } else {
        print('❌ Video controller is not initialized');
      }
    }catch(e){
      print("toggle Only Audio ");
    }
  }

  void openBottom(){
    try{
      if (!(isAudioMode.value) && videoPlayerController.value != null && videoPlayerController.value!.value.isInitialized) {

      } else {
        print('❌ Video controller is not initialized');
      }
    }catch(e){
      print("toggle Only Audio ");
    }
  }

  void toggleMode() {
    final startTime = DateTime.now();
    if (isActive) {
      return;
    }

    try {
      isActive = true;
      print('📄 toggleMode() started at $startTime');

      if (isAudioMode.value) {
        if (audioPlayer.playing) {
          if (videoPlayerController.value != null && videoPlayerController.value!.value.isInitialized) {
            audioPlayer.pause();
            isAudioMode.value = false;
            videoPlayerController.value?.seekTo(currentPosition.value);
            videoPlayerController.value?.play();
          } else {
            print('❌ Video controller is not initialized');
          }
        }
      } else {
        if (videoPlayerController.value != null && videoPlayerController.value!.value.isInitialized) {
          currentPosition.value = videoPlayerController.value?.value.position ?? Duration.zero;
          videoPlayerController.value?.pause();
          isAudioMode.value = true;
          if (!audioPlayer.playing) {
            audioPlayer.seek(currentPosition.value);
            audioPlayer.play();
          }
        } else {
          print('❌ Video controller is not initialized');
        }
      }
    } catch (e) {
      print('❌ toggleMode() error: $e');
      debugPrint(e.toString());
    } finally {
      final endTime = DateTime.now();
      isPlaying.value = true;
      isActive = false;
      print('✅ toggleMode() finished at $endTime ⏱️ Duration: ${endTime.difference(startTime).inMilliseconds} ms');
    }
  }

  void togglePlayPause() {
    try{
      if (isAudioMode.value) {
        if (audioPlayer.playing) {
          audioPlayer.pause();
          isPlaying.value = false;
        } else {
          audioPlayer.play();
          isPlaying.value = true;
        }
      } else {
        if (videoPlayerController.value?.value.isPlaying ?? false) {
          videoPlayerController.value?.pause();
          isPlaying.value = false;
        } else {
          videoPlayerController.value?.play();
          isPlaying.value = true;
        }
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  void playNext() {
    playPodcast(
        id: postModel.value.data?.podcast?.id??"",
        url: ApiUrl.playNext(id: postModel.value.data?.podcast?.id??""),
      isNextPodcast: true,
    );
  }

  @override
  void onInit() {
    super.onInit();

    audioPlayer.positionStream.listen((pos) {
      if (isAudioMode.value) {
        currentPosition.value = pos;
      }
    });

    audioPlayer.durationStream.listen((dur) {
      if (isAudioMode.value && dur != null) {
        totalDuration.value = dur;
      }
    });

    audioPlayer.bufferedPositionStream.listen((buffered) {
      if (isAudioMode.value) {
        bufferedPosition.value = buffered;
      }
    });

    audioPlayer.playerStateStream.listen((state) {
      if (isAudioMode.value && state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  RxBool isWorking = false.obs;
  RxBool likeLoading = false.obs;
  Future<bool> likePodcast({required String id, required bool current}) async {
    try{
      if (isWorking.value) {
        return current;
      }
      likeLoading.value = true;
      isWorking.value = true;
      var response = await apiClient.post(url: ApiUrl.like(id: id),body: {},showResult: true);
      if (response.statusCode == 200) {
        likeLoading.value = false;
        final bool likeData = response.body?['data']?['like']??false;
        return likeData;
      } else {
        likeLoading.value = false;
        return current;
      }
    }catch(e){
      likeLoading.value = false;
      return current;
    }finally{
      likeLoading.value = false;
      isWorking.value = false;
    }
  }

  RxBool favoriteLoading = false.obs;
  Future<bool> favoritePodcast({required String id, required bool current}) async {
    try{
      if (isWorking.value) {
        return current;
      }
      favoriteLoading.value = true;
      isWorking.value = true;
      var response = await apiClient.post(url: ApiUrl.favoriteAdd(),body: {"podcastId" : id},showResult: true);
      if (response.statusCode == 200) {
        favoriteLoading.value = false;
        final bool favorite = response.body?['data']?['favorite']??false;
        return favorite;
      } else {
        favoriteLoading.value = false;
        return current;
      }
    }catch(e){
      favoriteLoading.value = false;
      return current;
    }finally{
      favoriteLoading.value = false;
      isWorking.value = false;
    }
  }

  final adUnitId = Platform.isAndroid ? AppConstants.bannerAndroid : AppConstants.bannerIOS;
  BannerAd? bannerAd;
  RxBool isLoaded = false.obs;
  void loadAd({required int width, required int height}) async {
    bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize(width: width, height: height),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          isLoaded.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    audioPlayer.dispose();
    videoPlayerController.value?.dispose();
    super.onClose();
  }
}