import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({
    super.key,
    this.authToken,
    required this.roomCode,
    required this.userName,
    this.userID,
  });

  final String? authToken;
  final String roomCode;
  final String userName;
  final String? userID;

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  @override
  void initState() {
    super.initState();
    _stopAllAudio();
  }

  void _stopAllAudio() {
    try {
      final podcastController = Get.find<PodcastManuallyPlayController>();
      podcastController.pause();
      debugPrint('🛑 Stopped all audio for streaming session');
    } catch (e) {
      debugPrint('⚠️ Error stopping audio for streaming: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🎬 Joining HMS Room:");
    debugPrint("🔑 Room Code: '${widget.roomCode}'");
    debugPrint("👤 User Name: ${widget.userName}");
    debugPrint("🆔 User ID: ${widget.userID}");
    debugPrint("🌐 Auth Token: ${widget.authToken}");

    return Scaffold(
      body: HMSPrebuilt(
        roomCode: widget.roomCode.trim(),
        options: HMSPrebuiltOptions(
          userName: widget.userName,
          userId: widget.userID,
        ),
      ),
    );
  }
}
