import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class UserPlayLoading extends StatelessWidget {
  const UserPlayLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: isDarkMode?AppColors.whiteColor.withOpacity(0.2):AppColors.blackColor.withOpacity(0.2),
        highlightColor: isDarkMode?AppColors.whiteColor.withOpacity(0.5):AppColors.blackColor.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.images.splashLogo.image(height: 60.h, width: 100.w, fit: BoxFit.cover),
                const Gap(8),
                CustomText(text: "listen_and_be_happy".tr, family: "Bold", fontSize: 24.sp, fontWeight: FontWeight.w800)
              ],
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: width,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                    color: AppColors.searchBoxColor,
                    borderRadius: BorderRadius.circular(8.r)
                ),
              ),
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomText(text: "for_you".tr,fontSize: 16,),
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 60.h,
                      padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4849),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF03346E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF016450),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomText(text: "new_music".tr),
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: 250.h,
                width: width,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 250.h,
                        width: width/2+100.h,
                        decoration: BoxDecoration(
                            color: AppColors.searchBoxColor,
                            borderRadius: BorderRadius.circular(8.r)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 250.h,
                        width: width/2+100.h,
                        decoration: BoxDecoration(
                            color: AppColors.searchBoxColor,
                            borderRadius: BorderRadius.circular(8.r)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: ProgressBar(
                progress: Duration.zero,
                total: Duration.zero,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Assets.icons.audioLeft.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                      onPressed: (){},
                      iconSize: 36,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {},
                    iconSize: 48,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Assets.icons.audioRight.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onPressed: (){},
                        iconSize: 36,
                      ),
                      LikeButton(
                        likeBuilder: (bool isLiked) {
                          return Icon(Iconsax.like_1, color:isDarkMode?AppColors.whiteColor:AppColors.blackColor);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 22),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r)
                ),
              ),
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomText(text: "new_music".tr),
            ),
            ListView.builder(
              itemCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                            color: AppColors.searchBoxColor,
                            borderRadius: BorderRadius.circular(8.r)
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 12,
                                    decoration: BoxDecoration(
                                        color: AppColors.searchBoxColor,
                                        borderRadius: BorderRadius.circular(8.r)
                                    ),
                                  ),
                                  const Gap(12),
                                  Container(
                                    height: 12,
                                    decoration: BoxDecoration(
                                        color: AppColors.searchBoxColor,
                                        borderRadius: BorderRadius.circular(8.r)
                                    ),
                                  ),
                                  const Gap(12),
                                  Row(
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: AppColors.searchBoxColor,
                                            borderRadius: BorderRadius.circular(8.r)
                                        ),
                                      ),
                                      const Gap(5),
                                      const Icon(Icons.location_on,size: 14,color: AppColors.primaryColor),
                                      const Gap(3),
                                      Assets.icons.favorite.svg(height: 10,width: 10)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            Container(
                              height: 50.h,
                              width: 50.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDarkMode?const Color(0xFF1e1e1e):const Color(0xFFAAA9A9)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
