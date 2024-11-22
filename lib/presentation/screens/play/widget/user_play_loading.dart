import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class UserPlayLoading extends StatelessWidget {
  const UserPlayLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDarkMode?AppColors.whiteColor.withOpacity(0.2):AppColors.blackColor.withOpacity(0.2),
      highlightColor: isDarkMode?AppColors.whiteColor.withOpacity(0.5):AppColors.blackColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: AppColors.searchBoxColor,
                  ),
                ),
                Positioned(
                  top: 30,
                  child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: AppColors.blackColor),onPressed: (){}),
                ),
              ],
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const Gap(5),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5,
                    width: 75.w,
                    color: AppColors.searchBoxColor,
                  ),
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 80.h,
                      width: width/3,
                      decoration: BoxDecoration(
                        color: AppColors.searchBoxColor,
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                    const Gap(5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 5,
                          width: width/3,
                          color: AppColors.searchBoxColor,
                        ),
                        const Gap(3),
                        Container(
                          height: 5,
                          width: width/2-10,
                          color: AppColors.searchBoxColor,
                        ),
                        const Gap(3),
                        Container(
                          height: 5,
                          width: width/2+20,
                          color: AppColors.searchBoxColor,
                        ),
                      ],
                    )
                  ],
                ),
                const Gap(12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ProgressBar(
                    progress: Duration.zero,
                    total: Duration.zero,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Assets.icons.favorite.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                      onPressed: (){},
                      iconSize: 36,
                    ),
                    IconButton(
                      icon: Assets.icons.audioLeft.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                      onPressed: (){},
                      iconSize: 36,
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {},
                      iconSize: 48,
                    ),
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
                const Gap(24),
                Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  decoration: BoxDecoration(
                      color:const  Color(0xFF1C1C77),
                      borderRadius: BorderRadius.circular(8.r)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Assets.icons.comments.svg(height: 20.h,width: 20.h),
                      Assets.icons.donate.svg(height: 20.h,width: 20.h),
                    ],
                  ),
                ),
                const Gap(24),
                /*
                const Gap(12),
                const AudioPlayProgress(),
                const AudioPlayControl(),
                const Gap(24),
                const AudioPlayBottom(),
                const Gap(24),*/
              ],
            ),
          )
        ],
      ),
    );
  }
}
