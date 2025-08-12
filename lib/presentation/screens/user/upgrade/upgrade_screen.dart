import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/upgrade/model/upgrade_model.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/card/subscription_card.dart';
import 'controller/upgrade_controller.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  final controller = Get.find<UpgradeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => AppRouter.route.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("subscription".tr),
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Obx(() {
          return CustomButton(
            text: "pay_now".tr,
            isLoading: controller.loading.value,
            onTap: () {
              if (controller.selectedId.value.isNotEmpty) {
                controller.makeStripePayment(id: controller.selectedId.value);
              }
            },
          );
        }),
      ),
      body: PagedListView<int, Plan>(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        pagingController: controller.pagingController,
        scrollDirection: Axis.horizontal,
        builderDelegate: PagedChildBuilderDelegate<Plan>(
          itemBuilder: (context, item, index) {
            return Obx(() => SubscriptionCard(
                  select: controller.index.value == index,
                  plan: item,
                  onTap: () {
                    controller.index.value = index;
                    controller.selectedId.value = item.id ?? "";
                  },
                ));
          },
        ),
      ),
    );
  }
}
