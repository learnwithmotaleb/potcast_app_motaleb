import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<Duration?> getAudioDuration(File file) async {
  final sharedPlayer = AudioPlayer();

  try {
    final audioSource = AudioSource.uri(
      Uri.file(file.path),
      tag: MediaItem(
        id: file.path,
        title: 'Temporary Audio',
      ),
    );

    await sharedPlayer.setAudioSource(audioSource);

    Duration? duration;
    int retryCount = 0;

    while (duration == null && retryCount < 30) {
      await Future.delayed(const Duration(milliseconds: 100));
      duration = sharedPlayer.duration;
      retryCount++;
    }
    await sharedPlayer.dispose();
    return duration;
  } catch (e) {
    debugPrint("Logger 3");
    debugPrint(e.toString());
    await sharedPlayer.dispose();
    return null;
  }
}
