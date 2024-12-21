import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/user/upgrade/model/upgrade_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:readmore/readmore.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.index, required this.plan});

  final int index;
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Center(
        child: Container(
          width: width / 2,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: index == 0 ? const Color(0xFFE67E7E) : const Color(0xFFFDECF1),
            borderRadius: index == 0
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
                decoration: BoxDecoration(color: index == 0 ? AppColors.whiteColor : AppColors.blackColor, shape: BoxShape.circle),
                child: index == 0 ? Assets.icons.subscription.svg() : Assets.icons.subscriptionWhite.svg(),
              ),
              const Gap(5),
              CustomText(text: plan.name ?? "", fontWeight: FontWeight.w800, color: index == 0 ? AppColors.whiteColor : AppColors.blackColor),
              const Gap(12),
              const Divider(color: Color(0xFFF8A6BD)),
              const Gap(12),
              ReadMoreText(
                plan.description ?? "",
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: Colors.pink,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "${plan.unitAmount ?? ""}", fontSize: 24, fontWeight: FontWeight.w800, color: index == 0 ? AppColors.whiteColor : AppColors.blackColor),
                  CustomText(text: "/${plan.interval ?? ""}", fontSize: 12, color: index == 0 ? AppColors.whiteColor : AppColors.blackColor),
                ],
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
