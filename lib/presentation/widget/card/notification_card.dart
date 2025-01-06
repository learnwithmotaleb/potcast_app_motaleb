import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:podcast/presentation/screens/notification/model/notification_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});
  final NotificationData notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: notification.subject??"",fontSize: 14,fontWeight: FontWeight.w800,family: "Bola",color: AppColors.whiteColor),
          const Gap(5),
          CustomText(text: notification.message??"",fontSize: 12,fontWeight: FontWeight.w100,family: "Light",color: AppColors.hintTextColor),
          const Gap(5),
          Row(
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                ),
              ),
              const Gap(8),
              CustomText(text: DateFormat('d MMMM yyyy, h:mm a').format(notification.updatedAt??DateTime.now()),fontSize: 12,fontWeight: FontWeight.w100,family: "Light",color: Color(0xFF5F7691)),
            ],
          ),
          const Gap(5),
          const Divider(),
        ],
      ),
    );
  }
}
