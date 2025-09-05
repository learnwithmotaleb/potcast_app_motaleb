import 'package:flutter/material.dart';
import 'package:podcast/presentation/screens/streaming/streaming_screen.dart';

class LiveStreamingScreen extends StatefulWidget {
  const LiveStreamingScreen({super.key});

  @override
  State<LiveStreamingScreen> createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Live"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const StreamingScreen(
                  authToken: "",
                  roomCode: "lgi-htca-lgi",
                  userName: "SRABON Part",
                  userID: "65142651415416514654154153",
                )));
              },
              child: const Text("Join"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const StreamingScreen(
                  authToken: "",
                  roomCode: "hhj-nopm-xhs",
                  userName: "SRABON Dev",
                  userID: "6514265141541651465412334",
                )));
              },
              child: const Text("Join Admin"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const StreamingScreen(
                  authToken: "",
                  roomCode: "wuz-qchr-dng",
                  userName: "SRABON Host",
                  userID: "6514265141541651465ddd",
                )));
              },
              child: const Text("Join Host"),
            ),
          ],
        ),
      ),
    );
  }
}
