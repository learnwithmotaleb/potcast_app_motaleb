import 'package:get/get.dart';

class NotificationController extends GetxController{
  RxBool isSelectedAll = true.obs;

  void updateSelectedTab(bool value){
    isSelectedAll.value = value;
  }
}
