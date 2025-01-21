import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class MusicCard extends StatelessWidget {
  const MusicCard({super.key, required this.data, required this.onTap, this.bgColor, this.onLongPress});
  final AudioPlayerModel data;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.only(bottom: bgColor != null?8.0:0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          color: bgColor??Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                width: 100.w,
                height: 80.h,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomNetworkImage(imageUrl: data.image??"")
                ),
              ),
              const Gap(8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 80.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: data.title??"",fontSize: 16,fontWeight: FontWeight.w800),
                            CustomText(text: data.categories??""),
                            Row(
                              children: [
                                CustomText(text: data.duration??""),
                                const Gap(5),
                                const Icon(Icons.location_on,size: 14,color: AppColors.primaryColor),
                                const Gap(3),
                                Assets.icons.favorite.svg(height: 10,width: 10)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50.h,
                      width: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode?const Color(0xFF1e1e1e):const Color(0xFFAAA9A9)
                      ),
                      child: Assets.icons.play.svg(height: 17.h,width: 17.h),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
