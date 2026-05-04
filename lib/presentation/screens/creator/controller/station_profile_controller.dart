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
      
      // 1. Fetch Station Info
      final stationResponse = await apiClient.get(
        url: ApiUrl.station(), // Note: Usually this returns the "active" station or we might need a specific ID
        showResult: true,
      );

        if (stationResponse.statusCode == 200) {
          final model = station_model.TopFavLiveModel.fromJson(stationResponse.body);
          stationInfo.value = model.data;
        }

      // 2. Fetch Podcasts for this station
      var podcastResponse = await apiClient.get(
        url: ApiUrl.playFeed(stationId: stationId, reels: false, limit: 10),
        showResult: true,
      );

      if (podcastResponse.statusCode == 200) {
        final feed = PlayFeedModel.fromJson(podcastResponse.body);
        podcasts.assignAll(feed.data?.podcasts ?? []);
      }

      // If podcasts are empty, try creatorPodcasts endpoint as backup
      if (podcasts.isEmpty) {
        final altResponse = await apiClient.get(
          url: ApiUrl.creatorPodcasts(creatorId: stationId),
          showResult: true,
        );
        if (altResponse.statusCode == 200) {
           final model = all_podcast.AllPodcastModel.fromJson(altResponse.body);
           final items = model.data?.result?.map((e) => PlayPodcastItem(
             id: e.id,
             title: e.title,
             coverImage: e.coverImage,
             podcastUrl: e.podcastUrl,
             duration: e.duration,
             creator: Creator(id: e.creator?.id, name: e.creator?.name),
           )).toList();
           if (items != null) podcasts.assignAll(items);
        }
      }

      // If stationInfo is still null or doesn't match the ID, extract from first podcast
      if (podcasts.isNotEmpty && (stationInfo.value == null || stationInfo.value?.id != stationId)) {
        final first = podcasts.first;
        stationInfo.value = station_model.Data(
          id: first.creator?.id ?? stationId,
          name: first.creator?.name ?? "Station",
          description: "Station Profile",
          profileImage: first.coverImage ?? "",
          address: "Station Location",
          isLive: false,
          donationUrl: "",
          coverImage: first.coverImage ?? "",
          version: 0,
        );
      }

      // 3. Fetch Reels for this station
      var reelsResponse = await apiClient.get(
        url: ApiUrl.playFeed(stationId: stationId, reels: true, limit: 10),
        showResult: true,
      );

      if (reelsResponse.statusCode == 200) {
        final feed = PlayFeedModel.fromJson(reelsResponse.body);
        reels.assignAll(feed.data?.podcasts ?? []);
      }

      // If reels are empty, try creatorPodcasts with reels=true if supported or just use first 5 from podcasts as reels
      if (reels.isEmpty && podcasts.isNotEmpty) {
         reels.assignAll(podcasts.take(5).toList());
      }

      // 4. Fetch Albums (Placeholder or specific if available)
      final albumResponse = await apiClient.get(
        url: ApiUrl.seeAllAlbum(page: 1),
        showResult: true,
      );

      if (albumResponse.statusCode == 200) {
        final Map<String, dynamic> body = albumResponse.body;
        if (body['success'] == true) {
          albums.assignAll(body['data']['result'] ?? []);
        }
      }

      loading.value = Status.completed;
    } catch (e, st) {
      debugPrint("❌ getStationProfile error: $e");
      debugPrint("❌ getStationProfile stacktrace: $st");
      loading.value = Status.error;
    }
  }
}
