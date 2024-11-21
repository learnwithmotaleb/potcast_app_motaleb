import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserPlayBottomSection extends StatelessWidget {
  const UserPlayBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: ()=>AppRouter.route.pushNamed(RoutePath.commentsScreen),
                  child: Assets.icons.comments.svg(height: 20.h,width: 20.h),
                ),
                Assets.icons.donate.svg(height: 20.h,width: 20.h),
              ],
            ),
          ),
          const Gap(12),
          CustomText(text: "new_music".tr),
        ],
      ),
    );
  }
}
