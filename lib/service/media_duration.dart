import 'dart:async';
import 'package:flutter/services.dart';

class MediaDuration {
  static const MethodChannel _channel =
  MethodChannel('com.podcast.media/duration');

  /// Returns a Map:
  /// {
  ///   "success": true/false,
  ///   "durationMillis": int,
  ///   "durationSeconds": double,
  ///   "durationString": "HH:MM:SS" or "MM:SS",
  ///   "error": "error message" // when success == false
  /// }

  static Future<Map<String, dynamic>> getMediaDuration(String path) async {
    if (path.isEmpty) {
      return {
        'success': false,
        'error': 'path is empty',
      };
    }

    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'getMediaDuration',
        {'path': path},
      );

      print(result.toString());
      if (result == null) {
        return {'success': false, 'error': 'null response from native'};
      }
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      return {'success': false, 'error': e.message ?? e.code};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
