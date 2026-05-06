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
  String? passedCreatorImage;
  
  void initData(AudioPlayerModel model) {
    isReels = model.reels;
    isPopular = model.popular;
    firstPodcastId = model.firstPodcastId ?? model.id;
    stationId = model.stationId;
    passedCreatorImage = model.creatorImage;
    
    fetchReels(isRefresh: true);
  }

  Future<void> fetchReels({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
      reels.clear();
      nextCursor = firstPodcastId;
      hasMore = true;
      error.value = "";
    } else {
      if (!hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }
    
    try {
      final url = ApiUrl.playFeed(
        reels: isReels,
        popular: isPopular,
        firstPodcastId: nextCursor,
        stationId: stationId,
        limit: 10,
      );

      if (url.isEmpty) {
        error.value = "Invalid feed URL";
        return;
      }

      final response = await apiClient.get(
        url: url,
        showResult: true,
      );

      if (response.statusCode == 200) {
        final feed = PlayFeedModel.fromJson(response.body);
        final newItems = feed.data?.podcasts ?? [];
        
        final newPlayEntities = newItems
            .map((e) {
              final entity = PlayEntity.fromPodcast(e);
              if (entity != null && (entity.creatorImage == null || entity.creatorImage!.isEmpty)) {
                return entity.copyWith(creatorImage: passedCreatorImage);
              }
              return entity;
            })
            .whereType<PlayEntity>()
            .toList();

        if (isRefresh) {
          reels.assignAll(newPlayEntities);
        } else {
          // Avoid duplicates
          final existingIds = reels.map((e) => e.id).toSet();
          final uniqueItems = newPlayEntities
              .where((item) => !existingIds.contains(item.id))
              .toList();
          reels.addAll(uniqueItems);
        }
        
        hasMore = feed.data?.hasMore ?? false;
        nextCursor = feed.data?.nextCursor;
        error.value = "";
      } else if (response.statusCode == 503) {
        error.value = "No internet connection. Please check your network.";
      } else {
        error.value = "Failed to load reels. Please try again.";
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
