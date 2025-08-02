import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/model/google_search_location_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class SearchMyLocationController extends GetxController{
  final ApiClient apiClient = serviceLocator();
  /// ============================= Search Location By Google =====================================
  RxBool isDirection = false.obs;
  var searchLoading = Status.completed.obs;
  searchLoadingMethod(Status status) => searchLoading.value = status;
  RxList<Prediction> addressList = <Prediction>[].obs;
  final searchText = TextEditingController();

  void searchLocationByGoogle({required BuildContext context}) async {
    if (isDirection.value) return;
    isDirection.value = true;

    try{
      searchLoadingMethod(Status.loading);

      var response = await apiClient.get(url: ApiUrl.googleSearchApi(search: searchText.text),isBasic: true,showResult: true);

      if (response.statusCode == 200) {
        addressList.value = List<Prediction>.from(response.body["predictions"].map((x) => Prediction.fromJson(x)));
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
    }catch (err){
      searchLoadingMethod(Status.error);
    }finally{
      isDirection.value = false;
    }
  }

  /// ============================= Search Location By Google =====================================
  bool isPlaceToLatLng = false;

  Future<LatLng?> placeIdToLatLng({required String placeId}) async {
    if (isPlaceToLatLng || placeId.isEmpty) return null;
    isPlaceToLatLng = true;

    try{
      var response = await apiClient.get(url: ApiUrl.placeIdToLatLng(placeId: placeId), isBasic: true, showResult: true);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']?['geometry']?['location'];
        if (location != null) {
          final double lat = location['lat'];
          final double lng = location['lng'];
          return LatLng(lat, lng);
        } else {
          return null;
        }
      } else {
        return null;
      }
    }catch (_){
      return null;
    }finally{
      isPlaceToLatLng = false;
    }
  }


}