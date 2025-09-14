/*
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/notification/model/notification_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class NotificationController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  bool isLoadingMove = false;

  Future<void> getNotification({
    required int pageKey,
    required PagingController<int, NotificationData> pagingController,
  }) async {
    if (isLoadingMove) return;
    isLoadingMove = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.notification(page: pageKey),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final userServiceAll = NotificationModel.fromJson(response.body);
        final newItems = userServiceAll.data?.notifications ?? [];
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
      isLoadingMove = false;
    }
  }
}
*/
