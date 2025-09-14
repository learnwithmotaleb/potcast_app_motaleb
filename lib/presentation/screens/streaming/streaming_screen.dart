import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';

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
