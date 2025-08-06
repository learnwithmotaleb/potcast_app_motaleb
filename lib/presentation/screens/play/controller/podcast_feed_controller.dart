import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class PodcastFeedController extends GetxController{
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final RxBool likeLoading = false.obs;
  final RxBool favoriteLoading = false.obs;

  Future<bool> likePodcast({required String id, required bool current}) async {
    try{
      if (likeLoading.value) {
        return current;
      }

      likeLoading.value = true;
      var response = await apiClient.post(url: ApiUrl.like(id: id),body: {},showResult: true);

      if (response.statusCode == 200) {
        likeLoading.value = false;
        final bool likeData = response.body?['data']?['like']??false;
        return likeData;
      } else {
        likeLoading.value = false;
        return current;
      }
    }catch(e){
      likeLoading.value = false;
      return current;
    }finally{
      likeLoading.value = false;
    }
  }

  Future<bool> favoritePodcast({required String id, required bool current}) async {
    try{
      if (favoriteLoading.value) {
        return current;
      }

      favoriteLoading.value = true;
      var response = await apiClient.post(url: ApiUrl.favoriteAdd(),body: {"podcastId" : id},showResult: true);

      if (response.statusCode == 200) {
        favoriteLoading.value = false;
        final bool favorite = response.body?['data']?['favorite']??false;
        return favorite;
      } else {
        favoriteLoading.value = false;
        return current;
      }
    }catch(e){
      favoriteLoading.value = false;
      return current;
    }finally{
      favoriteLoading.value = false;
    }
  }
}