import 'package:get/get.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class UserHomeController extends GetxController {
  DBHelper dbHelper = DBHelper();
  RxString location = "".obs;

  Future<void> findLocation() async {
    location.value = await dbHelper.getLocation(AppConstants.location);
  }

  ApiClient apiClient = ApiClient();
  Rx<HomeModel> model = HomeModel().obs;

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
    findLocation();
    super.onReady();
  }
}
