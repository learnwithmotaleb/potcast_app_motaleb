import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/settings/model/faq_model.dart';
import 'package:podcast/presentation/screens/settings/model/terms_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/service/check_api.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class SettingsController extends GetxController {
  ApiClient apiClient = ApiClient();
  DBHelper dbHelper = DBHelper();

  /// ============================= GET Terms Condition =====================================
  final Rx<TermsModel> termModel = TermsModel().obs;
  var termsLoading = Status.completed.obs;

  termsLoadingMethod(Status status) => termsLoading.value = status;

  Future<void> getTermsCondition() async {
    try {
      termsLoadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.terms(), showResult: true);
      if (response.statusCode == 200) {
        termModel.value = TermsModel.fromJson(response.body);
        termsLoadingMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          termsLoadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          termsLoadingMethod(Status.noDataFound);
        } else {
          termsLoadingMethod(Status.error);
        }
      }
    } catch (e) {
      termsLoadingMethod(Status.error);
    }
  }

  /// ============================= GET Privacy Policy =====================================
  final Rx<TermsModel> privacyData = TermsModel().obs;
  var privacyLoading = Status.completed.obs;

  privacyLoadingMethod(Status status) => privacyLoading.value = status;

  Future<void> getPrivacyPolicy() async {
    try {
      privacyLoadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.privacy(), showResult: true);
      if (response.statusCode == 200) {
        privacyData.value = TermsModel.fromJson(response.body);
        privacyLoadingMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          privacyLoadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          privacyLoadingMethod(Status.noDataFound);
        } else {
          privacyLoadingMethod(Status.error);
        }
      }
    } catch (e) {
      privacyLoadingMethod(Status.error);
    }
  }

  /// ============================= GET About Us =====================================
  final Rx<TermsModel> aboutUsData = TermsModel().obs;
  var aboutLoading = Status.completed.obs;

  aboutLoadingMethod(Status status) => aboutLoading.value = status;

  Future<void> getAboutUs() async {
    try {
      aboutLoadingMethod(Status.loading);
      var response = await apiClient.get(url: ApiUrl.about(), showResult: true);
      if (response.statusCode == 200) {
        aboutUsData.value = TermsModel.fromJson(response.body);
        aboutLoadingMethod(Status.completed);
      } else {
        if (response.statusCode == 503) {
          aboutLoadingMethod(Status.internetError);
        } else if (response.statusCode == 404) {
          aboutLoadingMethod(Status.noDataFound);
        } else {
          aboutLoadingMethod(Status.error);
        }
      }
    } catch (e) {
      aboutLoadingMethod(Status.error);
    }
  }

  /// ============================= GET Support Us =====================================
  final Rx<FaqModel> supportsData = FaqModel().obs;
  var supportsLoading = Status.completed.obs;

  supportsLoadingMethod(Status status) => supportsLoading.value = status;

  Future<void> getSupportUs() async {
    supportsLoadingMethod(Status.loading);
    var response = await apiClient.get(url: ApiUrl.faq(), showResult: true);
    if (response.statusCode == 200) {
      supportsData.value = FaqModel.fromJson(response.body);
      supportsLoadingMethod(Status.completed);
    } else {
      if (response.statusCode == 503) {
        supportsLoadingMethod(Status.internetError);
      } else if (response.statusCode == 404) {
        supportsLoadingMethod(Status.noDataFound);
      } else {
        supportsLoadingMethod(Status.error);
      }
    }
  }

  /// ============================= Patch Change Password =====================================
  var changePasswordLoading = false.obs;

  changePasswordLoadingMethod(bool loading) => changePasswordLoading.value = loading;

  Future<void> changePassword({required Map<String, String> body}) async {
    try {
      changePasswordLoadingMethod(true);
      var response =
          await apiClient.post(url: ApiUrl.changePassword(), body: body, showResult: true);
      if (response.statusCode == 200) {
        changePasswordLoadingMethod(false);
        toastMessage(message: response.body?['message'].toString() ?? "something want wrong");
        await dbHelper.logOut();
      } else {
        toastMessage(message: response.body?['message'].toString() ?? "something want wrong");
        changePasswordLoadingMethod(false);
      }
    } catch (e) {
      changePasswordLoadingMethod(false);
    }
  }

  /// ============================= DELETE Account =====================================
  RxBool deleteLoading = false.obs;
  deleteLoadingMethod(bool loading) => deleteLoading.value = loading;

  Future<void> deleteAccount({required Map<String, dynamic> body}) async {
    try {
      deleteLoadingMethod(true);
      print(body);
      var response = await apiClient.delete(url: ApiUrl.delete(), body: body,showResult: true);
      if (response.statusCode == 200) {
        toastMessage(message: response.body?['message'].toString() ?? "something want wrong");
        AppRouter.route.pop();
        await dbHelper.logOut();
        deleteLoadingMethod(false);
      } else {
        checkApi(response: response);
        deleteLoadingMethod(false);
      }
    } catch (e) {
      deleteLoadingMethod(false);
    }
  }

  @override
  void onReady() {
    Future.wait([
      getPrivacyPolicy(),
      getAboutUs(),
      getTermsCondition(),
      getSupportUs(),
    ]);
    super.onReady();
  }
}
