import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/presentation/screens/album/model/album_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class AlbumController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  Rx<AlbumModel> albumModel = AlbumModel().obs;

  /// ============================= GET Album Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;

  Future<void> getAlbum({required String id}) async {
    try {
      loadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.singleAlbum(id: id), showResult: true);

      if (response.statusCode == 200) {
        albumModel.value = AlbumModel.fromJson(response.body);
        loadingMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          loadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          loadingMethod(Status.noDataFound);
        } else {
          loadingMethod(Status.error);
        }
      }
    } catch (e) {
      loadingMethod(Status.error);
    }
  }
}
