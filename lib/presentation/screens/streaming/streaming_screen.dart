import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import '../play/controller/podcast_play_controller.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({
    super.key,
    this.authToken,
    required this.roomCode,
    required this.userName,
    required this.userID,
  });

  final String? authToken;
  final String roomCode;
  final String userName;
  final String userID;

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  @override
  void initState() {
    super.initState();
    _stopAllAudio();
  }

  /// Stop all audio playback when entering streaming
  void _stopAllAudio() {
    try {
      final podcastController = Get.find<PodcastFeedController>();
      podcastController.stopAudioOnAppClose();
      debugPrint('🛑 Stopped all audio for streaming session');
    } catch (e) {
      debugPrint('⚠️ Error stopping audio for streaming: $e');
      // Controller might not exist, which is fine
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.roomCode);
    return Scaffold(
      body: HMSPrebuilt(
        roomCode: widget.roomCode,
        options: HMSPrebuiltOptions(
          userName: widget.userName,
          userId: widget.userID,
        ),
      ),
    );
  }
}
