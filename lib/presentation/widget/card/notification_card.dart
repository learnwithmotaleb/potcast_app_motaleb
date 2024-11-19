import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.isRead});
  final bool isRead;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(text: "News Reminder",fontSize: 14,fontWeight: FontWeight.w800,family: "Bola",color: AppColors.whiteColor),
          const Gap(5),
          CustomText(text: "Founders meet and greet event",fontSize: 12,fontWeight: FontWeight.w100,family: "Light",color: isRead?AppColors.whiteColor:AppColors.hintTextColor),
          const Gap(5),
          Row(
            children: [
              isRead?Container(
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                ),
              ):const SizedBox(),
              const Gap(8),
              const CustomText(text: "8th may 2022, 2pm",fontSize: 12,fontWeight: FontWeight.w100,family: "Light",color: Color(0xFF5F7691)),
            ],
          ),
          const Gap(5),
          const Divider(),
        ],
      ),
    );
  }
}
