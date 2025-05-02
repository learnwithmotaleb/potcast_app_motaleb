import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final controller = Get.find<PodcastAudioController>();
  final _controller = Get.find<ProfileController>();

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      body: Obx((){
        return HMSPrebuilt(
          roomCode: widget.authToken,
          authToken: ,
          onLeave: (){

          },
          options: HMSPrebuiltOptions(
              userName: _controller.profile.value.data?.name?? "User_${DateTime.now().millisecondsSinceEpoch}",
              enableNoiseCancellation: true,
              isNoiseSuppressionEnabled: true,
              isAutomaticGainControlEnabled: true,
              debugInfo: true
          ),
        );
      }),*/
    );
  }
}
