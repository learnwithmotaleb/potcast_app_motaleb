import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/presentation/screens/playlist/model/playlist_songs_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class PlayListSongsController extends GetxController{
  ApiClient apiClient = ApiClient();
  RxBool isLoadingMove = false.obs;

  final PagingController<int, PlayListPodcast> pagingController = PagingController(firstPageKey: 1);

  Future<void> getPlaylistPodcast({required int pageKey, required String id}) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response = await apiClient.get(url: ApiUrl.playListSongs(page: pageKey,id: id), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = PlayListSongsModel.fromJson(response.body);
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
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingMove.value = false;
    }
  }
}