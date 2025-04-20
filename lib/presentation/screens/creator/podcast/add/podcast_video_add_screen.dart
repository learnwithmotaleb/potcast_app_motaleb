import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PodcastVideoAddScreen extends StatefulWidget {
  const PodcastVideoAddScreen({super.key});

  @override
  State<PodcastVideoAddScreen> createState() => _PodcastVideoAddScreenState();
}

class _PodcastVideoAddScreenState extends State<PodcastVideoAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Video".tr),
      ),
    );
  }
}
