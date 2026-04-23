import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/presentation/screens/see_all/model/top_creator_model.dart';
import 'package:podcast/presentation/screens/see_all/model/see_all_album_model.dart';

class SearchScreenController extends GetxController {
  ApiClient apiClient = ApiClient();
  RxString search = "".obs;
  RxBool isLoadingMove = false.obs;

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

  bool isLoadingCreator = false;

  Future<void> getTopCreatorSearch({
    required int pageKey,
    required PagingController<int, TopCreatorItem> pagingController,
  }) async {
    if (isLoadingCreator) return;
    isLoadingCreator = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.seeAllTopCreator(
          page: pageKey,
          searchTerm: search.value,
        ),
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
      isLoadingCreator = false;
    }
  }

  bool isLoadingAlbum = false;

  Future<void> getAlbumsSearch({
    required int pageKey,
    required PagingController<int, SeeAllAlbumItem> pagingController,
  }) async {
    if (isLoadingAlbum) return;
    isLoadingAlbum = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.seeAllAlbum(
          page: pageKey,
          searchTerm: search.value,
        ),
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

  void updateSearch({
    required String value,
    required List<PagingController> controllers,
  }) {
    search.value = value;
    for (var controller in controllers) {
      controller.refresh();
    }
  }
}
