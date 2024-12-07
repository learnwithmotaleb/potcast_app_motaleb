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
    return sharedPreferences.getString(AppConstants.token)??"";
  }

  /// ====================== Get User ID ==================

  Future<String> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.id)??"";
  }

  /// ====================== Get User Role ==================

  Future<String> getUserRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.role)??"";
  }

  /// ====================== Get User Role ==================

  Future<String> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.email)??"";
  }

  /// ====================== Save User Information ==================

  Future saveUserdata({
    required String token,
    required String id,
    required String email,
    required String role,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(AppConstants.token, token);
    sharedPreferences.setString(AppConstants.id, id);
    sharedPreferences.setString(AppConstants.email, email);
    sharedPreferences.setString(AppConstants.role, role);
  }

  /// ====================== Clear All Information ==================

  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((value){
      toastMessage(message: "Logout Successful!");
      Get.deleteAll();
      AppRouter.route.goNamed(RoutePath.loginScreen);
    }).onError((error,stack){
      AppRouter.route.goNamed(RoutePath.loginScreen);
    });
  }

  /// ====================== Save Selected Country ==================

  Future saveLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.location, location);
  }

  Future<String> getLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.location)??"";
  }
}