import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/local_db/local_db.dart';

import '../../core/route/routes.dart';
import '../../presentation/widget/custom_text/custom_text.dart';
import '../../utils/app_colors/app_colors.dart';

void showLogoutDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Center(
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 16,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "logout".tr,
                  family: "Bola",
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.blackColor,
                ),
                const Gap(12),
                CustomText(
                  text: "are_you_sure_you_want_logout".tr,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
                const Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => AppRouter.route.pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.blackColor),
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: CustomText(
                          text: "no".tr,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    const Gap(12),
                    GestureDetector(
                      onTap: () async {
                        final DBHelper helper = serviceLocator();
                        await helper.logOut();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.blackColor),
                            color: AppColors.blackColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: CustomText(
                          text: "yes".tr,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(12),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
    },
  );
}