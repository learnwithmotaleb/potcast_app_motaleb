import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/presentation/widget/card/custom_profile_tile.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.isUser});

  final bool isUser;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("profile".tr),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Obx(() {
                final cover = _controller.profile.value.data?.profileCover ?? "";
                return CustomNetworkImage(
                  imageUrl: cover.isNotEmpty? cover : "https://plus.unsplash.com/premium_photo-1681426414801-f36575c2de9e",
                  height: 200,
                  width: width,
                );
              }),
            ),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: SizedBox(
                width: width,
                height: height - 150,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 10,
                      right: 10,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: const BoxDecoration(
                          color: AppColors.blackColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Gap(100),
                            Obx(() => Column(
                                  children: [
                                    CustomText(
                                        text: _controller.profile.value.data?.name ?? "",
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800),
                                    const Gap(5),
                                    CustomText(
                                        text: _controller.profile.value.data?.email ?? "",
                                        fontSize: 16),
                                  ],
                                )),
                            Gap(12.h),
                            CustomProfileTile(
                              text: "personal_information",
                              icon: Iconsax.user,
                              onTap: () => AppRouter.route.pushNamed(RoutePath.viewProfileScreen),
                            ),
                            const Gap(24),
                            if (!widget.isUser)
                              Column(
                                children: [
                                  CustomProfileTile(
                                    text: "my_podcast",
                                    onTap: () =>
                                        AppRouter.route.pushNamed(RoutePath.myPodcastScreen),
                                    icon: Iconsax.music,
                                  ),
                                  const Gap(24),
                                ],
                              ),
                            CustomProfileTile(
                              text: "my_play_list",
                              onTap: () => AppRouter.route.pushNamed(RoutePath.playlistScreen),
                              icon: Iconsax.headphone,
                            ),
                            const Gap(24),
                            CustomProfileTile(
                              text: "settings",
                              icon: Iconsax.setting,
                              onTap: () => AppRouter.route.pushNamed(RoutePath.settingsScreen),
                            ),
                            const Gap(24),
                            CustomProfileTile(
                              text: "notification",
                              icon: Iconsax.notification,
                              onTap: () => AppRouter.route.pushNamed(RoutePath.notificationScreen),
                            ),
                            const Gap(24),
                            if (widget.isUser)
                              Column(
                                children: [
                                  CustomProfileTile(
                                    text: "upgrade",
                                    onTap: () => AppRouter.route.pushNamed(RoutePath.upgradeScreen),
                                    icon: Iconsax.diamonds,
                                    isIcon: true,
                                  ),
                                  const Gap(24),
                                ],
                              ),
                            GestureDetector(
                              onTap: () => showLogoutDialog(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  height: 45,
                                  width: width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.whiteColor,
                                  ),
                                  child: CustomText(
                                    text: "logout".tr,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(12),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Obx(() {
                          final profileImage = _controller.profile.value.data?.profileImage;
                          if (profileImage != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CustomNetworkImage(
                                imageUrl: profileImage.isNotEmpty? profileImage : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                height: 100,
                                width: 100,
                              ),
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.withValues(alpha: 0.6),
                            highlightColor: Colors.grey.withValues(alpha: 0.3),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: "logout".tr,
                      family: "Bola",
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: AppColors.blackColor,
                  ),
                  const Gap(12),
                  CustomText(
                      text: "are_you_sure_you_want_logout".tr,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => AppRouter.route.pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.blackColor),
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: CustomText(
                            text: "no".tr,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      const Gap(12),
                      GestureDetector(
                        onTap: () async {
                          DBHelper helper = serviceLocator();
                          await helper.logOut();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.blackColor),
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: CustomText(
                            text: "yes".tr,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }
}

class ProfileStatusCard extends StatelessWidget {
  const ProfileStatusCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: 250,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.whiteColor : const Color(0xFFB6B4B4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: child,
    );
  }
}
