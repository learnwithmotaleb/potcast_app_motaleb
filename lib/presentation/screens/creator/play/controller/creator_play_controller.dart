import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/model/route/audio_player_model.dart';

class CreatorPlayController extends GetxController{
  RxBool isLoading = false.obs;
  Rx<AudioPlayerModel> clickAudioPlayerData = AudioPlayerModel(id: "", url: "", title: "", album: "", image: "", artist: "").obs;
  final audioPlayer = AudioPlayer();

  // Observables
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    audioPlayer.positionStream.listen((pos) {
      currentPosition.value = pos;
    });

    audioPlayer.durationStream.listen((dur) {
      if (dur != null) totalDuration.value = dur;
    });
  }

  Future<void> playAudio(AudioPlayerModel model) async {
    clickAudioPlayerData.value = model;
    isLoading.value = true; // Start loading
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

  Future<void> play() async{
    await audioPlayer.play();
  }

  void pauseAudio() => audioPlayer.pause();
  void seekAudio(Duration position) => audioPlayer.seek(position);

  void skipForward() {
    final newPosition = currentPosition.value + const Duration(seconds: 15);
    seekAudio(newPosition > totalDuration.value ? totalDuration.value : newPosition);
  }

  void skipBackward() {
    final newPosition = currentPosition.value - const Duration(seconds: 15);
    seekAudio(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}