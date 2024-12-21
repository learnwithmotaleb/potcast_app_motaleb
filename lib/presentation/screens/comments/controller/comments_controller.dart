import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/presentation/screens/comments/model/comments_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class CommentsController extends GetxController{
  ApiClient apiClient = ApiClient();
  final TextEditingController comments = TextEditingController();
  final PagingController<int, Comment> pagingController = PagingController(firstPageKey: 1);
  RxBool isLoadingMove = false.obs;

  Future<void> getPodcast(int pageKey,String id) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.comments(page: pageKey, id: id), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = CommentsModel.fromJson(response.body);
        final newItems = userServiceAll.data?.comments ?? [];
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

  RxBool addComments = false.obs;
  loadingAdd(bool value)=> addComments.value = value;

  /// ============================= Add Comments Info =====================================
  void commentsAdd({required String id}) async {
    try{
      loadingAdd(true);
      var response = await apiClient.post(url: ApiUrl.commentsAdd(id: id),body: {"text" : comments.text},showResult: true);

      if (response.statusCode == 200) {
        loadingAdd(false);
        comments.clear();
        pagingController.refresh();
      } else {
        loadingAdd(false);
      }
    }catch (err){
      loadingAdd(false);
    }
  }
}