import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/card/notification_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'controller/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios,color: AppColors.whiteColor),
        ),
        title: Text("notification".tr,style: const TextStyle(color: AppColors.whiteColor),),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 44),
        itemCount: 10 + 1,
        itemBuilder: (BuildContext context, int index) {
          return NotificationCard(isRead: index % 4 == 0);
        },
      ),
    );
  }
}
