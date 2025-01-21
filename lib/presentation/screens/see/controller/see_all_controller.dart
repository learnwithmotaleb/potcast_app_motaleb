import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/presentation/screens/see/model/see_all_model.dart';
import 'package:podcast/presentation/screens/see/model/top_creator_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class SeeAllController extends GetxController{
  ApiClient apiClient = ApiClient();

  final PagingController<int, SeeAllPodcast> pagingController = PagingController(firstPageKey: 1);
  RxBool isLoadingMove = false.obs;

  Future<void> getPodcast(int pageKey, String type) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.seeAll(page: pageKey, type: type), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = SeeAllModel.fromJson(response.body);
        final newItems = userServiceAll.data ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + newItems.length);
        }
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingMove.value = false;
    }
  }

  final PagingController<int, CreatorData> pagingCreatorController = PagingController(firstPageKey: 1);
  RxBool isLoadingCreatorMove = false.obs;

  Future<void> getTopCreator(int pageKey) async {
    if (isLoadingCreatorMove.value) return;
    isLoadingCreatorMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.seeAllTopCreator(page: pageKey), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = TopCreatorModel.fromJson(response.body);
        final newItems = userServiceAll.data ?? [];
        if (newItems.isEmpty) {
          pagingCreatorController.appendLastPage(newItems);
        } else {
          pagingCreatorController.appendPage(newItems, pageKey + newItems.length);
        }
      } else {
        pagingCreatorController.error = 'Error fetching data';
      }
    } catch (e) {
      pagingCreatorController.error = 'An error occurred';
    } finally {
      isLoadingCreatorMove.value = false;
    }
  }

  @override
  void onInit() {
    pagingCreatorController.addPageRequestListener((pageKey) {
      getTopCreator(pageKey);
    });
    super.onInit();
  }
}