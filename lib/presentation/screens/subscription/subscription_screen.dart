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
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: LoadingWidget(),
        );
      }

      final offering = controller.offers.value;

      if (offering == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Subscription"),
          ),
          body: const Center(child: Text("No subscription offerings available")),
        );
      }

      return CustomPaywallScreen(
        offering: offering,
        controller: controller,
        dbHelper: controller.dbHelper,
        onDismiss: () => AppRouter.route.pop(),
      );
    });
  }
}

/*return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: LoadingWidget(),
        );
      }

      final offering = controller.offers.value;

      if (offering == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Subscription"),
          ),
          body: const Center(child: Text("No subscription offerings available")),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text("Subscription"),
        ),
        body: PaywallView(
          offering: offering,
          onRestoreCompleted: (CustomerInfo customerInfo) {
            debugPrint("Restore completed: ${customerInfo.entitlements.active}");
          },
          onRestoreError: (PurchasesError error) {
            debugPrint("Restore failed: $error");
          },
          onPurchaseCancelled: () {
            debugPrint("Purchase cancelled");
          },
          onPurchaseError: (PurchasesError error) {
            debugPrint("Purchase error: $error");
          },
          onPurchaseCompleted: (CustomerInfo customerInfo, StoreTransaction store) {
            debugPrint("Purchase completed: ${customerInfo.entitlements.active}");
          },
          onDismiss: () {
            AppRouter.route.pop();
          },
        ),
      );
    });*/

/*class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final controller = Get.find<SubscriptionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription"),
        actions: [
          Obx(() => controller.isRestoring.value
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
              : TextButton(
            onPressed: controller.restorePurchases,
            child: const Text("Restore"),
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.hasActiveSubscription)
                _buildActiveSubscriptionCard()
              else
                _buildNoSubscriptionSection(),

              const Gap(24),

              if (controller.hasActiveSubscription == false)
                _buildAvailablePackages()
              else
                _buildManagementSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActiveSubscriptionCard() {
    final entitlement = controller.activeEntitlement!;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.verified, color: Colors.green, size: 24),
                Gap(8),
                Expanded(
                  child: CustomText(
                    text: "Active Subscription",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const Gap(16),

            _buildInfoRow(
              "Plan",
              entitlement.identifier,
              Icons.star,
            ),

            _buildInfoRow(
              "Purchase Date",
              controller.getFormattedDate(entitlement.originalPurchaseDate),
              Icons.calendar_today,
            ),

            _buildInfoRow(
              "Status",
              controller.getDaysRemaining(),
              Icons.access_time,
            ),

            if (entitlement.expirationDate != null)
              _buildInfoRow(
                "Expires On",
                controller.getFormattedDate(entitlement.expirationDate),
                Icons.event,
              ),

            _buildInfoRow(
              "Auto Renew",
              entitlement.willRenew ? "Enabled" : "Disabled",
              entitlement.willRenew ? Icons.autorenew : Icons.cancel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const Gap(8),
          SizedBox(
            width: 100,
            child: CustomText(
              text: "$label:",
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSubscriptionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.subscriptions_outlined,
              size: 48,
              color: Colors.orange,
            ),
            const Gap(12),
            const CustomText(
              text: "No Active Subscription",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const Gap(8),
            CustomText(
              text: "Choose a subscription plan to unlock premium features",
              fontSize: 14,
              color: Colors.grey[600],
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailablePackages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Available Plans",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const Gap(12),

        if (controller.offers.value?.current != null)
          ...controller.offers.value!.current!.availablePackages.map((pkg) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: pkg.storeProduct.title,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const Gap(4),
                      if (pkg.storeProduct.description.isNotEmpty)
                        CustomText(
                          text: pkg.storeProduct.description,
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: pkg.storeProduct.priceString,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              CustomText(
                                text: "ID: ${pkg.identifier}",
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                          Obx(() => ElevatedButton(
                            onPressed: controller.isPurchasing.value
                                ? null
                                : () => controller.purchasePackage(pkg),
                            child: controller.isPurchasing.value
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : const Text("Subscribe"),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomText(
                text: "No subscription plans available at the moment.",
                color: Colors.red[600],
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Manage Subscription",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const Gap(12),

        Card(
          child: Column(
            children: [

              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.green),
                title: const Text("Refresh Status"),
                subtitle: const Text("Update subscription information"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: controller.fetchSubscription,
              ),

              const Divider(height: 1),

              ListTile(
                leading: const Icon(Icons.restore, color: Colors.orange),
                title: const Text("Restore Purchases"),
                subtitle: const Text("Restore previous purchases"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: controller.restorePurchases,
              ),
            ],
          ),
        ),

        const Gap(16),

        Card(
          color: Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red[700]),
                const Gap(8),
                Expanded(
                  child: CustomText(
                    text: "To cancel or request a refund, please use the 'Manage Billing' option above or contact your app store directly.",
                    fontSize: 12,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}*/
