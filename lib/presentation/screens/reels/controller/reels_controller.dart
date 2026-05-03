import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class ReelsController extends GetxController {
  final ApiClient apiClient = ApiClient();
  
  final RxList<PlayEntity> reels = <PlayEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = "".obs;

  String? nextCursor;
  bool hasMore = true;
  
  // Params
  bool? isReels;
  bool? isPopular;
  String? firstPodcastId;
  String? stationId;
  
  void initData(AudioPlayerModel model) {
    isReels = model.reels;
    isPopular = model.popular;
    firstPodcastId = model.firstPodcastId ?? model.id;
    stationId = model.stationId;
    
    fetchReels(isRefresh: true);
  }

  Future<void> fetchReels({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
      reels.clear();
      nextCursor = firstPodcastId; // Use the provided first ID or cursor
      hasMore = true;
    } else {
      if (!hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }
    
    try {
      final response = await apiClient.get(
        url: ApiUrl.playFeed(
          reels: isReels,
          popular: isPopular,
          firstPodcastId: nextCursor,
          stationId: stationId,
          limit: 10,
        ),
        showResult: true,
      );

      if (response.statusCode == 200) {
        final feed = PlayFeedModel.fromJson(response.body);
        final newItems = feed.data?.podcasts ?? [];
        
        final newPlayEntities = newItems
            .map(PlayEntity.fromPodcast)
            .whereType<PlayEntity>()
            .toList();

        if (isRefresh) {
          reels.assignAll(newPlayEntities);
        } else {
          reels.addAll(newPlayEntities);
        }
        
        hasMore = feed.data?.hasMore ?? false;
        nextCursor = feed.data?.nextCursor;
        error.value = "";
      } else {
        error.value = "Failed to load reels. Status code: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Error fetching reels: $e");
      error.value = "An error occurred while fetching reels.";
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    fetchReels();
  }
}
