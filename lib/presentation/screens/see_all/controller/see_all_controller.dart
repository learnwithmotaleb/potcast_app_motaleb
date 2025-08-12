import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

import '../model/see_all_album_model.dart';
import '../model/top_creator_model.dart';

class SeeAllController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  bool isLoadingMove = false;

  Future<void> getPodcast({
    required String url,
    required int pageKey,
    required PagingController<int, AllPodcastItem> pagingController,
  }) async {
    if (isLoadingMove) return;
    isLoadingMove = true;

    try {
      final response = await apiClient.get(
        url: url,
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
      isLoadingMove = false;
    }
  }

  bool isLoading = false;

  Future<void> getTopCreator({
    required int pageKey,
    required PagingController<int, TopCreatorItem> pagingController,
  }) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.seeAllTopCreator(page: pageKey),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final userServiceAll = TopCreatorModel.fromJson(response.body);
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
      isLoading = false;
    }
  }

  bool isLoadingAlbum = false;

  Future<void> getAllAlbum({
    required int pageKey,
    required PagingController<int, SeeAllAlbumItem> pagingController,
  }) async {
    if (isLoadingAlbum) return;
    isLoadingAlbum = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.seeAllAlbum(page: pageKey),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final userServiceAll = SeeAllAlbumModel.fromJson(response.body);
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
      isLoadingAlbum = false;
    }
  }
}
