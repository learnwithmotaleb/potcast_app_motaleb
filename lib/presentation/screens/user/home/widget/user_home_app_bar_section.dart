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

    print(widget.categories?.image);
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
                  CustomText(text: "what_would_you_like_to_listen".tr, color: AppColors.blackColor, fontSize: 16),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4849),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
                            child: CustomText(text: widget.categories?.title??"", color: AppColors.whiteColor, maxLines: 2, textAlign: TextAlign.start),
                          ),
                        ),
                        SizedBox(
                          height: 80.h,
                          width: 100.h,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(60),
                            ),
                            child: CustomNetworkImage(imageUrl: widget.categories?.image??""),
                          ),
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