import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  /// ====================== Get Token ====================
  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<String> getRefreshToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.refreshToken) ?? "";
  }

  /// ====================== Get User ID ==================

  Future<String> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.id) ?? "";
  }

  Future<String> getProfileId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.profileId) ?? "";
  }

  /// ====================== Get User Role ==================

  Future<String> getUserRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.role) ?? "";
  }

  /// ====================== Get User Role ==================

  Future<void> clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  /// ====================== Save User Information ==================

  Future saveUserdata({
    required String token,
    required String refreshToken,
    required String id,
    required String profileId,
    required String role,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(AppConstants.token, token);
    sharedPreferences.setString(AppConstants.refreshToken, refreshToken);
    sharedPreferences.setString(AppConstants.id, id);
    sharedPreferences.setString(AppConstants.profileId, profileId);
    sharedPreferences.setString(AppConstants.role, role);
  }

  /// ====================== Clear All Information ==================

  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((value) {
      toastMessage(message: "Logout Successful!");
      Get.deleteAll();
      AppRouter.route.goNamed(RoutePath.loginScreen);
    }).onError((error, stack) {
      AppRouter.route.goNamed(RoutePath.loginScreen);
    });
  }
}
