/*
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/categories_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class PodcastRecordController extends GetxController{
  final ApiClient apiClient = serviceLocator();
  final recorderController = RecorderController();
  PlayerController playerController = PlayerController();
  RxBool isRecording = false.obs;
  RxBool isPaused = false.obs;
  RxBool isPlaying = false.obs;
  RxBool isPausePlaying = false.obs;
  final recordedFilePath = RxnString();

  final title = TextEditingController();
  final description = TextEditingController();
  final tag = TextEditingController();

  /// ============================= Image And Audio =====================================
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final Rx<File?> audioFile = Rx<File?>(null);

  Future<void> pickImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = image;
      } else {
        toastMessage(message: "Cover Image not selected.");
      }
    } catch (e) {
      toastMessage(message: "Cover Image not selected for permission error.");
    }
  }

  Future<void> startRecording() async {
    try{

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
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> pauseRecording() async {
    try{
      await recorderController.pause();
      isPaused.value = true;
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> resumeRecording() async {
    try{
      await recorderController.record();
      isPaused.value = false;
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> stopRecording() async {
    try{
      await recorderController.stop();
      isRecording.value = false;
      isPaused.value = false;
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> playAudio() async {
    try {
      final path = recordedFilePath.value;
      final file = File(path ?? "");

      if (file.existsSync()) {
        print("Playing: $path");
        await playerController.preparePlayer(path: path!, shouldExtractWaveform: true);

        await playerController.startPlayer();
        isPlaying.value = true;
      } else {
        print("File does not exist: $path");
      }
    } catch (e) {
      print("Playback error: $e");
    }
  }

  Future<void> pauseAudio() async {
    try {
      await playerController.pausePlayer();
      isPausePlaying.value = true;
    } catch (e) {
      print("Pause error: $e");
    }
  }

  Future<void> resumeAudio() async {
    try {
      await playerController.startPlayer();
      isPausePlaying.value = false;
    } catch (e) {
      print("Resume error: $e");
    }
  }

  Future<void> stopAudio() async {
    try {
      await playerController.stopPlayer();
      isPlaying.value = false;
    } catch (e) {
      print("Stop error: $e");
    }
  }

  @override
  void onClose() {
    recorderController.dispose();
    playerController.dispose();
    super.onClose();
  }


  /// ============================= Place Location Information =====================================
  RxString selectedAddress = "Please select your location".obs;

  /// ============================= Category =====================================
  RxList<SubCategory> subCategories = <SubCategory>[].obs;
  RxString selectedCategory = "".obs;
  RxString selectedSubCategories = ''.obs;
  RxString categoriesId = "".obs;
  RxString subCategoriesId = "".obs;

  void updateSubCategories(String category, PodcastCategoriesModel categories) {
    subCategories.clear();
    selectedCategory.value = category;
    try {
      var categoryData = categories.data?.firstWhere((categoryItem) => categoryItem.title == category, orElse: () => CategoriesData());
      categoriesId.value = categoryData?.id??"";
      if (categoryData?.subCategories == null || categoryData!.subCategories!.isEmpty) {
        subCategories.assignAll([]);
      } else {
        subCategories.assignAll(categoryData.subCategories!);
      }
    } catch (e) {
      log("Error updating subcategories: $e");
    }
  }

  /// ============================= Create Podcast =====================================
  RxBool createLoading = false.obs;
  createLoadingMethod(bool status) => createLoading.value = status;
  void createPodcast({required Map<String, String> body, required List<MultipartBody> multipartBody}) async {
    try{
      createLoadingMethod(true);
      var response = await apiClient.multipartRequest(
        url: ApiUrl.podcastCreate(),
        body: body,
        reqType: "POST",
        multipartBody: multipartBody,
        onProgress: (progress) {
          print("Upload progress: ${(progress * 100).toStringAsFixed(2)}%");
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200 ) {
        createLoadingMethod(false);
        audioFile.value = null;
        selectedImage.value = null;
        title.clear();
        description.clear();
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        createLoadingMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    }catch (err){
      createLoadingMethod(false);
    }
  }
}*/
