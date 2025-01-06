import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class CountrySelectController extends GetxController {
  ApiClient apiClient = ApiClient();
  final List<String> locationList = [
    "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Idaho",
    "Illinois",
    "Indiana",
    "Iowa",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Maine",
    "Maryland",
    "Massachusetts",
    "Michigan",
    "Minnesota",
  ];

  RxList<String> filteredList = RxList([]);

  @override
  void onInit() {
    super.onInit();
    filteredList.value = List.from(locationList);
  }

  void filterLocations(String query) {
    if (query.isEmpty) {
      filteredList.value = List.from(locationList);
    } else {
      filteredList.value = locationList.where((location) => location.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  /// ============================= Add Location =====================================

  void saveLocation({required int index, required BuildContext context}) async {
    try {
      showPopUpLoader(context: context);
      final body = {"location": filteredList[index]};

      var response = await apiClient.post(url: ApiUrl.addLocation(), body: body,showResult: true);

      if (response.statusCode == 200) {
        AppRouter.route.pop();
        AppRouter.route.pop();
        Get.find<UserHomeController>().getHome();
      } else {
        AppRouter.route.pop();
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (err) {
      AppRouter.route.pop();
    }
  }

  showPopUpLoader({required BuildContext context}) {
    return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) => const SizedBox(
        height: 70,
        child: AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
