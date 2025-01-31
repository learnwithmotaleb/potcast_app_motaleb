import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeTopSection extends StatefulWidget {
  const UserHomeTopSection({super.key, this.categories});

  final CategoryElement? categories;

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
            SizedBox(height: 25.h, width: 25.w),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Assets.images.splashLogo.image(
                  height: 60.h,
                  width: 100.w,
                  fit: BoxFit.cover,
                  color: isDarkMode ? null : AppColors.blackColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: GestureDetector(
                onTap: ()=>AppRouter.route.pushNamed(RoutePath.notificationScreen),
                child: Assets.icons.notification.svg(height: 25.h, width: 25.w),
              ),
            ),
          ],
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GestureDetector(
            onTap: () => AppRouter.route.pushNamed(RoutePath.searchScreen, extra: "all"),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.searchBoxColor, borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.search.svg(height: 22, width: 22),
                  const Gap(8),
                  CustomText(text: "what_would_you_like_to_listen".tr, color: AppColors.blackColor, fontSize: 16),
                ],
              ),
            ),
          ),
        ),
        const Gap(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "select_your_location".tr, fontSize: 12.sp, color: AppColors.blackColor, maxLines: 2, textAlign: TextAlign.start),
                              CustomText(text: controller.model.value.data?.location ?? "", fontSize: 8.sp, color: AppColors.blackColor),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80.h,
                          width: 60,
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
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen, extra: widget.categories?.id ?? ""),
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4849),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0, top: 2.0, bottom: 2.0),
                            child: CustomText(text: widget.categories?.title ?? "", fontSize: 12, color: AppColors.whiteColor, maxLines: 2, textAlign: TextAlign.start),
                          ),
                        ),
                        Expanded(child: CustomNetworkImage(imageUrl: widget.categories?.categoryImage ?? "")),
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
