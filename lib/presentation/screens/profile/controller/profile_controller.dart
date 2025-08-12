import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/profile/model/profile_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class ProfileController extends GetxController {
  ApiClient apiClient = ApiClient();
  final ImagePicker _picker = ImagePicker();
  Rx<ProfileModel> profile = ProfileModel().obs;
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  Rx<XFile?> selectedCoverImage = Rx<XFile?>(null);
  RxString gender = "".obs;

  Future<void> pickImage() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  Future<void> pickCoverImage() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      selectedCoverImage.value = image;
    }
  }

  void updateGender({required String value}) {
    gender.value = value;
  }

  /// ============================= GET Profile Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  Future<void> getProfile() async {
    try {
      loadingMethod(Status.loading);
      var response =
          await apiClient.get(url: ApiUrl.profile(), showResult: true);
      if (response.statusCode == 200) {
        profile.value = ProfileModel.fromJson(response.body);
        loadingMethod(Status.completed);
        /*if(profile.value.data?.gender != null && profile.value.data?.gender != ""){
          gender.value = profile.value.data?.gender??"male";
        }*/
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

  /// ============================= EDIT Profile Info =====================================
  RxBool editLoading = false.obs;
  editLoadingMethod(bool status) => editLoading.value = status;

  void editProfile({required Map<String, String> body}) async {
    try {
      editLoadingMethod(true);
      final List<MultipartBody> multipartBody = [];
      if (selectedImage.value != null) {
        multipartBody.add(MultipartBody(
            "profile_image", File(selectedImage.value?.path ?? "")));
      }
      if (selectedCoverImage.value != null) {
        multipartBody.add(MultipartBody(
            "profile_cover", File(selectedCoverImage.value?.path ?? "")));
      }
      var response = await apiClient.multipartRequest(
          url: ApiUrl.profileEdit(),
          body: body,
          reqType: "PATCH",
          multipartBody: multipartBody);

      if (response.statusCode == 200) {
        editLoadingMethod(false);
        AppRouter.route.pop();
        selectedImage.value = null;
        selectedCoverImage.value = null;
        getProfile();
      } else {
        editLoadingMethod(false);
        String errorMessage =
            response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (err) {
      editLoadingMethod(false);
    }
  }

  /// ============================= EDIT Profile Info =====================================
  void editProfileOnlyBody({required Map<String, String> body}) async {
    try {
      editLoadingMethod(true);
      var response = await apiClient.patch(
          url: ApiUrl.profileEdit(), body: body, showResult: true);

      if (response.statusCode == 200) {
        editLoadingMethod(false);
        AppRouter.route.pop();
        getProfile();
      } else {
        editLoadingMethod(false);
        String errorMessage =
            response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (err) {
      editLoadingMethod(false);
    }
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }
}
