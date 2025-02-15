import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/user/upgrade/model/upgrade_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:readmore/readmore.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.select, required this.plan, required this.onTap});

  final bool select;
  final Plan plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double weight = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: Container(
            width: weight / 2,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: select? const Color(0xFFE67E7E) : const Color(0xFFFDECF1),
              borderRadius: select
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      // bottomLeft: Radius.circular(30)
                    )
                  : const BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(24),
                Container(
                  height: 60.h,
                  width: 60.h,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(color: select ? AppColors.whiteColor : AppColors.blackColor, shape: BoxShape.circle),
                  child: select ? Assets.icons.subscription.svg() : Assets.icons.subscriptionWhite.svg(),
                ),
                const Gap(5),
                CustomText(text: plan.name ?? "", fontWeight: FontWeight.w800, color: select? AppColors.whiteColor : AppColors.blackColor),
                const Gap(12),
                const Divider(color: Color(0xFFF8A6BD)),
                const Gap(12),
                Flexible(
                  child: ReadMoreText(plan.description??"",
                    trimMode: TrimMode.Line,
                    trimLines: 3,
                    colorClickableText: Colors.pink,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    style: const TextStyle(color: AppColors.blackColor),
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: "${plan.unitAmount ?? ""}", fontSize: 24, fontWeight: FontWeight.w800, color: select ? AppColors.whiteColor : AppColors.blackColor),
                    CustomText(text: "/${plan.interval ?? ""}", fontSize: 12, color: select ? AppColors.whiteColor : AppColors.blackColor),
                  ],
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
