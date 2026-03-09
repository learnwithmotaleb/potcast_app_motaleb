import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/playlist/model/playlist_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

import '../model/playlist_songs_model.dart';

class PlaylistController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        toastMessage(message: "Cover Image not selected.");
      }
    } catch (_) {
      toastMessage(message: "Cover Image not selected for permission error.");
    }
  }

  bool isLoadingMove = false;

  Future<void> getPlayList({
    required int pageKey,
    required PagingController<int, PlaylistItem> pagingController,
  }) async {
    if (isLoadingMove) return;
    isLoadingMove = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.playList(page: pageKey),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final userServiceAll = MyPlayListModel.fromJson(response.body);
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
      isLoadingMove = false;
    }
  }

  /// ============================= Create Playlist =====================================
  RxBool isLoading = false.obs;

  loadingMethod(bool status) => isLoading.value = status;

  void createPlayList({
    required Map<String, String> body,
    required File imageFile,
  }) async {
    try {
      loadingMethod(true);

      final List<MultipartBody> multipartBody = [
        MultipartBody("playlist_cover", imageFile),
      ];

      var response = await apiClient.multipartRequest(
        reqType: "POST",
        url: ApiUrl.playListCreate(),
        multipartBody: multipartBody,
        body: body,
        showResult: true,
      );

      if (response.statusCode == 201) {
        loadingMethod(false);
        String errorMessage =
            response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
        AppRouter.route.pop();
        AppRouter.route.pop();
      } else {
        loadingMethod(false);
        String errorMessage =
            response.body?['message']?.toString() ?? 'Something went wrong';
        toastMessage(message: errorMessage);
      }
    } catch (err) {
      loadingMethod(false);
    }
  }

  /// ============================= Delete Playlist =====================================
  void playlistDelete({
    required String id,
    required PagingController<int, PlaylistItem> pagingController,
  }) async {
    try {
      var response = await apiClient.delete(
        body: {},
        url: ApiUrl.playListDelete(id: id),
        showResult: true,
      );

      String message =
          response.body?['message']?.toString() ?? 'Something went wrong';
      toastMessage(message: message);

      if (response.statusCode == 200) {
        final currentList = pagingController.itemList ?? [];
        pagingController.itemList = List.from(currentList)
          ..removeWhere((item) => item.id == id);
      }
    } catch (_) {}
  }

  bool isLoadingPodcast = false;

  Future<void> getPlaylistPodcast({
    required int pageKey,
    required String id,
    required PagingController<int, PlayListPodcastItem> pagingController,
  }) async {
    if (isLoadingPodcast) return;
    isLoadingPodcast = true;

    try {
      final response = await apiClient.get(
          url: ApiUrl.playListSongs(page: pageKey, id: id), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = PlayListSongsModel.fromJson(response.body);
        final newItems = userServiceAll.data?.podcasts ?? [];
        pagingController.appendLastPage(newItems);
        /*if (newItems.isEmpty) {

        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }*/
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingPodcast = false;
    }
  }
}
