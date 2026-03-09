import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/model/banner_model.dart';
import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../model/home_model.dart';
import '../model/streaming_record_model.dart';

class UserHomeController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final DBHelper dbHelper = serviceLocator<DBHelper>();

  /// ============================= GET Home Info =====================================
  var loading = Status.completed.obs;
  loadingMethod(Status status) => loading.value = status;
  final Rx<HomeModel> model = HomeModel().obs;

  Future<void> getHome() async {
    try{
      loadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.home(), showResult: true);
      if (response.statusCode == 200) {
        model.value = HomeModel.fromJson(response.body);
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
    } catch(e, st) {
      debugPrint("❌ getHome error: $e");
      debugPrint("❌ getHome stacktrace: $st");
      loadingMethod(Status.error);
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
  }

  @override
  void onReady() {
    Future.wait([
      getHome(),
      getBanners(),
      getRecords(),
    ]);
    super.onReady();
  }
}
