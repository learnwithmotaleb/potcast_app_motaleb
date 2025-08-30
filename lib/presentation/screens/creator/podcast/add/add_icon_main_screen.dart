import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/screens/streaming/streaming_screen.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import 'audio_record_screen.dart';
import 'go_live_screen.dart';
import 'podcast_add_screen.dart';
import 'podcast_video_add_screen.dart';

class AddIconMainScreen extends StatefulWidget {
  const AddIconMainScreen({super.key});

  @override
  State<AddIconMainScreen> createState() => _AddIconMainScreenState();
}

class _AddIconMainScreenState extends State<AddIconMainScreen> {
  final controller = Get.find<PodcastAudioController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.selectedScreenType.value) {
        case SelectedAddPostScreenType.audio:
          return const PodcastAudioScreen();
        case SelectedAddPostScreenType.video:
          return const PodcastVideoAddScreen();
        case SelectedAddPostScreenType.record:
          return const AudioRecordScreen();
        case SelectedAddPostScreenType.live:
          return const StreamingScreen(
            authToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3Nfa2V5IjoiNjdlYzBiM2EzM2NlNzRhYjliZTk1YTUyIiwicm9vbV9pZCI6IjY4YjAxZTZiMjUyZDdiNTJjNTFiNzM4MCIsInVzZXJfaWQiOiI2ODhmMzgxMDY4YWMwODM1ODVmZGIxOGYiLCJyb2xlIjoiaG9zdCIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoyLCJqdGkiOiIzZmM0MDcxNy1lMzFkLTRlYmItYTMzZi04ZjA4ZWViZTg5MzciLCJpYXQiOjE3NTYzNzI1ODQsImV4cCI6MTc1NjQ1ODk4NH0.2nIYh1FeaxbbDrlqKsiC5S8NVGpYmiTOGlK2Cr3rQW8",
            roomCode: "68b01e6b252d7b52c51b7380",
            userName: "SRABON DEV",
            userID: "65142651415416514654154153",
          );
        case SelectedAddPostScreenType.none:
          return Container();
      }
    });
  }
}
