import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:podcast/core/route/routes.dart';

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
    print(widget.authToken);

    return Scaffold(
      body: HMSPrebuilt(
        roomCode: widget.roomCode,
        // authToken: widget.authToken,
        onLeave: (){
          AppRouter.route.pop();
        },
        options: HMSPrebuiltOptions(
          userName: widget.userName,
          userId: widget.userID,
        ),
      ),
    );
  }
}
