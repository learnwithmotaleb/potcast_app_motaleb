import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/categories_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class PodcastVideoController extends GetxController{
  final ApiClient apiClient = serviceLocator();

  final title = TextEditingController();
  final description = TextEditingController();

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


  /// ============================= Image And Audio =====================================
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final Rx<File?> videoFile = Rx<File?>(null);

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

  Future<void> pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      if (result != null) {
        File audio = File(result.files.single.path ?? "");
        videoFile.value = audio;
      }
    } catch (e) {
      toastMessage(message: "Audio not selected for permission error.");
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
        videoFile.value = null;
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
}