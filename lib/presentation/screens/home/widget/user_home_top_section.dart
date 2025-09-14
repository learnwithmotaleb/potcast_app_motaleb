import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeTopSection extends StatefulWidget {
  const UserHomeTopSection({super.key});

  @override
  State<UserHomeTopSection> createState() => _UserHomeTopSectionState();
}

class _UserHomeTopSectionState extends State<UserHomeTopSection> {
  final controller = Get.find<UserHomeController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(70.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 25.h, width: 25.w),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Assets.images.splashLogo.image(
                  height: 60.h,
                  width: 150.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () =>
                    AppRouter.route.pushNamed(RoutePath.notificationScreen),
                child: Assets.icons.notification.svg(height: 30.h, width: 30.w),
              ),
            ),*/
          ],
        ),
        const Gap(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GestureDetector(
            onTap: () => AppRouter.route.pushNamed(RoutePath.searchScreen),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: const Color(0xFF2A2B31),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.whiteColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.search.svg(height: 22, width: 22),
                  const Gap(8),
                  CustomText(
                      text: "what_would_you_like_to_listen".tr, fontSize: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
