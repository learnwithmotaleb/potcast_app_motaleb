import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/model/basic/selected_location_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

import '../../../../../helper/function/file_upload.dart';

class PodcastAudioController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final Dio dio = serviceLocator<Dio>();

  /// ============================= Place Location Information =====================================
  Rx<SelectedLocationResult?> selectedAddress = Rx<SelectedLocationResult?>(null);
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedSubcategoryId = ''.obs;

  /// ============================= Image And Audio =====================================
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> audioFile = Rx<File?>(null);
  final Rx<File?> videoFile = Rx<File?>(null);

  Future<void> pickImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        toastMessage(message: "Cover Image not selected.");
      }
    } catch (e) {
      toastMessage(message: "Cover Image not selected for permission error.");
    }
  }

  Future<void> pickAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac', 'flac', 'opus', 'ogg', 'm4a'],
      );

      if (result != null) {
        File audio = File(result.files.single.path ?? "");
        audioFile.value = audio;
        await _audioPlayer.setSourceDeviceFile(audio.path);
        Duration? audioDuration = await _audioPlayer.getDuration();

        if (audioDuration != null) {
          if (audioDuration.inMinutes >= 10) {
            toastMessage(message: "Your audio file is too long. can not upload reels section");
          }
        }
      }
    } catch (e) {
      toastMessage(message: "Audio not selected for permission error.");
    }
  }

  Future<void> uploadAllFiles({
    required List<MultipartBody> selectedFiles,
    required Map<String, dynamic> body,
  }) async {
    createLoadingMethod(true);
    List<Future<void>> uploadTasks = selectedFiles.map((fileModel) async {
      final fileBytes = await fileModel.file.readAsBytes();
      final mimeType = lookupMimeType(fileModel.file.path) ?? 'application/octet-stream';
      final category = detectCategoryFromMime(mimeType);

      final preSignedUrl = await getPreSignedUrl(
        fileCategory: category,
        mimeType: mimeType,
        apiClient: apiClient,
      );

      if (preSignedUrl != null) {
        print("preSignedUrl ${preSignedUrl}");
        final uploadedUrl = await uploadFileToS3(
          fileBytes: fileBytes,
          uploadUrl: preSignedUrl,
          mimeType: mimeType,
          dio: dio,
          onProgress: (sent, total) {
            final percent = (sent / total * 100).toStringAsFixed(0);
            print("${fileModel.file.path} uploading... $percent%");
          },
        );

        if (uploadedUrl != null) {
          print("URL : $uploadedUrl");
          switch (category) {
            case 'podcast_cover':
              body['coverImage'] = uploadedUrl;
              break;
            case 'podcast_audio':
              body['audio_url'] = uploadedUrl;
              break;
            case 'podcast_video':
              body['video_url'] = uploadedUrl;
              break;
          }
        }
      }
    }).toList();

    await Future.wait(uploadTasks);
    createPodcast(body: body);
  }

  String detectCategoryFromMime(String mime) {
    if (mime.startsWith('image/')) return 'podcast_cover';
    if (mime.startsWith('audio/')) return 'podcast_audio';
    if (mime.startsWith('video/')) return 'podcast_video';
    return 'unknown';
  }

  /// ============================= Create Podcast =====================================
  RxBool createLoading = false.obs;

  createLoadingMethod(bool status) => createLoading.value = status;

  void createPodcast({required Map<String, dynamic> body}) async {
    try {

      print(body);
      var response = await apiClient.post(
        url: ApiUrl.podcastCreate(),
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        createLoadingMethod(false);
        audioFile.value = null;
        selectedImage.value = null;
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        createLoadingMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (_) {
      createLoadingMethod(false);
    }
  }
}
