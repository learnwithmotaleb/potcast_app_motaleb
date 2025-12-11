import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/model/google_search_location_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class SearchMyLocationController extends GetxController {
  final ApiClient apiClient = serviceLocator();

  /// ============================= Search Location By Google =====================================
  RxBool isDirection = false.obs;
  final Rx<Status> searchLoading = Status.completed.obs;
  searchLoadingMethod(Status status) => searchLoading.value = status;
  RxList<Prediction> addressList = <Prediction>[].obs;
  final searchText = TextEditingController();

  void searchLocationByGoogle({required BuildContext context}) async {
    if (isDirection.value) return;
    isDirection.value = true;

    try {
      searchLoadingMethod(Status.loading);

      var response = await apiClient.get(
          url: ApiUrl.googleSearchApi(search: searchText.text),
          isBasic: true,
          showResult: true);

      if (response.statusCode == 200) {
        addressList.value = List<Prediction>.from(
            response.body["predictions"].map((x) => Prediction.fromJson(x)));
        searchLoadingMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          searchLoadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          searchLoadingMethod(Status.noDataFound);
        } else {
          searchLoadingMethod(Status.error);
        }
      }
    } catch (err) {
      searchLoadingMethod(Status.error);
    } finally {
      isDirection.value = false;
    }
  }

  /// ============================= Search Location By Google =====================================
  bool isPlaceToLatLng = false;

  Future<LatLng?> placeIdToLatLng({required String placeId}) async {
    if (isPlaceToLatLng || placeId.isEmpty) {
      debugPrint("⚠️ Skipped placeIdToLatLng call: already loading or placeId is empty");
      return null;
    }

    isPlaceToLatLng = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.placeIdToLatLng(placeId: placeId),
        isBasic: true,
        showResult: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.body;

        if (data['status'] != 'OK') {
          debugPrint("❌ Google API error: ${data['status']}");
          return null;
        }

        final location = data['result']?['geometry']?['location'];

        if (location == null ||
            location['lat'] == null ||
            location['lng'] == null) {
          debugPrint("❌ Location data is missing in API response");
          return null;
        }

        final double lat = (location['lat'] as num).toDouble();
        final double lng = (location['lng'] as num).toDouble();

        debugPrint("✅ LatLng parsed successfully: ($lat, $lng)");
        return LatLng(lat, lng);
      } else {
        debugPrint(
            "❌ HTTP Error: ${response.statusCode} - ${response.statusText}");
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint("🔥 Exception in placeIdToLatLng: $e");
      debugPrintStack(stackTrace: stackTrace);
      return null;
    } finally {
      isPlaceToLatLng = false;
    }
  }
}
