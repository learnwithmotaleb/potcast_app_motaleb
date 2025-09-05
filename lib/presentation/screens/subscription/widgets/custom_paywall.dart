import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomPaywallScreen extends StatelessWidget {
  const CustomPaywallScreen({
    super.key,
    required this.offering,
    required this.onDismiss,
    required this.controller,
    required this.dbHelper,
  });

  final Offering offering;
  final VoidCallback onDismiss;
  final SubscriptionController controller;
  final DBHelper dbHelper;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: dbHelper.getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: LoadingWidget(),
          );
        }

        final role = snapshot.data ?? "";

        final relevantPackage = offering.availablePackages.firstWhereOrNull((pkg) {
          if (role == "user") {
            return pkg.storeProduct.identifier.contains("user_subscription");
          }
          if (role == "creator") {
            return pkg.storeProduct.identifier.contains("creator_subscription");
          }
          return false;
        });

        if (relevantPackage == null) {
          return const Scaffold(
            body: Center(child: Text("No subscription available for your role")),
          );
        }

        final bool isUser = role == "user";
        final userFeature = [
          "Ad-free listening",
          "Unlimited skips",
          "Build your own playlists",
          "Offline playback",
        ];

        final creatorFeature = [
          "Upload & manage your playlists",
          "Live streaming access",
          "Monetize your content",
          "Advanced analytics",
        ];

        final features = isUser ? userFeature : creatorFeature;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Go Premium"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onDismiss,
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  const CustomText(
                    text: "Get Premium Access",
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                  const CustomText(
                    text: "Our most advanced features, for our most dedicated users.",
                    fontWeight: FontWeight.w100,
                  ),
                  Text(
                    "Upgrade to enjoy these features:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                  ),
                  const Gap(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features
                        .map(
                          (f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                f,
                                style: const TextStyle(fontSize: 14, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  const Spacer(),
                  _PrimaryCTA(
                    package: relevantPackage,
                    isPurchasing: controller.isPurchasing,
                    onPurchase: (pkg) async {
                      await controller.purchasePackage(pkg);
                    },
                  ),
                  _SecondaryActions(
                    onRestore: controller.restorePurchases,
                    onManage: _launchManageSubscriptions,
                  ),
                  _LegalFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchManageSubscriptions() async {
    final uri = Platform.isAndroid
        ? Uri.parse('https://play.google.com/store/account/subscriptions')
        : Uri.parse('https://apps.apple.com/account/subscriptions');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _PrimaryCTA extends StatelessWidget {
  const _PrimaryCTA({
    required this.package,
    required this.isPurchasing,
    required this.onPurchase,
  });

  final Package? package;
  final RxBool isPurchasing;
  final Future<void> Function(Package) onPurchase;

  @override
  Widget build(BuildContext context) {
    final canBuy = package != null && !(isPurchasing.value);

    return Obx(() {
      final loading = isPurchasing.value;
      return CustomButton(
        text: _label(package),
        bgColor: const Color(0xFFf69414),
        textColor: AppColors.whiteColor,
        isLoading: loading,
        onTap: canBuy && !loading ? () => onPurchase(package!) : null,
      );
    });
  }

  String _label(Package? p) {
    if (p == null) return 'Select a plan';
    final sp = p.storeProduct;
    return 'Start Today • ${sp.priceString}/month';
  }
}

class _SecondaryActions extends StatelessWidget {
  const _SecondaryActions({
    required this.onRestore,
    required this.onManage,
  });

  final Future<void> Function() onRestore;
  final Future<void> Function() onManage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: onRestore,
          child: const Text(
            'Restore purchases',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: onManage,
          child: const Text(
            'Manage subscription',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegalFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Recurring monthly subscription. Cancel anytime in the store settings.\nPrices are localized and may vary by region.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white38, fontSize: 11, height: 1.3),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          children: [
            TextButton(
              onPressed: () {
                AppRouter.route.pushNamed(RoutePath.termsOfCondition);
              },
              child: const Text(
                "Terms",
                style: TextStyle(
                  color: Colors.white60,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                AppRouter.route.pushNamed(RoutePath.privacyPolicy);
              },
              child: const Text(
                "Privacy",
                style: TextStyle(
                  color: Colors.white60,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                AppRouter.route.pushNamed(RoutePath.supportScreen);
              },
              child: const Text(
                "Support",
                style: TextStyle(
                  color: Colors.white60,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const Gap(6),
      ],
    );
  }
}
