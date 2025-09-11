import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import '../model/categories_subcategories_model.dart';

class GlobalController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  /// ============================= GET Categories =====================================
  final Rx<Status> loading = Status.completed.obs;
  void loadingMethod(Status status) => loading.value = status;

  final Rx<CategoriesSubcategoriesModel> categories = CategoriesSubcategoriesModel().obs;

  Future<void> getCategories() async {
    try {
      loadingMethod(Status.loading);
      var response = await apiClient.get(
        url: ApiUrl.category(),
        showResult: true,
      );

      if (response.statusCode == 200) {
        categories.value = CategoriesSubcategoriesModel.fromJson(response.body);
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
    } catch (_) {
      loadingMethod(Status.error);
    }
  }

  @override
  void onReady() {
    getCategories();
    super.onReady();
  }
}
