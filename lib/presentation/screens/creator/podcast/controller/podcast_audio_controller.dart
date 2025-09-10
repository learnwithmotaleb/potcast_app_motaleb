import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/model/basic/selected_location_model.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/live_streaming_model.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/my_podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import '../../../../../helper/function/file_upload.dart';
import '../../nav/controller/creator_nav_controller.dart';
import '../model/live_records_model.dart';

class PodcastAudioController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final Dio dio = serviceLocator<Dio>();

  final Rx<SelectedAddPostScreenType> selectedScreenType = SelectedAddPostScreenType.none.obs;

  /// ============================= Place Location Information =====================================
  Rx<SelectedLocationResult?> selectedAddress = Rx<SelectedLocationResult?>(null);
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedSubcategoryId = ''.obs;

  /// ============================= Record Audio Information =====================================
  final RxBool isRecording = false.obs;
  final RxBool isPaused = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isPausePlaying = false.obs;
  final recordedFilePath = RxnString();

  /// ============================= Image And Audio =====================================
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> audioFile = Rx<File?>(null);
  final Rx<File?> videoFile = Rx<File?>(null);

  final RxDouble uploadProgress = 0.0.obs;
  final RxDouble uploadedMB = 0.0.obs;
  final RxDouble totalMB = 0.0.obs;

  Future<void> pickImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        toastMessage(message: "Cover Image not selected.");
      }
    } catch (_) {
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
    } catch (_) {
      toastMessage(message: "Audio not selected for permission error.");
    }
  }

  Future<void> pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      if (result != null) {
        File audio = File(result.files.single.path ?? "");
        videoFile.value = audio;
      }
    } catch (_) {
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
        final uploadedUrl = await uploadFileToS3(
          fileBytes: fileBytes,
          uploadUrl: preSignedUrl,
          mimeType: mimeType,
          dio: dio,
          onProgress: (int sent, int total) {
            final progress = sent / total;
            uploadProgress.value = progress;
            uploadedMB.value = sent / (1024 * 1024);
            totalMB.value = total / (1024 * 1024);
          },
        );

        if (uploadedUrl != null) {
          switch (category) {
            case 'podcast_cover':
              body['coverImage'] = uploadedUrl;
              break;
            case 'podcast_audio':
              body['podcast_url'] = uploadedUrl;
              break;
            case 'podcast_video':
              body['podcast_url'] = uploadedUrl;
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
    if (mime.startsWith('video/')) return 'podcast_video';
    if (mime.startsWith('audio/')) return 'podcast_audio';
    return 'unknown';
  }

  /// ============================= Create Podcast =====================================
  final RxBool createLoading = false.obs;

  void createLoadingMethod(bool status) => createLoading.value = status;

  void createPodcast({required Map<String, dynamic> body}) async {
    try {
      var response = await apiClient.post(
        url: ApiUrl.podcastCreate(),
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final navController = Get.find<CreatorNavController>();
        createLoadingMethod(false);
        audioFile.value = null;
        videoFile.value = null;
        selectedImage.value = null;
        navController.changeIndex(0);
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

  bool isLoadingMove = false;

  Future<void> getMyPodcast({
    required int pageKey,
    required PagingController<int, MyPodcastItem> pagingController,
  }) async {
    if (isLoadingMove) return;
    isLoadingMove = true;

    try {
      final response = await apiClient.get(url: ApiUrl.myPodcast(page: pageKey), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = MyPodcastModel.fromJson(response.body);
        final newItems = userServiceAll.data?.result ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      print(e.toString());
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingMove = false;
    }
  }

  Future<void> startRecording(
      PlayerController playerController, RecorderController recorderController) async {
    try {
      if (isPlaying.value || isPausePlaying.value) {
        await playerController.stopPlayer();
        isPlaying.value = false;
        isPausePlaying.value = false;
      }

      playerController.dispose();
      playerController = PlayerController();

      // Delete old file if exists
      final oldPath = recordedFilePath.value;
      if (oldPath != null) {
        final oldFile = File(oldPath);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      }

      final dir = await getTemporaryDirectory();
      recordedFilePath.value = "${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await recorderController.record(path: recordedFilePath.value);
      isRecording.value = true;
      isPaused.value = false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> pauseRecording(RecorderController recorderController) async {
    try {
      await recorderController.pause();
      isPaused.value = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> resumeRecording(RecorderController recorderController) async {
    try {
      await recorderController.record();
      isPaused.value = false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopRecording(RecorderController recorderController) async {
    try {
      await recorderController.stop();
      isRecording.value = false;
      isPaused.value = false;

      if (recordedFilePath.value != null && recordedFilePath.value!.isNotEmpty) {
        final file = File(recordedFilePath.value!);
        if (await file.exists()) {
          audioFile.value = file;
          debugPrint("🎙️ Recorded file saved to audioFile: ${file.path}");
        } else {
          debugPrint("⚠️ File does not exist at path: ${file.path}");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> playAudio(
    PlayerController playerController,
  ) async {
    try {
      final path = recordedFilePath.value;
      final file = File(path ?? "");

      if (file.existsSync()) {
        debugPrint("Playing: $path");
        await playerController.preparePlayer(path: path!, shouldExtractWaveform: true);

        await playerController.startPlayer();
        isPlaying.value = true;
      } else {
        debugPrint("File does not exist: $path");
      }
    } catch (e) {
      debugPrint("Playback error: $e");
    }
  }

  Future<void> pauseAudio(
    PlayerController playerController,
  ) async {
    try {
      await playerController.pausePlayer();
      isPausePlaying.value = true;
    } catch (e) {
      debugPrint("Pause error: $e");
    }
  }

  Future<void> resumeAudio(
    PlayerController playerController,
  ) async {
    try {
      await playerController.startPlayer();
      isPausePlaying.value = false;
    } catch (e) {
      debugPrint("Resume error: $e");
    }
  }

  Future<void> stopAudio(
    PlayerController playerController,
  ) async {
    try {
      await playerController.stopPlayer();
      isPlaying.value = false;
    } catch (e) {
      debugPrint("Stop error: $e");
    }
  }

  final Rx<LiveStreamingModel> liveData = LiveStreamingModel().obs;
  final RxBool createLiveLoading = false.obs;
  void createLiveMethod(bool status) => createLiveLoading.value = status;
  final RxBool getLiveLoading = false.obs;
  void getLiveMethod(bool status) => getLiveLoading.value = status;
  final RxBool endLiveLoading = false.obs;
  void endLiveMethod(bool status) => endLiveLoading.value = status;

  Future<void> createLive() async {
    try {
      createLiveMethod(true);
      var response = await apiClient.post(
        url: ApiUrl.createLive(),
        body: {},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = LiveStreamingModel.fromJson(response.body);
        liveData.value = data;
        createLiveMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        createLiveMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (_) {
      createLiveMethod(false);
    }
  }

  Future<void> getLive() async {
    try {
      getLiveMethod(true);
      var response = await apiClient.get(
        url: ApiUrl.getLive(),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final data = LiveStreamingModel.fromJson(response.body);
        liveData.value = data;
        getLiveMethod(false);
      } else {
        getLiveMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (_) {
      getLiveMethod(false);
    }
  }

  Future<void> endLive({required String id}) async {
    try {
      endLiveMethod(true);
      var response = await apiClient.post(
        url: ApiUrl.endLive(id: id),
        body: {}
      );

      if (response.statusCode == 200) {
        endLiveMethod(false);
        await getLive();
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        endLiveMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (_) {
      endLiveMethod(false);
    }
  }

  bool isLoadingRecords = false;

  Future<void> getAllRecords({
    required int pageKey,
    required PagingController<int, LiveRecordItem> pagingController,
  }) async {
    if (isLoadingRecords) return;
    isLoadingRecords = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.liveRecordings(page: pageKey),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final records = LiveRecordsModel.fromJson(response.body);
        final newItems = records.data?.result ?? [];

        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingRecords = false;
    }
  }

  final RxBool toggleLoading = false.obs;
  void toggleLiveMethod(bool status) => toggleLoading.value = status;
  final RxBool deleteRecordLoading = false.obs;
  void deleteRecordMethod(bool status) => deleteRecordLoading.value = status;
  final RxBool addInfoLoading = false.obs;
  void addRecordMethod(bool status) => addInfoLoading.value = status;

  Future<void> toggleRecord({required String id, required PagingController<int, LiveRecordItem> pagingController,}) async {
    try {
      toggleLiveMethod(true);
      var response = await apiClient.patch(
          url: ApiUrl.toggleRecord(id: id),
          body: {}
      );

      if (response.statusCode == 200) {
        toggleLiveMethod(false);

        final data = response.body?['data']?["isPublic"];

        if (data != null && data is bool) {

          final items = pagingController.itemList ?? [];
          final index = items.indexWhere((item) => item.id == id);

          if (index != -1) {
            items[index] = items[index].copyWith(
              isPublic: data,
            );
            pagingController.itemList = List.from(items);
          }
        }

      } else {
        toggleLiveMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (_) {
      toggleLiveMethod(false);
    }
  }


  Future<void> endRecord({required String id, required PagingController<int, LiveRecordItem> pagingController,}) async {
    try {
      deleteRecordMethod(true);
      var response = await apiClient.patch(
          url: ApiUrl.deleteRecord(id: id),
          body: {}
      );

      if (response.statusCode == 200) {
        deleteRecordMethod(false);
        final items = pagingController.itemList ?? [];
        items.removeWhere((item) => item.id == id);
        pagingController.itemList = List.from(items);
      } else {
        deleteRecordMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (_) {
      deleteRecordMethod(false);
    }
  }


  Future<void> addRecordInfo({required String id, required Map<String, String> body, required String file, required PagingController<int, LiveRecordItem> pagingController,}) async {
    try {
      addRecordMethod(true);
      var response = await apiClient.multipartRequest(
          url: ApiUrl.updateInfo(id: id),
          reqType: "PATCH",
          multipartBody: [
            MultipartBody("liveCover", File(file)),
          ],
          body: body,
      );

      if (response.statusCode == 200) {
        addRecordMethod(false);

      } else {
        addRecordMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (_) {
      addRecordMethod(false);
    }
  }
}
