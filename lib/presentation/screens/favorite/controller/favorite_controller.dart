import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/presentation/screens/favorite/model/favorite_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class FavoriteController extends GetxController {
  ApiClient apiClient = ApiClient();

  final pagingController = PagingController<int, FavoriteItem>(firstPageKey: 1);
  bool isLoadingMove = false;
  RxList<FavoriteItem> lastTenItems = <FavoriteItem>[].obs;
  RxBool getLstLoading = false.obs;


  Future<void> getPodcast(int pageKey) async {
    if (isLoadingMove) return;
    isLoadingMove = true;

    try {
      final response = await apiClient.get(
          url: ApiUrl.favorite(page: pageKey), showResult: true);

      if (response.statusCode == 201) {
        final userServiceAll = FavoriteModel.fromJson(response.body);
        final newItems = userServiceAll.data?.result ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (_) {
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingMove = false;
    }
  }

  Future<void> getLastTenFavorites() async {
    if (getLstLoading.value) return;
    getLstLoading.value = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.favorite(page: 1),
        showResult: false,
      );

      if (response.statusCode == 201) {
        final favoriteModel = FavoriteModel.fromJson(response.body);
        final items = favoriteModel.data?.result ?? [];

        lastTenItems.assignAll(items.take(10).toList());
      }
    } catch (_) {

    } finally {
      getLstLoading.value = false;
    }
  }

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getPodcast(pageKey);
    });
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
