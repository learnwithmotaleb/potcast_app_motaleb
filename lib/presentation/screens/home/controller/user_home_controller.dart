import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/model/banner_model.dart';
import 'package:podcast/presentation/screens/see_all/model/top_creator_model.dart' as top;
import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../model/home_model.dart' as home;
import '../model/streaming_record_model.dart';
import '../model/top_fav_live_model.dart';
class UserHomeController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final DBHelper dbHelper = serviceLocator<DBHelper>();

  Timer? _refreshTimer;
  /// ============================= GET Home Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  final Rx<home.HomeModel> model = home.HomeModel().obs;

  Future<void> getHome() async {
    try{
      loadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.home(), showResult: true);
      if (response.statusCode == 200) {
        model.value = home.HomeModel.fromJson(response.body);
        loadingMethod(Status.completed);
        
        // After loading home, immediately sync top creators to get latest live status
        getTopCreators();
      } else {
        if (response.statusCode == 503) {
          loadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          loadingMethod(Status.noDataFound);
        } else {
          loadingMethod(Status.error);
        }
      }
    } catch(e, st) {
      debugPrint("❌ getHome error: $e");
      debugPrint("❌ getHome stacktrace: $st");
      loadingMethod(Status.error);
    }
  }

  /// ============================= GET Top Creators (Sync Live Status) =====================================
  Future<void> getTopCreators() async {
    try {
      var response = await apiClient.get(url: ApiUrl.seeAllTopCreator(page: 1, searchTerm: ""), showResult: false);
      if (response.statusCode == 200) {
        final topCreatorData = top.TopCreatorModel.fromJson(response.body);
        final latestCreators = topCreatorData.data?.result;

        if (latestCreators != null && latestCreators.isNotEmpty) {
          // Update the existing home model's top creators with latest data
          if (model.value.data != null) {
            final List<home.TopCreator> updatedList = latestCreators.map((item) => home.TopCreator(
              name: item.name,
              email: item.email,
              profileImage: item.profileImage,
              location: item.location != null ? home.Location(
                type: item.location?.type, 
                coordinates: item.location?.coordinates?.map((e) => (e as num).toDouble()).toList()
              ) : null,
              profileCover: item.profileCover,
              donationLink: item.donationLink,
              liveSession: item.liveSession != null ? home.LiveSession(
                sessionId: item.liveSession?.sessionId,
                name: item.liveSession?.name,
                description: item.liveSession?.description,
                coverImage: item.liveSession?.coverImage,
                sessionStartedAt: item.liveSession?.sessionStartedAt,
                duration: item.liveSession?.duration,
              ) : null,
              isLive: item.isLive,
              streamRoom: item.streamRoom != null ? home.StreamRoom(
                id: item.streamRoom?.id,
                status: item.streamRoom?.status,
                roomCodes: item.streamRoom?.roomCodes?.map((rc) => home.RoomCode(
                  roomCodeId: rc.id,
                  code: rc.code,
                  role: rc.role,
                  enabled: rc.enabled,
                )).toList(),
              ) : null,
              totalViews: item.totalViews?.toInt(),
              creatorId: item.creatorId,
            )).toList();

            // Trigger UI update
            model.update((val) {
              val?.data?.topCreators?.clear();
              val?.data?.topCreators?.addAll(updatedList);
            });
            debugPrint("✅ Top Creators Live Status Synchronized");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error syncing top creators: $e");
    }
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Only refresh if we are on the home screen to save resources
      getTopCreators();
    });
  }

  /// ============================= GET Station Info =====================================
  var loadingStation = Status.completed.obs;
  loadingStationMethod(Status status) => loadingStation.value = status;
  final Rx<TopFavLiveModel?> topFavLiveModel = Rx<TopFavLiveModel?>(null);

  Future<void> getStation() async {
    try{
      loadingStationMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.station(), showResult: true);
      if (response.statusCode == 200) {
        topFavLiveModel.value = TopFavLiveModel.fromJson(response.body);
        debugPrint("✅ Station data loaded: ${topFavLiveModel.value?.data?.name}");
        loadingStationMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          loadingStationMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          loadingStationMethod(Status.noDataFound);
        } else {
          loadingStationMethod(Status.error);
        }
      }
    } catch(e, st) {
      debugPrint("❌ getStation error: $e");
      debugPrint("❌ getStation stacktrace: $st");
      loadingStationMethod(Status.error);
    }
  }

  /// ============================= GET Record List =====================================
  var loadingRecord = Status.completed.obs;
  loadingRecordMethod(Status status) => loadingRecord.value = status;
  final RxList<StreamingRecordItem> recordList = RxList([]);

  Future<void> getRecords() async {
    try{
      loadingRecordMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.streamingRecord(), showResult: true);
      if (response.statusCode == 200) {
        final items = StreamingRecordModel.fromJson(response.body);
        final newItems = items.data?.result ?? [];

        recordList.assignAll(newItems);
        loadingRecordMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          loadingRecordMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          loadingRecordMethod(Status.noDataFound);
        } else {
          loadingRecordMethod(Status.error);
        }
      }
    }catch(_){
      loadingRecordMethod(Status.error);
    }
  }

  /// ============================= GET Banner =====================================
  final Rx<Status> loadingBanner = Status.completed.obs;
  void loadingBannerMethod(Status status) => loadingBanner.value = status;
  final subscriptionController = Get.find<SubscriptionController>();
  final RxBool shouldShowBanners = true.obs;
  final Rx<BannerModel> bannerModel = BannerModel().obs;

  Future<void> getBanners() async {
    try {

      await subscriptionController.fetchCustomerInfo();

      if (subscriptionController.hasActiveSubscription) {
        debugPrint("Skipping banner fetch for premium user");
        bannerModel.value = BannerModel();
        loadingBannerMethod(Status.completed);
        return;
      }

      loadingBannerMethod(Status.loading);
      var response = await apiClient.get(
        url: ApiUrl.banner(),
        showResult: true,
      );

      if (response.statusCode == 200) {
        bannerModel.value = BannerModel.fromJson(response.body);
        loadingBannerMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          loadingBannerMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          loadingBannerMethod(Status.noDataFound);
        } else {
          loadingBannerMethod(Status.error);
        }
      }
    } catch (_) {
      loadingBannerMethod(Status.error);
    }
  }

  @override
  void onInit() {
    super.onInit();

    ever(subscriptionController.customer, (CustomerInfo? customerInfo) {
      final hasSubscription = customerInfo?.entitlements.active.isNotEmpty ?? false;
      shouldShowBanners.value = !hasSubscription;

      debugPrint("Subscription status changed: Premium = $hasSubscription");

      if (hasSubscription && bannerModel.value.data?.isNotEmpty == true) {
        bannerModel.value = BannerModel();
        debugPrint("Cleared banner data for new premium user");
      }

      if (!hasSubscription && bannerModel.value.data?.isEmpty == true) {
        debugPrint("Subscription expired, fetching banners...");
        getBanners();
      }
    });

    _startRefreshTimer();
  }

  @override
  void onReady() {
    Future.wait([
      getHome(),
      getStation(),
      getBanners(),
      getRecords(),
    ]);
    super.onReady();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }
}
