import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import 'audio_record_screen.dart';
import 'live_streaming_screen.dart';
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
          return const LiveStreamingScreen();
        case SelectedAddPostScreenType.none:
          return Container();
      }
    });
  }
}
