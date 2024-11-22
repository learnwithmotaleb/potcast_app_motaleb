import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.splashLogo.image(height: 60.h, width: 100.w, fit: BoxFit.cover, color: isDarkMode ? null : AppColors.blackColor),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Assets.icons.notification.svg(height: 25.h,width: 25.w),
            ),
          ],
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GestureDetector(
            onTap: ()=>AppRouter.route.pushNamed(RoutePath.searchScreen,extra: "all"),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.searchBoxColor,
                  borderRadius: BorderRadius.circular(8.r)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.search.svg(height: 22, width: 22),
                  const Gap(8),
                  CustomText(text: "what_would_you_like_to_listen".tr,
                      color: AppColors.blackColor,
                      fontSize: 16),
                ],
              ),
            ),
          ),
        ),
        const Gap(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.selectCountryScreen),
                  child: Container(
                    height: 80.h,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9DCDE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "select_your_location".tr, fontSize: 8.sp, color: AppColors.blackColor, maxLines: 2, textAlign: TextAlign.start),
                              const Icon(Icons.location_on, color: Color(0xFFEF4849),),
                              Obx(() {
                                return CustomText(text: controller.location.value, fontSize: 8.sp, color: AppColors.blackColor);
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80.h,
                          width: ((width / 2) - 25) / 2,
                          child: Assets.images.flag.image(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: "genres_podcast_only"),
                  child: Container(
                    height: 80.h,
                    padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4849),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(text: "genres_podcast".tr,
                              color: AppColors.whiteColor,
                              maxLines: 2,
                              textAlign: TextAlign.start),
                        ),
                        SizedBox(
                          height: 80.h,
                          width: ((width / 2) - 25) / 2,
                          child: Assets.images.genres.image(fit: BoxFit.fitWidth),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: "classical_audio"),
                  child: Container(
                    height: 80.h,
                    padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF03346E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(text: "classical_audio".tr,
                              color: AppColors.whiteColor,
                              maxLines: 2,
                              textAlign: TextAlign.start),
                        ),
                        SizedBox(
                          height: 80.h,
                          width: ((width / 2) - 25) / 2,
                          child: Assets.images.classical.image(fit: BoxFit.fitWidth),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: "millennial_podcast"),
                  child: Container(
                    height: 80.h,
                    padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF016450),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(text: "millennial_podcast".tr,
                              color: AppColors.whiteColor,
                              maxLines: 2,
                              textAlign: TextAlign.start),
                        ),
                        SizedBox(
                          height: 80.h,
                          width: ((width / 2) - 25) / 2,
                          child: Assets.images.millennial.image(
                              fit: BoxFit.fitWidth),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
