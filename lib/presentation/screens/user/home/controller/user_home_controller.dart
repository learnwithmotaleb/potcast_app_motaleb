import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class UserHomeController extends GetxController {

  ApiClient apiClient = ApiClient();
  Rx<HomeModel> model = HomeModel().obs;
  Rx<LatLng> selectedPosition = const LatLng(23.8103, 90.4125).obs;
  RxString selectedAddress = "Please select your location".obs;
  RxBool isLocationSaveLoading = false.obs;

  Future<void> updatePosition(LatLng newPosition) async {
    selectedPosition.value = newPosition;
  }

  /// ============================= Place Location Information =====================================
  void saveLocationAddress({required LatLng location}) async {
    try {
      isLocationSaveLoading.value = true;
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      print(placeMarks.length);
      print(placeMarks.toString());

      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;

        // Try multiple fields in order: locality (city), subAdminArea, adminArea
        String? city = place.locality;
        if (city == null || city.isEmpty) city = place.subAdministrativeArea;
        if (city == null || city.isEmpty) city = place.administrativeArea;

        if (city != null && city.isNotEmpty) {
          print("Detected city: $city");
          selectedAddress.value = city;

          final body = {"location": city};
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
            selectedAddress.value = "no address found for the provided location".tr;
            isLocationSaveLoading.value = false;
          }
        } else {
          selectedAddress.value = "no address found for the provided location".tr;
          isLocationSaveLoading.value = false;
        }
      } else {
        selectedAddress.value = "no address found for the provided location".tr;
        isLocationSaveLoading.value = false;
      }
    } catch (err) {
      print(err.toString());
      isLocationSaveLoading.value = false;
      selectedAddress.value = "internet connection error";
    }
  }
/*
  /// ============================= Place Location Information =====================================
  void saveLocationAddress({required LatLng location}) async {
    try {
      isLocationSaveLoading.value = true;
      var response = await apiClient.get(url: ApiUrl.googleLetLongToAddressApi(location: location), isBasic: true, showResult: true);

      final data = response.body;
      if (response.statusCode == 200) {
        if (data['results'] != null && data['results'].isNotEmpty) {
          String address = data['results']?[0]?['formatted_address'] ?? "";
          selectedAddress.value = address;
          final body = {"location": address};
          var response = await apiClient.post(url: ApiUrl.addLocation(), body: body,showResult: true);
          if (response.statusCode == 200) {
            Get.find<UserHomeController>().getHome();
            isLocationSaveLoading.value = false;
            AppRouter.route.pop();
          } else {
            AppRouter.route.pop();
            selectedAddress.value = "no address found for the provided location".tr;
            isLocationSaveLoading.value = false;
          }
        } else {
          selectedAddress.value = "no address found for the provided location".tr;
          isLocationSaveLoading.value = false;
        }
      } else {
        if (response.statusCode == 503) {
          selectedAddress.value = "internet connection error";
          isLocationSaveLoading.value = false;
        } else {
          selectedAddress.value = "no address found for the provided location";
          isLocationSaveLoading.value = false;
        }
      }
    } catch (err) {
      isLocationSaveLoading.value = false;
      selectedAddress.value = "internet connection error";
    }
  }*/


  /// ============================= GET Profile Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  Future<void> getHome() async {
    try{
      loadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.home(),showResult: true);
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
    }catch(e){
      loadingMethod(Status.error);
    }
  }

  @override
  void onReady() {
    getHome();
    super.onReady();
  }
}
