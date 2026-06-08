import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/auth/model/login_model.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/service/check_api.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AuthController extends GetxController {
  final ApiClient apiClient = serviceLocator<ApiClient>();
  final DBHelper dbHelper = serviceLocator<DBHelper>();

  RxString selectedRoll = "user".obs;

  void updateRoll(String? value) {
    if (value != null) {
      selectedRoll.value = value;
    }
  }

  /// ============================= Login Account =====================================
  RxBool loginLoading = false.obs;
  loginMethod(bool status) => loginLoading.value = status;

  void login({required Map<String, String> body}) async {
    try {
      loginMethod(true);
      var response =
          await apiClient.post(body: body, url: ApiUrl.login(), isBasic: true);

      if (response.statusCode == 200) {
        final activeAccountModel = LoginModel.fromJson(response.body);
        final String accessToken = activeAccountModel.data?.accessToken ?? "";
        final String refreshToken = activeAccountModel.data?.refreshToken ?? "";

        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        final String role = decodedToken["role"] ?? "";
        final String id = decodedToken["id"] ?? "";
        final String profileId = decodedToken["profileId"] ?? "";

        await dbHelper.saveUserdata(
          token: accessToken,
          refreshToken: refreshToken,
          id: id,
          profileId: profileId,
          role: role,
        );
        await purchaseConfig(userId: id);

        activeMethod(false);
        toastMessage(message: response.body['message'].toString());

        if (role == "user") {
          AppRouter.route.goNamed(RoutePath.userNavScreen);
        } else if (role == "creator") {
          AppRouter.route.goNamed(RoutePath.creatorNavScreen);
        }
        else if (role == "superAdmin" || role == "admin") {
          AppRouter.route.goNamed(RoutePath.adminNavScreen);
        }
        else {
          AppRouter.route.goNamed(RoutePath.loginScreen);
        }
      } else {
        loginMethod(false);
        toastMessage(message: response.body['message'].toString());
      }
    } catch (err) {
      loginMethod(false);
    }
  }

  Future<void> purchaseConfig({required String userId}) async {
    try {
      print("0 User ID: $userId / RC ID: ${await Purchases.appUserID}");
      await Purchases.logIn(userId);

      print("1 User ID: $userId / RC ID: ${await Purchases.appUserID}");
      await Purchases.setAttributes({
        'user_id': userId,
      });

      print("🔧 Attributes synced for $userId");
    } catch (e) {
      print('Purchase config failed: $e');
    }
  }

  /// ============================= Sign Up ===========================================
  RxBool signUpLoading = false.obs;
  signUpLoadingMethod(bool status) => signUpLoading.value = status;

  Future<void> signUp({required Map<String, String> body, required String email}) async {
    try {
      signUpLoadingMethod(true);
      var response = await apiClient.post(
          body: body, url: ApiUrl.register(), isBasic: true);

      if (response.statusCode == 200) {
        signUpLoadingMethod(false);
        final model = SignUpModel.fromJson(response.body);
        if (model.success == true) {
          toastMessage(message: model.message ?? "something want wrong");
          AppRouter.route.pushNamed(RoutePath.verificationScreen, extra: email);
        } else {
          toastMessage(message: model.message ?? "something want wrong");
        }
      } else {
        signUpLoadingMethod(false);
        checkApi(response: response);
      }
    } catch (err) {
      signUpLoadingMethod(false);
    }
  }

  /// ============================= Active Account =====================================
  RxBool activeLoading = false.obs;
  activeMethod(bool status) => activeLoading.value = status;
  void activeAccount({required Map<String, dynamic> body}) async {
    try {
      activeMethod(true);
      var response = await apiClient.post(
          body: body, url: ApiUrl.activate(), isBasic: true);

      if (response.statusCode == 200) {
        final activeAccountModel = LoginModel.fromJson(response.body);
        final String accessToken = activeAccountModel.data?.accessToken ?? "";
        final String refreshToken = activeAccountModel.data?.refreshToken ?? "";

        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        final String role = decodedToken["role"] ?? "";
        final String id = decodedToken["id"] ?? "";
        final String profileId = decodedToken["profileId"] ?? "";

        await dbHelper.saveUserdata(
          token: accessToken,
          refreshToken: refreshToken,
          id: id,
          profileId: profileId,
          role: role,
        );
        await purchaseConfig(userId: id);

        activeMethod(false);
        toastMessage(message: response.body['message'].toString());

        if (role == "user") {
          AppRouter.route.goNamed(RoutePath.userNavScreen);
        } else if (role == "creator") {
          AppRouter.route.goNamed(RoutePath.creatorNavScreen);
        }
        else if (role == "superAdmin" || role == "admin") {
          AppRouter.route.goNamed(RoutePath.adminNavScreen);
        }
        else {
          AppRouter.route.goNamed(RoutePath.loginScreen);
        }
      } else {
        activeMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      }
    } catch (err) {
      activeMethod(false);
    }
  }

  /// ============================= Resend OTP Account Active =====================================
  RxBool resendActiveLoading = false.obs;
  resendActiveLoadingMethod(bool status) => resendActiveLoading.value = status;
  void resendActiveOTP({required String email}) async {
    try {
      resendActiveLoadingMethod(true);
      var response = await apiClient
          .post(body: {"email": email}, url: ApiUrl.forget(), isBasic: true);
      if (response.statusCode == 200) {
        resendActiveLoadingMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      } else {
        resendActiveLoadingMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      }
    } catch (err) {
      resendActiveLoadingMethod(false);
    }
  }

  /// ============================= Resend OTP =====================================
  RxBool resendLoading = false.obs;
  resendLoadingMethod(bool status) => resendLoading.value = status;
  void resendOTP({required String email, required String url}) async {
    try {
      resendLoadingMethod(true);
      var response =
          await apiClient.post(body: {"email": email}, url: url, isBasic: true);
      if (response.statusCode == 200) {
        resendLoadingMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      } else {
        resendLoadingMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      }
    } catch (err) {
      resendLoadingMethod(false);
    }
  }

  /// ============================= Forget Password =====================================
  RxBool forgetLoading = false.obs;
  forgetMethod(bool status) => forgetLoading.value = status;
  void forget({required String email}) async {
    try {
      forgetMethod(true);
      var response = await apiClient.post(
          body: {"email": email},
          url: ApiUrl.forget(),
          isBasic: true,
          showResult: true);

      if (response.statusCode == 200) {
        if (response.body['success'] == true) {
          forgetMethod(false);
          toastMessage(
              message: response.body?['message']?.toString() ??
                  "something want wrong");
          AppRouter.route.pushNamed(RoutePath.otpScreen, extra: email);
        } else {
          forgetMethod(false);
          toastMessage(
              message: response.body?['message']?.toString() ??
                  "something want wrong");
        }
      } else {
        forgetMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      }
    } catch (err) {
      forgetMethod(false);
    }
  }

  /// ============================= Active Account =====================================
  RxBool otpLoading = false.obs;
  otpMethod(bool status) => otpLoading.value = status;
  void otpVerify({required Map<String, dynamic> body, required String email}) async {
    try {
      otpMethod(true);
      var response = await apiClient.post(
          body: body, url: ApiUrl.verifyOtp(), isBasic: true);

      if (response.statusCode == 200) {
        if (response.body?["success"] != null &&
            response.body?["success"] == true) {
          otpMethod(false);
          toastMessage(
              message: response.body?['message']?.toString() ??
                  "something want wrong");
          AppRouter.route.pushNamed(RoutePath.resetScreen, extra: email);
        } else {
          otpMethod(false);
          toastMessage(
              message: response.body?['message']?.toString() ??
                  "something want wrong");
        }
      } else {
        otpMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      }
    } catch (err) {
      otpMethod(false);
    }
  }

  /// ============================= Reset Password =====================================
  RxBool resetLoading = false.obs;
  resetMethod(bool status) => resetLoading.value = status;
  void resetPassword({required Map<String, String> body}) async {
    try {
      resetMethod(true);
      var response =
          await apiClient.post(body: body, url: ApiUrl.reset(), isBasic: true);

      if (response.statusCode == 200) {
        resetMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
        AppRouter.route.goNamed(RoutePath.loginScreen);
      } else {
        resetMethod(false);
        toastMessage(
            message: response.body?['message']?.toString() ??
                "something want wrong");
      }
    } catch (err) {
      resetMethod(false);
    }
  }
}

class SignUpModel {
  final bool? success;
  final String? message;

  SignUpModel({
    this.success,
    this.message,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        success: json["success"],
        message: json["message"],
      );
}
