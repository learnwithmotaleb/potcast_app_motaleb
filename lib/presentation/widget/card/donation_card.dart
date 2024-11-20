import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class DonationCard extends StatelessWidget {
  const DonationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: "date",fontSize: 10,color: AppColors.blackColor),
                Gap(5),
                CustomText(text: "3/3/21",fontSize: 10,color: AppColors.blackColor),
              ],
            ),
            const Gap(5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: "time",fontSize: 10,color: AppColors.blackColor),
                Gap(5),
                CustomText(text: "14 : 17 PM",fontSize: 10,color: AppColors.blackColor),
              ],
            ),
            const Gap(5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: "address",fontSize: 10,color: AppColors.blackColor),
                Gap(5),
                CustomText(text: "Dhaka, Bangladesh",fontSize: 10,color: AppColors.blackColor),
              ],
            ),
            const Gap(5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: "amount",fontSize: 10,color: AppColors.blackColor),
                Gap(5),
                CustomText(text: "\$39",fontSize: 10,color: AppColors.blackColor),
              ],
            ),
            const Gap(12),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFC9FAC5),
              ),
              child: CustomText(text: "donation_successful".tr,color: AppColors.blackColor,fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
