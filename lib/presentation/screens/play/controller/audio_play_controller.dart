import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/presentation/screens/play/model/podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class AudioPlayController extends GetxController{
  ApiClient apiClient = ApiClient();
  Rx<PodcastModel> postModel = PodcastModel().obs;
  RxString currentMediaId = ''.obs;
  final cacheManager = DefaultCacheManager();

  RxBool isLike = false.obs;
  RxBool isFavorite = false.obs;

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

  /// ============================= GET Podcast Details Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  Future<void> playPodcast({required String id}) async {
    try{
      if (currentMediaId.value == id) {
        print("Media ID $id is already playing");
        return;
      }
      loadingMethod(Status.loading);
      var response = await apiClient.post(url: ApiUrl.play(id: id),body: {},showResult: true);
      if (response.statusCode == 200) {
        postModel.value = PodcastModel.fromJson(response.body);
        isLike.value = postModel.value.data?.isLiked?? false;
        isFavorite.value = postModel.value.data?.isFavorite?? false;

        // playAudio(podcast: PodcastModel.fromJson(response.body));
        final mediaItem = MediaItem(
          id: postModel.value.data?.podcast?.id??"",
          album:  postModel.value.data?.podcast?.category?.title??"",
          title:  postModel.value.data?.podcast?.title??"",
          artist:  postModel.value.data?.podcast?.creator?.user?.name??"",
          artUri: Uri.parse(postModel.value.data?.podcast?.cover??""),
        );
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(postModel.value.data?.podcast?.audio??""),
            tag: mediaItem,
          ),
          preload: true,
        ).then((value) async {
          loadingMethod(Status.completed);
          await play();
        }).catchError((e){
          currentMediaId.value = '';
          loadingMethod(Status.error);
        });
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
      print(e);
      loadingMethod(Status.error);
    }
  }

  Future<void> playNextPodcast({required String id}) async {
    try{
      loadingMethod(Status.loading);
      var response = await apiClient.post(url: ApiUrl.playNext(id: id),body: {},showResult: true);
      if (response.statusCode == 200) {
        postModel.value = PodcastModel.fromJson(response.body);
        isLike.value = postModel.value.data?.isLiked?? false;
        isFavorite.value = postModel.value.data?.isFavorite?? false;

        // playAudio(podcast: PodcastModel.fromJson(response.body));
        final mediaItem = MediaItem(
          id: postModel.value.data?.podcast?.id??"",
          album:  postModel.value.data?.podcast?.category?.title??"",
          title:  postModel.value.data?.podcast?.title??"",
          artist:  postModel.value.data?.podcast?.creator?.user?.name??"",
          artUri: Uri.parse(postModel.value.data?.podcast?.cover??""),
        );
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(postModel.value.data?.podcast?.audio??""),
            tag: mediaItem,
          ),
          preload: true,
        ).then((value) async {
          loadingMethod(Status.completed);
          await play();
        }).catchError((e){
          currentMediaId.value = '';
          loadingMethod(Status.error);
        });
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

  final audioPlayer = AudioPlayer();

  // Observables
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  Rx<Duration> bufferedPosition = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext();
      }
    });

    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    audioPlayer.bufferedPositionStream.listen((buffered) {
      bufferedPosition.value = buffered;
    });

    audioPlayer.positionStream.listen((pos) {
      currentPosition.value = pos;
    });

    audioPlayer.durationStream.listen((dur) {
      if (dur != null) totalDuration.value = dur;
    });
  }

  var playLoading = Status.completed.obs;
  playLoadingMethod(Status status) => playLoading.value = status;

  Future<void> play() async{
    currentMediaId.value = postModel.value.data?.podcast?.id??"";
    await audioPlayer.play();
  }

  void pauseAudio() => audioPlayer.pause();
  void seekAudio(Duration position) => audioPlayer.seek(position);

  void skipBackward() {
    final newPosition = currentPosition.value - const Duration(seconds: 15);
    seekAudio(newPosition < Duration.zero ? Duration.zero : newPosition);
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

  void playNext() {
    playNextPodcast(id: postModel.value.data?.podcast?.id??"");
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}