import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';

void checkApi({
  required Response response,
  BuildContext? context,
}) async {
  if (response.statusCode == 401) {
    //await SharePrefsHelper.remove(AppConstants.bearerToken);
    // AppRouter.route.replaceNamed(RoutePath.loginScreen);
  } else if (response.statusCode == 503 && context != null) {
    showCustomSnackBar(response.statusText ?? "No internet connection", context: context,isError: true);
  } else if (context != null) {
    showCustomSnackBar(response.body["message"],context: context,isError: true);
  }
}