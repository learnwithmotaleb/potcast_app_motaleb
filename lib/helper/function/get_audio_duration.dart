import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

final sharedPlayer = AudioPlayer();

Future<Duration?> getAudioDuration(File file) async {
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

    return duration;
  } catch (e) {
    debugPrint("Logger 3");
    debugPrint(e.toString());
    return null;
  } finally {
    await sharedPlayer.dispose();
  }
}