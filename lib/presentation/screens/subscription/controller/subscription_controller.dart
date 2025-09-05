import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends GetxController {
  final DBHelper dbHelper = serviceLocator<DBHelper>();

  final RxBool isLoading = false.obs;
  final RxBool isPurchasing = false.obs;
  final RxBool isRestoring = false.obs;
  final Rx<Offering?> offers = Rx<Offering?>(null);
  final Rx<CustomerInfo?> customer = Rx<CustomerInfo?>(null);

  bool get hasActiveSubscription => customer.value?.entitlements.active.isNotEmpty ?? false;

  EntitlementInfo? get activeEntitlement => customer.value?.entitlements.active.values.firstOrNull;

  Future<void> fetchSubscription() async {
    isLoading.value = true;
    try {
      final offerings = await Purchases.getOfferings();
      offers.value = offerings.current;


      if (offers.value != null) {
        final availablePackages = offers.value!.availablePackages;

        for (final pkg in availablePackages) {
          debugPrint("Package identifier: ${pkg.identifier}");
          debugPrint("Product identifier: ${pkg.storeProduct.identifier}");
          debugPrint("Price: ${pkg.storeProduct.priceString}");
        }
      }

    } catch (e) {
      debugPrint("Error fetching subscription: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchasePackage(Package package) async {
    isPurchasing.value = true;

    try {
      final PurchaseResult purchaseResult = await Purchases.purchasePackage(package);
      customer.value = purchaseResult.customerInfo;

      debugPrint("Purchase successful!");
      debugPrint("Active Entitlements: ${purchaseResult.customerInfo.entitlements.active.keys.join(", ")}");

      toastMessage(message: "Subscription purchased successfully!");
    } on PlatformException catch (e) {
      if (e.code == '5') {
        toastMessage(message: "Product not available for purchase. Check SKU or testing setup.");
      } else {
        toastMessage(message: "Purchase Failed");
      }
    }  on PurchasesErrorCode catch (e) {
      debugPrint("Purchase error: ${e.toString()}");
      toastMessage(message: "Purchase Failed");
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      toastMessage(message: "Purchase Failed");
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    isRestoring.value = true;

    try {
      final CustomerInfo customerInfo = await Purchases.restorePurchases();
      customer.value = customerInfo;

      if (customerInfo.entitlements.active.isNotEmpty) {
        toastMessage(message: "Purchases restored successfully!");
      } else {
        toastMessage(message: "No active purchases found to restore.");
      }
    } catch (e) {
      debugPrint("Error restoring purchases: $e");
      toastMessage(message: "Failed to restore purchases");
    } finally {
      isRestoring.value = false;
    }
  }

  String getDaysRemaining() {
    final entitlement = activeEntitlement;
    if (entitlement?.expirationDate == null) return "Unknown";

    final expirationDate = DateTime.parse(entitlement!.expirationDate!);
    final now = DateTime.now();
    final difference = expirationDate.difference(now).inDays;

    if (difference < 0) return "Expired";
    if (difference == 0) return "Expires today";
    return "$difference days remaining";
  }

  String getFormattedDate(String? dateString) {
    if (dateString == null) return "Unknown";
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  void onReady() {
    fetchSubscription();
    super.onReady();
  }
}