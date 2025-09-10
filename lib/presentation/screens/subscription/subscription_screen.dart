import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'widgets/custom_paywall.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final controller = Get.find<SubscriptionController>();

  @override
  void initState() {
    super.initState();
    Future.wait([
      controller.fetchSubscription(),
      controller.fetchCustomerInfo(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: LoadingWidget(),
        );
      }

      final offering = controller.allOfferings.value;

/*      if (offering.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Subscription"),
          ),
          body: const Center(child: Text("No subscription offerings available")),
        );
      }*/

      return CustomPaywallScreen(
        allOffers: offering,
        controller: controller,
        dbHelper: controller.dbHelper,
        onDismiss: () => AppRouter.route.pop(),
      );
    });
  }
}
