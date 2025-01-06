import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/playlist/model/playlist_model.dart';
import 'package:podcast/presentation/screens/user/search/model/search_podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class PlaylistController extends GetxController{
  ApiClient apiClient = ApiClient();
  RxString search = "".obs;
  RxList<String> selectedPlayListId = RxList([]);
  TextEditingController title = TextEditingController();

  final PagingController<int, SearchPodcast> pagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Playlist> playListController = PagingController(firstPageKey: 1);
  RxBool isLoadingMove = false.obs;

  RxList<bool> playList = <bool>[].obs;

  Future<void> getPodcast(int pageKey, String search) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.search(page: pageKey,search: search), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = SearchPodcastModel.fromJson(response.body);
        final newItems = userServiceAll.data?.podcasts ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + newItems.length);
          for (int i = 0; i < newItems.length; i++) {
            playList.add(false);
          }
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

  Future<void> getPlayList(int pageKey) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.playList(page: pageKey), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = PlayListModel.fromJson(response.body);
        final newItems = userServiceAll.data?.playlists ?? [];
        if (newItems.isEmpty) {
          playListController.appendLastPage(newItems);
        } else {
          playListController.appendPage(newItems, pageKey + newItems.length);
        }
      } else {
        playListController.error = 'Error fetching data';
      }
    } catch (e) {
      playListController.error = 'An error occurred';
    } finally {
      isLoadingMove.value = false;
    }
  }

  void updateSearch(String value){
    search.value = value;
    pagingController.refresh();
  }


  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getPodcast(pageKey, search.value);
    });
    playListController.addPageRequestListener((pageKey) {
      getPlayList(pageKey);
    });
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  /// ============================= Create Podcast =====================================
  RxBool editLoading = false.obs;
  editLoadingMethod(bool status) => editLoading.value = status;
  void playlistAdd() async {
    try{
      editLoadingMethod(true);
      final body = {
        "title": title.text,
        "podcasts" : selectedPlayListId,
      };
      var response = await apiClient.post(url: ApiUrl.playListCreate(),body: body,showResult: true);

      if (response.statusCode == 200 || response.statusCode == 201) {
        title.clear();
        editLoadingMethod(false);
        AppRouter.route.pop();
        AppRouter.route.pop();
        playListController.refresh();
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        editLoadingMethod(false);
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    }catch (err){
      editLoadingMethod(false);
    }
  }

  /// ============================= Create Podcast =====================================
  RxBool deleteLoading = false.obs;
  deleteLoadingMethod(bool status) => deleteLoading.value = status;

  void playlistDelete({required String id, required BuildContext context}) async {
    try{
      deleteLoadingMethod(true);
      showPopUpLoader(context: context);
      var response = await apiClient.delete(url: ApiUrl.playListDelete(id: id), showResult: true);

      if (response.statusCode == 200) {
        title.clear();
        deleteLoadingMethod(false);
        AppRouter.route.pop();
        playListController.refresh();
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      } else {
        deleteLoadingMethod(false);
        AppRouter.route.pop();
        String errorMessage = response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    }catch (err){
      AppRouter.route.pop();
      deleteLoadingMethod(false);
    }
  }

  showPopUpLoader({required BuildContext context}) {
    return showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (_) {
          return const SizedBox(
            height: 70,
            child: AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              //child: CustomLoader(),
              content: Center(child: CircularProgressIndicator()),
            ),
          );
        });
  }
}