import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import 'controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () => AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("settings".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            SettingsCard(
              onTap: () => AppRouter.route.pushNamed(RoutePath.changePasswordScreen),
              text: "change_password",
            ),
            const Gap(12),
            SettingsCard(
              onTap: () => AppRouter.route.pushNamed(RoutePath.aboutUsScreen),
              text: "about_us",
            ),
            const Gap(12),
            SettingsCard(
              onTap: () => AppRouter.route.pushNamed(RoutePath.supportScreen),
              text: "support",
            ),
            const Gap(12),
            SettingsCard(
              onTap: () => AppRouter.route.pushNamed(RoutePath.termsOfCondition),
              text: "terms_of_condition",
            ),
            const Gap(12),
            SettingsCard(
              onTap: () => AppRouter.route.pushNamed(RoutePath.privacyPolicy),
              text: "privacy_policy",
            ),
            const Gap(12),
            SettingsCard(
              onTap: () => showDeleteAccountDialog(context),
              isRed: true,
              text: "delete_account",
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    final controller = Get.find<SettingsController>();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations
          .of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 16,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(text: "do_you_want_to_delete_your".tr, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.blackColor),
                  const Gap(24),
                  Obx(() {
                    return controller.deleteLoading.value?
                    const Center(child: CircularProgressIndicator()):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.deleteAccount();
                          },
                          child: Container(
                            width: (width / 2) - 50,
                            height: 38.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.blackColor),
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: CustomText(text: "yes".tr, color: AppColors.blackColor,),
                          ),
                        ),
                        const Gap(12),
                        GestureDetector(
                          onTap: () => AppRouter.route.pop(),
                          child: Container(
                            width: (width / 2) - 50,
                            height: 38.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.blackColor),
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: CustomText(text: "no".tr, color: AppColors.whiteColor,),
                          ),
                        ),
                      ],
                    );
                  }),
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
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.onTap, required this.text, this.isRed = false});

  final VoidCallback onTap;
  final String text;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: text.tr, color: isRed ? AppColors.redColor : null),
            const Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    );
  }
}
