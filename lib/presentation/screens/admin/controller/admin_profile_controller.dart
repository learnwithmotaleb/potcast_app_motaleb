import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/model/all_podcast_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class CreatorProfileController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();

  final Rx<Status> loading = Status.loading.obs;
  final RxList<AllPodcastItem> podcasts = <AllPodcastItem>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final Rx<Creator?> creatorInfo = Rx<Creator?>(null);

  Future<void> getCreatorProfile(String creatorId) async {
    if (creatorId.isEmpty) {
      loading.value = Status.noDataFound;
      return;
    }

    try {
      loading.value = Status.loading;
      podcasts.clear();
      categories.clear();
      creatorInfo.value = null;

      final response = await apiClient.get(
        url: ApiUrl.creatorPodcasts(creatorId: creatorId),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final model = AllPodcastModel.fromJson(response.body);
        podcasts.assignAll(model.data?.result ?? []);

        // Extract creator info from the first podcast item if available
        if (podcasts.isNotEmpty) {
          creatorInfo.value = podcasts.first.creator;
        }

        // Fetch Global Categories
        try {
          final catResponse = await apiClient.get(
            url: ApiUrl.category(),
            showResult: true,
          );
          if (catResponse.statusCode == 200) {
            final body = catResponse.body;
            if (body is Map<String, dynamic> && body['data'] != null) {
              final List<dynamic> catList = body['data'];
              categories.assignAll(
                  catList.map((e) => Category.fromJson(e)).toList());
            }
          }
        } catch (_) {}

        if (podcasts.isEmpty) {
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
