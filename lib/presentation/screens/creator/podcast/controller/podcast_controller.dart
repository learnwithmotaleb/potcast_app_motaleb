import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/model/global/categories_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:file_picker/file_picker.dart';

class PodcastController extends GetxController{
  ApiClient apiClient = ApiClient();
  Rx<CategoriesModel> categories = CategoriesModel().obs;
  RxList<SubCategory> subCategories = <SubCategory>[].obs;
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final Rx<File?> audioFile = Rx<File?>(null);
  RxString categoriesId = "".obs;
  RxString subCategoriesId = "".obs;

  Future<void> pickImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  Future<void> pickAudio() async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac', 'flac', 'opus', 'ogg', 'm4a'],
      );

      if (result != null) {
        audioFile.value = File(result.files.single.path!);
      }
    }catch(e){
      toastMessage(message: "audio pick error");
    }
  }

  RxString selectedCategory = "".obs;
  RxString selectedSubCategories = ''.obs;

  /// ============================= GET Profile Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  Future<void> getCategories() async {
    try {
      loadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.category(), showResult: true);

      if (response.statusCode == 200) {
        categories.value = CategoriesModel.fromJson(response.body);
        loadingMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          loadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          loadingMethod(Status.noDataFound);
        } else {
          loadingMethod(Status.error);
        }
      }
    } catch (e) {
      loadingMethod(Status.error);
    }
  }

  void updateSubCategories(String category) {
    subCategories.clear();
    selectedCategory.value = category;
    try {
      // Find the category that matches the selected title
      var categoryData = categories.value.data?.firstWhere((categoryItem) => categoryItem.title == category, orElse: () => CategoriesData());
      categoriesId.value = categoryData?.id??"";
      if (categoryData?.subCategories == null || categoryData!.subCategories!.isEmpty) {
        print("No subcategories found for the selected category.");
        subCategories.assignAll([]);
      } else {
        print("Subcategories found: ${categoryData.subCategories!}");
        subCategories.assignAll(categoryData.subCategories!);
      }

      print("Subcategories length: ${subCategories.length}");
    } catch (e) {
      print("Error updating subcategories: $e");
    }
  }


  /// ============================= Create Podcast =====================================
  RxBool createLoading = false.obs;
  createLoadingMethod(bool status) => createLoading.value = status;
  void createPodcast({required Map<String, String> body, required List<MultipartBody> multipartBody}) async {
    try{
      createLoadingMethod(true);
      var response = await apiClient.multipartRequest(url: ApiUrl.podcastCreate(),body: body, reqType: "POST", multipartBody: multipartBody);

      if (response.statusCode == 201 || response.statusCode == 200 ) {
        createLoadingMethod(false);
        AppRouter.route.pop();
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
