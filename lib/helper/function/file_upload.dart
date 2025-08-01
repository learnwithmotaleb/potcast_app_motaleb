import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

Future<String?> getPreSignedUrl({
  required String fileCategory,
  required String mimeType,
  required ApiClient apiClient,
  required Dio dio,
}) async {
  final body = {
    "fileType": mimeType,
    "fileCategory": fileCategory,
  };

  final response = await apiClient.post(
    url: ApiUrl.generatePreSignedURL(),
    body: body,
  );

  if (response.statusCode == 200) {
    return response.body['uploadURL'];
  } else {
    print("Failed to get pre-signed URL: ${response.body}");
    return null;
  }
}

Future<String?> uploadFileToS3({
  required Uint8List fileBytes,
  required String uploadUrl,
  required String mimeType,
  required Dio dio,
  void Function(int, int)? onProgress,
}) async {
  try {
    final response = await dio.put(
      uploadUrl,
      data: Stream.fromIterable(fileBytes.map((e) => [e])),
      options: Options(
        headers: {"Content-Type": mimeType},
      ),
      onSendProgress: onProgress,
    );

    if (response.statusCode == 200) {
      return uploadUrl.split('?').first;
    } else {
      print("Upload failed: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Upload error: $e");
    return null;
  }
}
