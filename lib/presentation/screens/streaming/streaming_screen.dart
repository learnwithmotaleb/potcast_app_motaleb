import 'package:flutter/material.dart';
import 'package:hms_room_kit_fixed/hms_room_kit_fixed.dart';

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
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        body: HMSPrebuilt(
          roomCode: widget.roomCode,
          options: HMSPrebuiltOptions(
            userName: widget.userName,
            userId: widget.userID,
          ),
        ),
      ),
    );
  }
}
