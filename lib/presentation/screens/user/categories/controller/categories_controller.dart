import 'package:get/get.dart';
import 'package:podcast/presentation/screens/user/categories/model/search_category_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class CategoriesController extends GetxController{
  ApiClient apiClient = ApiClient();
  Rx<SearchCategoryModel> categoryModel = SearchCategoryModel().obs;
  RxList<SubCategory> subCategory = RxList<SubCategory>([]);

  RxBool isLoadingMove = false.obs;
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;

  Future<void> getAllSubCategories({required String id}) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;
    subCategory.clear();
    try {
      loadingMethod(Status.loading);
      final response = await apiClient.get(url: ApiUrl.subCategory(id: id, search: "all"), showResult: true);
      if (response.statusCode == 200) {
        categoryModel.value = SearchCategoryModel.fromJson(response.body);
        final newItems = categoryModel.value.data?.subCategories ?? [];
        if (newItems.isEmpty) {
          print(newItems.isNotEmpty);
          loadingMethod(Status.noDataFound);
        } else {
          subCategory.addAll(newItems);
          loadingMethod(Status.completed);
        }
      } else {
        loadingMethod(Status.error);
      }
    } catch (e) {
      loadingMethod(Status.error);
    } finally {
      isLoadingMove.value = false;
    }
  }

  var searchLoading = Status.completed.obs;
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
  }
}