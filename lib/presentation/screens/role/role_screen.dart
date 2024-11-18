import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.bannerLogo.image(
                height: 300.h,
                width: 300.w,
              ),
              Gap(44.h),
              CustomButton(
                text: "user".tr,
                onTap: () => AppRouter.route.pushNamed(RoutePath.introScreen,extra: true),
              ),
              Gap(12.h),
              CustomButton(
                text: "creator".tr,
                isBgWhite: false,
                onTap: () => AppRouter.route.pushNamed(RoutePath.introScreen ,extra: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
