import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/model/global_search_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class SearchScreenController extends GetxController {
  ApiClient apiClient = ApiClient();
  RxString search = "".obs;
  RxBool isLoadingMove = false.obs;

  Future<void> getGlobalSearch({
    required int pageKey,
    required PagingController<int, GlobalSearchResultItem> pagingController,
  }) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.globalSearch(
          pageKey: pageKey.toString(),
          searchTerm: search.value,
        ),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final model = GlobalSearchModel.fromJson(response.body);
        final newItems = model.data?.data ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      debugPrint(e.toString());
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingMove.value = false;
    }
  }

  Future<void> getPodcastSearch({
    required int pageKey,
    required PagingController<int, AllPodcastItem> pagingController,
    bool? reels,
    bool? popular,
  }) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.search(
          pageKey: pageKey.toString(),
          searchTerm: search.value,
          reels: reels,
          popular: popular,
        ),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final userServiceAll = AllPodcastModel.fromJson(response.body);
        final newItems = userServiceAll.data?.result ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
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

  void updateSearch({
    required String value,
    PagingController? controller,
    List<PagingController>? controllers,
  }) {
    search.value = value;
    if (controller != null) {
      controller.refresh();
    }
    if (controllers != null) {
      for (var ctrl in controllers) {
        ctrl.refresh();
      }
    }
  }
}
