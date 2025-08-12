/*
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class CategoryAllPodcastController extends GetxController{
  ApiClient apiClient = ApiClient();

  final PagingController<int, CategoryPodcast> pagingController = PagingController(firstPageKey: 1);
  RxBool isLoadingMove = false.obs;

  Future<void> getPodcast(int pageKey, String id) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.subCategoryPodcast(page: pageKey, id: id), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = SubCategoryPodcast.fromJson(response.body);
        final newItems = userServiceAll.data?.podcasts ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      print(e.toString());
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingMove.value = false;
    }
  }
}*/
