import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/widget/audio_play_control.dart';

class AudioPlayController extends GetxController{
  RxBool isLoading = false.obs;
  RxInt currentAudioIndex = 0.obs;
  RxString currentMediaId = ''.obs;
  final cacheManager = DefaultCacheManager(); // Cache manager instance
  Rx<AudioPlayerModel> clickAudioPlayerData = AudioPlayerModel(id: "", url: "", title: "", album: "", image: "", artist: "").obs;
  List<AudioPlayerModel> newItem = [
    AudioPlayerModel(
        id: "1",
        artist: "Sabrina Carpenter",
        album: "Entertainment",
        title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
        url: "https://drive.usercontent.google.com/u/0/uc?id=1PggdOYJxkD5Rb23R3E48F8dDdOzH62ld&export=download",
        image: "https://img.freepik.com/free-photo/female-singer-portrait-neon-lights_155003-8240.jpg"
    ),
    AudioPlayerModel(
        id: "2",
        artist: "Sabrina Carpenter",
        album: "Entertainment",
        title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
        url: "https://drive.usercontent.google.com/u/0/uc?id=1uah5cRL4LxWSiNYeGfgC4i40mRW8hVgm&export=download",
        image: "https://img.freepik.com/free-photo/young-caucasian-female-musician-performer-singing-dancing-neon-light-gradient_155003-44185.jpg"
    ),
    AudioPlayerModel(
        id: "3",
        artist: "Morgan Walled",
        album: "Cubit Songs",
        title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
        url: "https://drive.usercontent.google.com/u/0/uc?id=1pJaX_zNFRA3IPjvU2OutmEijpwCqkWDI&export=download",
        image: "https://img.freepik.com/premium-photo/caucasian-female-singer-portrait-isolated-gradient-studio-background-neon-light_489646-16996.jpg"
    ),
    AudioPlayerModel(
        id: "4",
        artist: "Leroi Song",
        album: "Eminem",
        title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
        url: "https://drive.usercontent.google.com/u/0/uc?id=1CwdsEVSuVBsZuGtizMsBxdz8rpv86V8w&export=download",
        image: "https://img.freepik.com/premium-photo/image-caucasian-dark-haired-woman-wearing-stylish-jacket-standing-with-closed-eyes-listening-music-holding-cell-phone-as-microphone-singing-posing-isolated-neon-light-background_176532-19786.jpg"
    ),
    AudioPlayerModel(
        id: "5",
        artist: "Sabrina Carpenter",
        album: "Entertainment",
        title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
        url: "https://drive.usercontent.google.com/u/0/uc?id=1pVGY5C8cMZIdJKWhvnmt4dZi7HYoxdM3&export=download",
        image: "https://img.freepik.com/premium-photo/caucasian-female-singer-portrait-isolated-gradient-studio-background-neon-light_489646-16996.jpg"
    ),
  ];

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

  Future<void> playAudio(AudioPlayerModel model) async {
    if (currentMediaId.value == model.id) {
      print("Media ID ${model.id} is already playing");
      return;
    }

    currentMediaId.value = model.id;
    clickAudioPlayerData.value = model;
    isLoading.value = true;

    if (!await InternetConnection().hasInternetAccess) {
      print("Key No Internet Connection ===================================:Key ${model.id}");
      FileInfo? fileIInfo = await cacheManager.getFileFromCache(model.id);
      File? file = fileIInfo?.file;

      if(file != null){
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(file.path),
            tag: MediaItem(
              id: model.id,
              album: model.album,
              title: model.title,
              artist: model.artist,
              artUri: Uri.parse(model.image),
            ),
          ),
        ).then((value) async {
          isLoading.value = false;
          await play();
        }).catchError((e){
          isLoading.value = false;
        });
      }else{
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(model.url),
            tag: MediaItem(
              id: model.id,
              album: model.album,
              title: model.title,
              artist: model.artist,
              artUri: Uri.parse(model.image),
            ),
          ),
        ).then((value) async {
          isLoading.value = false;
          await play();
        }).catchError((e){
          isLoading.value = false;
        });
      }
    } else {
      final cacheFile = await cacheManager.getFileFromCache(model.id);
      final File? file = cacheFile?.file;
      if (file != null && file.path != "") {
        print("Key Has Internet And Get Cache===================================Url${file.path} :Key ${model.id}");
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(file.path),
            tag: MediaItem(
              id: model.id,
              album: model.album,
              title: model.title,
              artist: model.artist,
              artUri: Uri.parse(model.image),
            ),
          ),
        ).then((value) async {
          isLoading.value = false;
          await play();
        }).catchError((e){
          isLoading.value = false;
        });
      } else {
        print("Key Has Internet ===================================Url${file?.path} :Key ${model.id}");
        await cacheManager.getSingleFile(model.url,key: model.id);
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(model.url),
            tag: MediaItem(
              id: model.id,
              album: model.album,
              title: model.title,
              artist: model.artist,
              artUri: Uri.parse(model.image),
            ),
          ),
        ).then((value) async {
          isLoading.value = false;
          await play();
        }).catchError((e){
          isLoading.value = false;
        });
      }
    }
  }

  Future<void> play() async{
    await audioPlayer.play();
  }

  void pauseAudio() => audioPlayer.pause();
  void seekAudio(Duration position) => audioPlayer.seek(position);

  void skipBackward() {
    final newPosition = currentPosition.value - const Duration(seconds: 15);
    seekAudio(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void playNext() {
    print("Call play next===============================================");
    if (currentAudioIndex.value < newItem.length - 1) {
      currentAudioIndex.value++;
      playAudio(newItem[currentAudioIndex.value]);
    }else{
      currentAudioIndex.value==1;
      playAudio(newItem[0]);
    }
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
                          AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: clickAudioPlayerData.value,
                          );
                        },
                        child: SizedBox(
                          height: 60.h,
                          child: Obx(() {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0.r),
                              child: CachedNetworkImage(
                                imageUrl: clickAudioPlayerData.value.image,
                                placeholder: (context, data) =>
                                const SizedBox(),
                                errorWidget: (context, data, errorWidget) =>
                                const Icon(Icons.person),
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                        ),
                      ),
                      const Gap(5),
                      const Expanded(child: AudioPlayControl()),
                    ],
                  ),
                ),
                const Gap(1),
                GestureDetector(
                  onTap: removeOverlay,
                  child: Container(
                    width: 50,
                    height: 60,
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