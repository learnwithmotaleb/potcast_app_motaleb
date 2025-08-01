import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/my_podcast_model.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/single_podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

class PodcastController extends GetxController{
/*  ApiClient apiClient = ApiClient();
  Rx<PodcastCategoriesModel> categories = PodcastCategoriesModel().obs;
  RxList<SubCategory> subCategories = <SubCategory>[].obs;
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final Rx<File?> audioFile = Rx<File?>(null);
  RxString categoriesId = "".obs;
  RxString subCategoriesId = "".obs;*/
  Rx<SelectedAddPostScreenType> selectedScreenType = SelectedAddPostScreenType.none.obs;
/*
  Future<void> pickImage() async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (image != null) {
        selectedImage.value = image;
      } else {
        toastMessage(message: "Cover Image not selected.");
      }
    } catch (e) {
      print(e.toString());
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
        File audio = File(result.files.single.path!);
        audioFile.value = audio;

        AudioPlayer audioPlayer = AudioPlayer();

        await audioPlayer.setSourceDeviceFile(audio.path);
        Duration? audioDuration = await audioPlayer.getDuration();

        if (audioDuration != null) {
          if (audioDuration.inMinutes >= 10) {
            toastMessage(message: "Your audio file is too long. can not upload reels section");
          }
        }
      }
    } catch (e) {
      print(e.toString());
      toastMessage(message: "Audio not selected for permission error.");
    }
  }


  RxString selectedCategory = "".obs;
  RxString selectedSubCategories = ''.obs;
  RxString responseMessage = "".obs;

  /// ============================= GET Categories =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  Future<void> getCategories() async {
    try {
      loadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.category(), showResult: true);

      if (response.statusCode == 200) {
        categories.value = PodcastCategoriesModel.fromJson(response.body);
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
      responseMessage.value = response.body?['message']??"Something wrong!";
    } catch (e) {
      loadingMethod(Status.error);
    }
  }


  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();

  /// ============================= GET Podcast =====================================
  Rx<SinglePodcastModel> postModel = SinglePodcastModel().obs;
  var podcastLoading = Status.completed.obs;
  podcastLoadingMethod(Status status) => podcastLoading.value = status;

  Future<void> getDetails({required String id}) async {
    try{
      podcastLoadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.details(id: id),showResult: true);
      if (response.statusCode == 200) {
        postModel.value = SinglePodcastModel.fromJson(response.body);
        title = TextEditingController(text: postModel.value.data?.title??"");
        location = TextEditingController(text: postModel.value.data?.location??"");
        description = TextEditingController(text: postModel.value.data?.description??"");
        print(response.body);
        print("Desc ${postModel.value.data?.description}");
        podcastLoadingMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          podcastLoadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          podcastLoadingMethod(Status.noDataFound);
        } else {
          podcastLoadingMethod(Status.error);
        }
      }
    }catch(e){
      podcastLoadingMethod(Status.error);
    }
  }

  void updateSubCategories(String category) {
    subCategories.clear();
    selectedCategory.value = category;
    try {

      var categoryData = categories.value.data?.firstWhere((categoryItem) => categoryItem.title == category, orElse: () => CategoriesData());
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

      print(response.body);
      print(response.statusCode);
      print(response.statusText);

      if (response.statusCode == 201 || response.statusCode == 200 ) {
        createLoadingMethod(false);
        AppRouter.route.goNamed(RoutePath.creatorNavScreen);
        pagingController.refresh();
        audioFile.value == null;
        selectedImage.value == null;
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        createLoadingMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    }catch (err){
      print(err);
      createLoadingMethod(false);
    }
  }

  /// ============================= Delete Podcast =====================================
  RxString deleteLoading = "".obs;

  void deletePodcast({required String id}) async {
    try{
      deleteLoading.value = id;
      var response = await apiClient.delete(url: ApiUrl.podcastDelete(id: id));

      if (response.statusCode == 200) {
        deleteLoading.value = "";
        pagingController.refresh();
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        deleteLoading.value = "";
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    }catch (err){
      deleteLoading.value = "";
    }
  }

  /// ============================= Edit Podcast =====================================
  RxBool editLoading = false.obs;
  editLoadingMethod(bool status) => editLoading.value = status;
  void editPodcast({required Map<String, String> body, required List<MultipartBody> multipartBody, required String id}) async {
    try{
      editLoadingMethod(true);
      var response = await apiClient.multipartRequest(url: ApiUrl.podcastEdit(id: id),body: body, reqType: "PUT", multipartBody: multipartBody);

      if (response.statusCode == 200 ) {
        editLoadingMethod(false);
        AppRouter.route.pop();
        pagingController.refresh();
        audioFile.value = null;
        selectedImage.value = null;
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        editLoadingMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    }catch (err){
      editLoadingMethod(false);
    }
  }

  void editPodcastOnlyBody({required Map<String, String> body, required String id}) async {
    try{
      editLoadingMethod(true);
      var response = await apiClient.put(url: ApiUrl.podcastEdit(id: id),body: body, showResult: true);

      if (response.statusCode == 200) {
        editLoadingMethod(false);
        AppRouter.route.pop();
        pagingController.refresh();
        audioFile.value = null;
        selectedImage.value = null;
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        editLoadingMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    }catch (err){
      editLoadingMethod(false);
    }
  }

  final PagingController<int, MyPodcastData> pagingController = PagingController(firstPageKey: 1);
  RxBool isLoadingMove = false.obs;
  Future<void> getPodcast(int pageKey) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.myPodcast(page: pageKey), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = MyPodcastModel.fromJson(response.body);
        final newItems = userServiceAll.data ?? [];
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
      isLoadingMove.value = false;
    }
  }


  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getPodcast(pageKey);
    });
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }*/
}

