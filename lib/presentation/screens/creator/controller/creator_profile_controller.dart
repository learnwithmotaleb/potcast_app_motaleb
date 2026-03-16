import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class CreatorProfileController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  final Rx<Status> loading = Status.loading.obs;
  final Rx<AllPodcastModel> creatorPodcasts = AllPodcastModel().obs;
  final Rx<Creator?> creatorInfo = Rx<Creator?>(null);

  Future<void> getCreatorProfile(String creatorId) async {
    if (creatorId.isEmpty) {
      loading.value = Status.noDataFound;
      return;
    }

    try {
      loading.value = Status.loading;
      final response = await apiClient.get(
        url: ApiUrl.creatorPodcasts(creatorId: creatorId),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final model = AllPodcastModel.fromJson(response.body);
        creatorPodcasts.value = model;
        
        // Extract creator info from the first podcast item if available
        if (model.data?.result?.isNotEmpty == true) {
          creatorInfo.value = model.data!.result!.first.creator;
        }
        
        if (model.data?.result?.isEmpty == true) {
           loading.value = Status.noDataFound;
        } else {
           loading.value = Status.completed;
        }
      } else {
        if (response.statusCode == 503) {
          loading.value = Status.internetError;
        } else if (response.statusCode == 404) {
          loading.value = Status.noDataFound;
        } else {
          loading.value = Status.error;
        }
      }
    } catch (e, st) {
      debugPrint("❌ getCreatorProfile error: $e");
      debugPrint("❌ getCreatorProfile stacktrace: $st");
      loading.value = Status.error;
    }
  }
}
