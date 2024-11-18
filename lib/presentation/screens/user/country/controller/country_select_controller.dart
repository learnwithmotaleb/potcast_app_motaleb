import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';

class CountrySelectController extends GetxController{
  DBHelper dbHelper = serviceLocator();
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

  void saveLocation(int index){
    dbHelper.saveLocation(filteredList[index]).then((value) {
      toastMessage(message: "Location Selected");
      Get.find<UserHomeController>().findLocation();
      AppRouter.route.pop();
    }).onError((error, stack) {

    });
  }
}