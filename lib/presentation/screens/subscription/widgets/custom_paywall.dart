import 'dart:io' show Platform;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/presentation/screens/subscription/controller/subscription_controller.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
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

        /*if (relevantPackage == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text("No subscription available for your role")),
          );
        }*/

        final bool isUser = role == "user";
        final userFeature = [
          {
            "icon": Icons.volume_off_outlined,
            "title": "Ad-free listening",
            "subtitle": "Enjoy uninterrupted music and podcasts"
          },
          {
            "icon": Icons.skip_next_outlined,
            "title": "Unlimited skips",
            "subtitle": "Skip as many tracks as you want"
          },
          {
            "icon": Icons.playlist_play_outlined,
            "title": "Custom playlists",
            "subtitle": "Create and organize your music"
          },
          {
            "icon": Icons.download_outlined,
            "title": "Offline playback",
            "subtitle": "Listen anywhere, anytime"
          },
        ];

        final creatorFeature = [
          {
            "icon": Icons.cloud_upload_outlined,
            "title": "Upload & manage",
            "subtitle": "Share your content with the world"
          },
          {
            "icon": Icons.live_tv_outlined,
            "title": "Live streaming",
            "subtitle": "Connect with your audience in real-time"
          },
          {
            "icon": Icons.monetization_on_outlined,
            "title": "Monetize content",
            "subtitle": "Earn from your creative work"
          },
          {
            "icon": Icons.analytics_outlined,
            "title": "Advanced analytics",
            "subtitle": "Track your performance and growth"
          },
        ];

        final features = isUser ? userFeature : creatorFeature;
        if(true){
          return ActiveSubscriptionScreen(
            isUser: isUser,
            controller: controller,
            onDismiss: onDismiss,
            onManage: _launchManageSubscriptions,
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onDismiss,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              _BackgroundLayer(),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      spacing: 12,
                      children: [
                        _HeaderSection(isUser: isUser),
                        _FeaturesList(features: features),
                        _PricingCard(
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
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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

class _BackgroundLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1DB954),
            Color(0xFF1ed760),
            Color(0xFF191414),
            Color(0xFF000000),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          ...List.generate(15, (index) => _FloatingMusicNote(
                    delay: index * 0.3,
                    left: (index * 47.0) % MediaQuery.of(context).size.width,
                    size: 20 + (index % 3) * 10,
                  ),
          ),
        ],
      ),
    );
  }
}

class _FloatingMusicNote extends StatefulWidget {
  final double delay;
  final double left;
  final double size;

  const _FloatingMusicNote({
    required this.delay,
    required this.left,
    required this.size,
  });

  @override
  _FloatingMusicNoteState createState() => _FloatingMusicNoteState();
}

class _FloatingMusicNoteState extends State<_FloatingMusicNote> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 8 + (widget.delay * 2).round()),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.left,
          top: MediaQuery.of(context).size.height * _animation.value - widget.size,
          child: Opacity(
            opacity: (1 - _animation.value) * 0.3,
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _HeaderSection extends StatelessWidget {
  final bool isUser;

  const _HeaderSection({required this.isUser});

  @override
  Widget build(BuildContext context) {
    final title = isUser ? "Premium Music Experience" : "Creator Studio Pro";
    final slogan = isUser ? "Unlock the full potential of your music journey" : "Professional tools for content creators";
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Icon(
            isUser ? Icons.headphones : Icons.mic,
            size: 60,
            color: Colors.white,
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(4),
        Text(
          slogan,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeaturesList extends StatelessWidget {
  final List<Map<String, dynamic>> features;

  const _FeaturesList({required this.features});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: features.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> feature = entry.value;

                return Column(
                  children: [
                    if (index > 0) Divider(color: Colors.white.withValues(alpha: 0.1), height: 24),
                    _FeatureItem(
                      icon: feature["icon"] as IconData,
                      title: feature["title"] as String,
                      subtitle: feature["subtitle"] as String,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1DB954), Color(0xFF1ed760)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const Gap(4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PricingCard extends StatelessWidget {
  final Package? package;
  final RxBool isPurchasing;
  final Future<void> Function(Package) onPurchase;

  const _PricingCard({
    required this.package,
    required this.isPurchasing,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1DB954),
            Color(0xFF1ed760),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DB954).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (package != null) ...[
                  Text(
                    package!.storeProduct.priceString,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "/month",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
            Text(
              "Start your premium journey today",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const Gap(16),
            Obx(() {
                return CustomButton(
                  text: "Start Premium",
                  isLoading: isPurchasing.value,
                  onTap: package != null && !isPurchasing.value ? () => onPurchase(package!) : null,
                  textColor: const Color(0xFF1DB954),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryActions extends StatelessWidget {
  final Future<void> Function() onRestore;
  final Future<void> Function() onManage;

  const _SecondaryActions({
    required this.onRestore,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onRestore,
            child: Text(
              'Restore purchases',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          width: 1,
          height: 20,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        Expanded(
          child: TextButton(
            onPressed: onManage,
            child: Text(
              'Manage subscription',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
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
      children: [
        Text(
          'Recurring monthly subscription. Cancel anytime in the store settings.\nPrices are localized and may vary by region.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const Gap(16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          children: [
            _LegalLink(
              text: "Terms",
              onTap: () => AppRouter.route.pushNamed(RoutePath.termsOfCondition),
            ),
            _LegalLink(
              text: "Privacy",
              onTap: () => AppRouter.route.pushNamed(RoutePath.privacyPolicy),
            ),
            _LegalLink(
              text: "Support",
              onTap: () => AppRouter.route.pushNamed(RoutePath.supportScreen),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _LegalLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}


class ActiveSubscriptionScreen extends StatelessWidget {
  final bool isUser;
  final SubscriptionController controller;
  final VoidCallback onDismiss;
  final Future<void> Function() onManage;

  const ActiveSubscriptionScreen({
    super.key,
    required this.isUser,
    required this.controller,
    required this.onDismiss,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final entitlement = controller.activeEntitlement;
    final daysRemaining = controller.getDaysRemaining();
    final expirationDate = controller.getFormattedDate(entitlement?.expirationDate);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onDismiss,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _BackgroundLayer(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 20,
                  children: [
                    const Gap(40),
                    _ActiveSubscriptionHeader(isUser: isUser),
                    _SubscriptionStatusCard(
                      daysRemaining: daysRemaining,
                      expirationDate: expirationDate,
                      isUser: isUser,
                    ),
                    _ActiveFeaturesList(isUser: isUser),
                    _SubscriptionManagementCard(
                      onManage: onManage,
                      onRestore: controller.restorePurchases,
                      isRestoring: controller.isRestoring,
                    ),
                    _LegalFooter(),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveSubscriptionHeader extends StatelessWidget {
  final bool isUser;

  const _ActiveSubscriptionHeader({required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1DB954), Color(0xFF1ed760)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1DB954).withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.verified,
            size: 64,
            color: Colors.white,
          ),
        ),
        const Gap(16),
        Text(
          isUser ? "Premium Active!" : "Creator Pro Active!",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          "You're enjoying all premium features",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SubscriptionStatusCard extends StatelessWidget {
  final String daysRemaining;
  final String expirationDate;
  final bool isUser;

  const _SubscriptionStatusCard({
    required this.daysRemaining,
    required this.expirationDate,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1DB954).withValues(alpha: 0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DB954).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.schedule,
                        color: Color(0xFF1DB954),
                        size: 20,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subscription Status",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            daysRemaining,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1DB954),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Plan Type",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            isUser ? "Premium Subscription" : "Pro Subscription",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Renewal Date",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            expirationDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveFeaturesList extends StatelessWidget {
  final bool isUser;

  const _ActiveFeaturesList({required this.isUser});

  @override
  Widget build(BuildContext context) {
    final userFeatures = [
      {"icon": Icons.check_circle, "title": "Ad-free listening", "status": "Active"},
      {"icon": Icons.check_circle, "title": "Unlimited skips", "status": "Active"},
      {"icon": Icons.check_circle, "title": "Custom playlists", "status": "Active"},
      {"icon": Icons.check_circle, "title": "Offline playback", "status": "Active"},
    ];

    final creatorFeatures = [
      {"icon": Icons.check_circle, "title": "Upload & manage", "status": "Active"},
      {"icon": Icons.check_circle, "title": "Live streaming", "status": "Active"},
      {"icon": Icons.check_circle, "title": "Monetize content", "status": "Active"},
      {"icon": Icons.check_circle, "title": "Advanced analytics", "status": "Active"},
    ];

    final features = isUser ? userFeatures : creatorFeatures;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Active Features",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Gap(16),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        feature["icon"] as IconData,
                        color: const Color(0xFF1DB954),
                        size: 24,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          feature["title"] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          feature["status"] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1DB954),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionManagementCard extends StatelessWidget {
  final Future<void> Function() onManage;
  final Future<void> Function() onRestore;
  final RxBool isRestoring;

  const _SubscriptionManagementCard({
    required this.onManage,
    required this.onRestore,
    required this.isRestoring,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: onManage,
                    icon: const Icon(Icons.settings),
                    label: const Text("Manage Subscription"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: isRestoring.value ? null : onRestore,
                    icon: isRestoring.value
                        ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    )
                        : const Icon(Icons.refresh),
                    label: Text(isRestoring.value ? "Restoring..." : "Restore Purchases"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.8),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}