import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/presentation/screens/history/model/history_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class HistoryController extends GetxController {
  ApiClient apiClient = ApiClient();

  final PagingController<int, HistoryItem> pagingController =
      PagingController(firstPageKey: 1);
  RxBool isLoadingMove = false.obs;

  Future<void> getPodcast(int pageKey) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(
          url: ApiUrl.history(page: pageKey), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = HistoryModel.fromJson(response.body);
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
      debugPrint(e.toString());
      pagingController.error = e.toString();
    } finally {
      isLoadingMove.value = false;
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
