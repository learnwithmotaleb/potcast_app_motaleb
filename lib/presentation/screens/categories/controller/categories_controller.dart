import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/categories/model/sub_category_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class CategoriesController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final Rx<SubCategoryModel> categoryModel = SubCategoryModel().obs;

  bool isLoadingMove = false;
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;

  Future<void> getAllSubCategories({required String id}) async {
    if (isLoadingMove) return;
    isLoadingMove = true;

    try {
      loadingMethod(Status.loading);
      final response = await apiClient.get(
          url: ApiUrl.subCategory(id: id), showResult: true);
      if (response.statusCode == 200) {
        categoryModel.value = SubCategoryModel.fromJson(response.body);
        final newItems = categoryModel.value.data ?? [];
        if (newItems.isEmpty) {
          loadingMethod(Status.noDataFound);
        } else {
          loadingMethod(Status.completed);
        }
      } else {
        loadingMethod(Status.error);
      }
    } catch (e) {
      loadingMethod(Status.error);
    } finally {
      isLoadingMove = false;
    }
  }

/*  var searchLoading = Status.completed.obs;
  searchLoadingMethod(Status status) => searchLoading.value = status;

  Future<void> getSearch({required String id, required String search}) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;
    subCategory.clear();
    try {
      searchLoadingMethod(Status.loading);
      final response = await apiClient.get(url: ApiUrl.subCategory(id: id, search: search), showResult: true);
      if (response.statusCode == 200) {
        final data = SearchCategoryModel.fromJson(response.body);
        final newItems = data.data?.subCategories ?? [];
        if (newItems.isEmpty) {
          searchLoadingMethod(Status.noDataFound);
        } else {
          subCategory.addAll(newItems);
          searchLoadingMethod(Status.completed);
        }
      } else {
        searchLoadingMethod(Status.error);
      }
    } catch (e) {
      searchLoadingMethod(Status.error);
    } finally {
      isLoadingMove.value = false;
    }
  }*/
}
