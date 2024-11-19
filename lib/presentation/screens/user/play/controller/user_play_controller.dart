import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast/model/route/audio_player_model.dart';

class UserPlayController extends GetxController{
  RxBool isLoading = false.obs;
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