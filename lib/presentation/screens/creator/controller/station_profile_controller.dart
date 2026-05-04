import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:podcast/model/all_podcast_model.dart' as all_podcast;
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import '../../home/model/top_fav_live_model.dart' as station_model;

class StationProfileController extends GetxController {
  final ApiClient apiClient = ApiClient();

  final Rx<Status> loading = Status.loading.obs;
  final RxList<PlayPodcastItem> podcasts = <PlayPodcastItem>[].obs;
  final RxList<PlayPodcastItem> reels = <PlayPodcastItem>[].obs;
  final RxList<dynamic> albums = <dynamic>[].obs;
  final Rx<station_model.Data?> stationInfo = Rx<station_model.Data?>(null);

  Future<void> getStationProfile(String stationId) async {
    if (stationId.isEmpty) {
      loading.value = Status.noDataFound;
      return;
    }

    try {
      loading.value = Status.loading;

      // Clear previous data for fresh load
      podcasts.clear();
      reels.clear();
      albums.clear();
      stationInfo.value = null;

      // 1. Fetch Station Info
      final stationResponse = await apiClient.get(
        url: ApiUrl.station(),
        showResult: true,
      );

      if (stationResponse.statusCode == 200) {
        try {
          final model = station_model.TopFavLiveModel.fromJson(stationResponse.body);
          stationInfo.value = model.data;
        } catch (e) {
          debugPrint("⚠️ Station info parse error (non-fatal): $e");
        }
      }

      // 2. Fetch Podcasts for this station
      final podcastResponse = await apiClient.get(
        url: ApiUrl.playFeed(stationId: stationId, reels: false, limit: 10),
        showResult: true,
      );

      if (podcastResponse.statusCode == 200) {
        try {
          final feed = PlayFeedModel.fromJson(podcastResponse.body);
          podcasts.assignAll(feed.data?.podcasts ?? []);
        } catch (e) {
          debugPrint("⚠️ Podcast feed parse error: $e");
        }
      }

      // 3. If podcasts are empty, try creatorPodcasts endpoint as backup
      if (podcasts.isEmpty) {
        try {
          final altResponse = await apiClient.get(
            url: ApiUrl.creatorPodcasts(creatorId: stationId),
            showResult: true,
          );
          if (altResponse.statusCode == 200) {
            final model = all_podcast.AllPodcastModel.fromJson(altResponse.body);
            final items = model.data?.result
                ?.map((e) => PlayPodcastItem(
                      id: e.id,
                      title: e.title,
                      coverImage: e.coverImage,
                      podcastUrl: e.podcastUrl,
                      duration: e.duration,
                      creator: Creator(
                        id: e.creator?.id,
                        name: e.creator?.name,
                      ),
                    ))
                .toList();
            if (items != null && items.isNotEmpty) {
              podcasts.assignAll(items);
            }
          }
        } catch (e) {
          debugPrint("⚠️ Creator podcasts fallback error: $e");
        }
      }

      // 4. Build stationInfo from podcast data if station API didn't match
      if (podcasts.isNotEmpty &&
          (stationInfo.value == null || stationInfo.value?.id != stationId)) {
        final first = podcasts.first;
        stationInfo.value = station_model.Data(
          id: first.creator?.id ?? stationId,
          name: first.creator?.name ?? "Station",
          description: "",
          profileImage: first.coverImage ?? "",
          address: "",
          isLive: false,
          donationUrl: "",
          coverImage: first.coverImage ?? "",
          version: 0,
        );
      }

      // 5. Fetch Reels for this station
      final reelsResponse = await apiClient.get(
        url: ApiUrl.playFeed(stationId: stationId, reels: true, limit: 10),
        showResult: true,
      );

      if (reelsResponse.statusCode == 200) {
        try {
          final feed = PlayFeedModel.fromJson(reelsResponse.body);
          reels.assignAll(feed.data?.podcasts ?? []);
        } catch (e) {
          debugPrint("⚠️ Reels feed parse error: $e");
        }
      }

      // 6. If reels are still empty, use first 5 podcasts as fallback
      if (reels.isEmpty && podcasts.isNotEmpty) {
        reels.assignAll(podcasts.take(5).toList());
      }

      // 7. Fetch Albums
      try {
        final albumResponse = await apiClient.get(
          url: ApiUrl.seeAllAlbum(page: 1),
          showResult: true,
        );

        if (albumResponse.statusCode == 200) {
          final body = albumResponse.body;
          if (body is Map<String, dynamic> &&
              body['success'] == true &&
              body['data'] != null &&
              body['data']['result'] != null) {
            albums.assignAll(body['data']['result'] as List);
          }
        }
      } catch (e) {
        debugPrint("⚠️ Albums fetch error (non-fatal): $e");
      }

      // If we still have no data at all, show noDataFound
      if (podcasts.isEmpty && reels.isEmpty && stationInfo.value == null) {
        loading.value = Status.noDataFound;
      } else {
        loading.value = Status.completed;
      }
    } catch (e, st) {
      debugPrint("❌ getStationProfile error: $e");
      debugPrint("❌ getStationProfile stacktrace: $st");
      loading.value = Status.error;
    }
  }
}
