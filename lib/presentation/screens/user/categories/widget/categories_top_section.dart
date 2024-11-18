import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class CategoriesTopSection extends StatelessWidget {
  const CategoriesTopSection({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(24.h),
        GestureDetector(
          onTap: ()=>AppRouter.route.pop(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.splashLogo.image(height: 60.h, width: 100.w, fit: BoxFit.cover, color: isDarkMode ? null : AppColors.blackColor),
              const Gap(8),
              CustomText(text: "listen_and_be_happy".tr, family: "Bold", fontSize: 24.sp, fontWeight: FontWeight.w800)
            ],
          ),
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GestureDetector(
            onTap: ()=>AppRouter.route.pushNamed(RoutePath.searchScreen,extra: name),
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
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            height: 100.h,
            width: width,
            decoration: BoxDecoration(
              color: name =="genres_podcast_only"?const Color(0xFFEF4849): name == "classical_audio"?const Color(0xFF03346E):const Color(0xFF016450),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(5),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(text: name.tr,fontSize: 16, color: AppColors.whiteColor,textAlign: TextAlign.center),
                ),
                name == "genres_podcast_only"?SizedBox(
                  height: 100.h,
                  width: width / 2,
                  child: Assets.images.genresBanner.image(fit: BoxFit.cover),
                ): name == "classical_audio"?SizedBox(
                  height: 100.h,
                  width: width / 2,
                  child: Assets.images.classicalBanner.image(fit: BoxFit.cover),
                ):SizedBox(
                  height: 100.h,
                  width: width / 2,
                  child: Assets.images.millennialBanner.image(fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),
        const Gap(12),
      ],
    );
  }
}
