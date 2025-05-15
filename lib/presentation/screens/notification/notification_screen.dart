import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/notification/model/notification_model.dart';
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("notification".tr,),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          controller.pagingController.refresh();
        },
        child: PagedListView<int, NotificationData>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<NotificationData>(
            itemBuilder: (context, item, index) {
              return NotificationCard(notification: item);
            },
          ),
        ),
      ),
    );
  }
}
