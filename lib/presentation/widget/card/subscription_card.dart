import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Center(
        child: Container(
          width: width/2,
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
          decoration: BoxDecoration(
            color: index==0?const Color(0xFFE67E7E):const Color(0xFFFDECF1),
            borderRadius: index==0? const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              // bottomLeft: Radius.circular(30)
            ):const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)
            ),
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
                decoration: BoxDecoration(
                  color: index ==0?AppColors.whiteColor:AppColors.blackColor,
                  shape: BoxShape.circle
                ),
                child: index ==0?Assets.icons.subscription.svg():Assets.icons.subscriptionWhite.svg(),
              ),
              const Gap(5),
              CustomText(text: "subscription".tr,fontWeight: FontWeight.w800,color: index==0?AppColors.whiteColor:AppColors.blackColor),
              const Gap(12),
              const Divider(color: Color(0xFFF8A6BD)),
              const Gap(12),
              DescriptionCard(index: index,text: "limited profile views per day"),
              const Gap(5),
              DescriptionCard(index: index,text: "limited voice notes and message"),
              const Gap(5),
              DescriptionCard(index: index,text: "standard verification process"),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: index==0?"\$2.99": "\$10.99",fontSize: 24,fontWeight: FontWeight.w800,color: index==0?AppColors.whiteColor:AppColors.blackColor),
                  CustomText(text: index==0?" /monthly": " /Yearly",fontSize: 12,color: index==0?AppColors.whiteColor:AppColors.blackColor),
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

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.index,
    required this.text
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Icon(Icons.check_circle,color: index==0?AppColors.whiteColor:AppColors.blackColor,size: 24),
          const Gap(3),
          Flexible(child: CustomText(text: text,fontSize: 8,fontWeight: FontWeight.w100,maxLines: 2,textAlign: TextAlign.start,color: index==0?AppColors.whiteColor:AppColors.blackColor)),
        ],
      ),
    );
  }
}
