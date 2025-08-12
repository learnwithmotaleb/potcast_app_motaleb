import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class UserHomeController extends GetxController {
  ApiClient apiClient = ApiClient();
  Rx<HomeModel> model = HomeModel().obs;
  RxBool isLocationSaveLoading = false.obs;

  /// ============================= Place Location Information =====================================
  void saveLocationAddress({required String address}) async {
    try {
      isLocationSaveLoading.value = true;
      final body = {"location": address};
      var response = await apiClient.post(
        url: ApiUrl.addLocation(),
        body: body,
        showResult: true,
      );

      if (response.statusCode == 200) {
        Get.find<UserHomeController>().getHome();
        isLocationSaveLoading.value = false;
        AppRouter.route.pop();
      } else {
        AppRouter.route.pop();
        isLocationSaveLoading.value = false;
      }
    } catch (err) {
      isLocationSaveLoading.value = false;
    }
  }

  /// ============================= GET Profile Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  Future<void> getHome() async {
    loadingMethod(Status.loading);
    var response = await apiClient.get(url: ApiUrl.home(), showResult: true);
    if (response.statusCode == 200) {
      model.value = HomeModel.fromJson(response.body);
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
  }

  @override
  void onReady() {
    getHome();
    super.onReady();
  }
}
