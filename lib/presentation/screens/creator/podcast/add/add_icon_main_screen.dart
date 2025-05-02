import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_controller.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import 'add_podcast_design_none.dart';
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
  final controller = Get.find<PodcastController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch(controller.selectedScreenType.value){
        case SelectedAddPostScreenType.audio:
          return const PodcastAudioScreen();
        case SelectedAddPostScreenType.video:
          return const PodcastVideoAddScreen();
        case SelectedAddPostScreenType.record:
          return const AudioRecordScreen();
        case SelectedAddPostScreenType.live:
          return const GoLiveScreen();
        case SelectedAddPostScreenType.none:
          return const AddPodcastNoneDesign();
      }
    });
  }
}
