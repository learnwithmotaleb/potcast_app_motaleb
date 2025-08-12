import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/user/upgrade/model/upgrade_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';

class UpgradeController extends GetxController {
  ApiClient apiClient = ApiClient();

  RxInt index = 0.obs;
  RxString selectedId = "".obs;

  final PagingController<int, Plan> pagingController =
      PagingController(firstPageKey: 1);
  RxBool isLoadingMove = false.obs;

  Future<void> getPodcast(int pageKey) async {
    if (isLoadingMove.value) return;
    isLoadingMove.value = true;

    try {
      final response =
          await apiClient.get(url: ApiUrl.plan(), showResult: true);

      if (response.statusCode == 200) {
        final userServiceAll = PlanModel.fromJson(response.body);
        final newItems = userServiceAll.data ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
          pagingController.appendLastPage([]);
        }
      } else {
        pagingController.error = 'Error fetching data';
      }
    } catch (e) {
      pagingController.error = 'An error occurred';
    } finally {
      isLoadingMove.value = false;
    }
  }

  /// ============================= EDIT Profile Info =====================================
  RxBool loading = false.obs;
  loadingMethod(bool status) => loading.value = status;
  void makeStripePayment({required String id}) async {
    loadingMethod(true);
    var response = await apiClient.post(url: ApiUrl.payment(id: id), body: {});

    if (response.statusCode == 200) {
      final data = PaymentModel.fromJson(response.body);
      final String url = data.data?.session?.url ?? "";

      if (url.isNotEmpty) {
        AppRouter.route.pushNamed(RoutePath.paymentWebViewScreen, extra: url);
      }
      loadingMethod(false);
    } else {
      loadingMethod(false);
      String errorMessage =
          response.body?['message']?.toString() ?? 'Something went wrong';
      toastMessage(message: errorMessage);
    }
  }

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getPodcast(pageKey);
    });
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}

class PaymentModel {
  final Data? data;

  PaymentModel({
    this.data,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final Session? session;

  Data({
    this.session,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        session:
            json["session"] == null ? null : Session.fromJson(json["session"]),
      );
}

class Session {
  final String? url;

  Session({
    this.url,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        url: json["url"],
      );
}
