import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/play/model/podcast_model.dart';
import 'package:podcast/presentation/screens/play/widget/audio_play_control.dart';
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
        isFavorite.value = postModel.value.data?.isFavorited?? false;

        playAudio(podcast: PodcastModel.fromJson(response.body));
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

  Future<void> playNextPodcast({required String id}) async {
    try{
      loadingMethod(Status.loading);
      var response = await apiClient.post(url: ApiUrl.playNext(id: id),body: {},showResult: true);
      if (response.statusCode == 200) {
        postModel.value = PodcastModel.fromJson(response.body);
        isLike.value = postModel.value.data?.isLiked?? false;
        isFavorite.value = postModel.value.data?.isFavorited?? false;

        playAudio(podcast: PodcastModel.fromJson(response.body));
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

  Future<void> playAudio({required PodcastModel podcast}) async {
    try{
      final mediaItem = MediaItem(
        id: podcast.data?.podcast?.id??"",
        album:  podcast.data?.podcast?.category?.title??"",
        title:  podcast.data?.podcast?.title??"",
        artist:  podcast.data?.podcast?.creator?.user?.name??"",
        artUri: Uri.parse("${AppConstants.baseUrl}${podcast.data?.podcast?.cover??""}"),
      );

      if (!await InternetConnection().hasInternetAccess) {
        print("Key No Internet Connection ===================================:Key ${podcast.data?.podcast?.id}");
        FileInfo? fileIInfo = await cacheManager.getFileFromCache(podcast.data?.podcast?.id??"");
        File? file = fileIInfo?.file;
        if(file != null){
          await audioPlayer.setAudioSource(
            AudioSource.uri(
              Uri.parse(file.path),
              tag: mediaItem,
            ),
          ).then((value) async {
            loadingMethod(Status.completed);
            await play();
          }).catchError((e){
            currentMediaId.value = '';
            loadingMethod(Status.error);
          });
        }else{
          currentMediaId.value = '';
          loadingMethod(Status.internetError);
        }
      } else {
        final cacheFile = await cacheManager.getFileFromCache(podcast.data?.podcast?.id??"");
        final File? file = cacheFile?.file;
        if (file != null && file.path != "") {
          print("Key Has Internet And Get Cache===================================Url${file.path} :Key ${podcast.data?.podcast?.id??""}");
          await audioPlayer.setAudioSource(
            AudioSource.uri(
              Uri.parse(file.path),
              tag: mediaItem,
            ),
          ).then((value) async {
            loadingMethod(Status.completed);
            await play();
          }).catchError((e){
            currentMediaId.value = '';
            loadingMethod(Status.error);
          });
        } else {
          print("Key Has Internet ===================================Url${file?.path} :Key ${podcast.data?.podcast?.id}");
          await cacheManager.getSingleFile(podcast.data?.podcast?.audio??"",key: podcast.data?.podcast?.id);
          await audioPlayer.setAudioSource(
            AudioSource.uri(
              Uri.parse(podcast.data?.podcast?.audio??""),
              tag: mediaItem,
            ),
          ).then((value) async {
            loadingMethod(Status.completed);
            await play();
          }).catchError((e){
            currentMediaId.value = '';
            loadingMethod(Status.error);
          });
        }
      }
    }catch(e){
      currentMediaId.value = '';
      loadingMethod(Status.error);
    }
  }

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

  OverlayEntry? overlayEntry;
  Offset offset = const Offset(5, 80);

  void showAudioPlayerOverlayCard(BuildContext context) {
    if (overlayEntry != null) {
      removeOverlay();
    }

    final double width = MediaQuery.of(context).size.width;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        bottom: offset.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            _onDrag(details.delta, context);
          },
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width - 70.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C77),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          removeOverlay();
                          AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: postModel.value.data?.podcast?.id);
                        },
                        child: SizedBox(
                          height: 60.h,
                          width: 80,
                          child: Obx(() {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0.r),
                              child: CustomNetworkImage(imageUrl: postModel.value.data?.podcast?.cover??""),
                            );
                          }),
                        ),
                      ),
                      const Gap(12),
                      const Expanded(child: AudioPlayControl(isRemove: true,)),
                      const Gap(12),
                    ],
                  ),
                ),
                const Gap(1),
                GestureDetector(
                  onTap: removeOverlay,
                  child: Container(
                    width: 50,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C77),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: const Center(
                        child: Icon(Icons.cancel, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void _onDrag(Offset delta, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widgetWidth = MediaQuery.of(context).size.width - 20;
    const widgetHeight = 100.0;
    offset = Offset(
      (offset.dx + delta.dx).clamp(0.0, screenWidth - widgetWidth),
      (offset.dy - delta.dy).clamp(0.0, screenHeight - widgetHeight),
    );
    overlayEntry?.markNeedsBuild();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}