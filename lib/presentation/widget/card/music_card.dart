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
        padding: EdgeInsets.only(bottom: bgColor != null?12.0:5, left: 8, right: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor?? const Color(0xFF2A2B31),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
            children: [
              SizedBox(
                width: 100.w,
                height: 80.h,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
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
                            CustomText(text: data.duration??""),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 45.h,
                      width: 45.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.hintTextColor)
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
