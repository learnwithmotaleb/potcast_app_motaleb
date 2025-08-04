import 'package:get/get.dart';

class CreatorNavController extends GetxController{
  final RxInt selectedPage = 0.obs;

  void changeIndex(int index){
    selectedPage.value = index;
  }
}