import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/presentation/widget/card/custom_profile_tile.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () {
                  switch (_controller.loading.value) {
                    case Status.loading:
                      return const ProfileStatusCard(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    case Status.internetError:
                      return ProfileStatusCard(
                        child: NoInternetCard(
                          onTap: () => _controller.getProfile(),
                          color: AppColors.blackColor,
                        ),
                      );
                    case Status.noDataFound:
                      return const ProfileStatusCard(
                        child: Center(child: CustomText(text: "No data found!",color: AppColors.blackColor)),
                      );
                    case Status.error:
                      return ProfileStatusCard(
                        child: NoInternetCard(
                          onTap: () => _controller.getProfile(),
                          color: AppColors.blackColor,
                        ),
                      );

                    case Status.completed:
                      return Container(
                        width: width,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.whiteColor : const Color(0xFFB6B4B4),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomText(
                              text: "profile",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                            ),
                            Gap(12.h),
                            Container(
                              height: 100.h,
                              width: 100.h,
                              decoration: BoxDecoration(
                                color: _controller.profile.value.data?.avatar != null ? null : AppColors.blackColor,
                                borderRadius: BorderRadius.circular(50.0.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0.r),
                                child: _controller.profile.value.data?.avatar != null
                                    ? CachedNetworkImage(
                                        imageUrl: "${AppConstants.baseUrl}${_controller.profile.value.data?.avatar}",
                                        placeholder: (context, data) => const SizedBox(),
                                        errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(child: Icon(Icons.person, color: AppColors.whiteColor)),
                              ),
                            ),
                            Gap(8.h),
                            CustomText(
                              text: _controller.profile.value.data?.name ?? "",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                            ),
                            const Gap(2),
                            CustomText(
                              text: _controller.profile.value.data?.email ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w100,
                              color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                            ),
                            const Gap(2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "birthday",
                                  fontWeight: FontWeight.w800,
                                  color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                                ),
                                CustomText(
                                  text: " ${_controller.profile.value.data?.dateOfBirth}",
                                  fontWeight: FontWeight.w100,
                                  color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                  }
                },
              ),
              Gap(24.h),
              CustomProfileTile(
                text: "personal_information",
                icon: Assets.icons.person.svg(height: 20, width: 20, colorFilter: isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: () => AppRouter.route.pushNamed(RoutePath.viewProfileScreen),
              ),
              const Gap(24),
              widget.isUser
                  ? const SizedBox()
                  : Column(
                      children: [
                        CustomProfileTile(
                          text: "my_podcast",
                          icon: Assets.icons.myPodcast.svg(height: 20, width: 20, colorFilter: isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                          onTap: () => AppRouter.route.pushNamed(RoutePath.myPodcastScreen),
                        ),
                        const Gap(24),
                      ],
                    ),
              CustomProfileTile(
                text: "my_play_list",
                icon: Assets.icons.playList.svg(height: 20, width: 20, colorFilter: isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: () => AppRouter.route.pushNamed(RoutePath.playlistScreen),
              ),
              const Gap(24),
              widget.isUser
                  ? const SizedBox()
                  : Column(
                      children: [
                        CustomProfileTile(
                          text: "donate",
                          icon: Assets.icons.donate.svg(height: 20, width: 20, colorFilter: isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                          onTap: () => AppRouter.route.pushNamed(RoutePath.donateScreen),
                        ),
                        const Gap(24),
                      ],
                    ),
              CustomProfileTile(
                text: "settings",
                icon: Assets.icons.settings.svg(height: 20, width: 20, colorFilter: isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: () => AppRouter.route.pushNamed(RoutePath.settingsScreen),
              ),
              const Gap(24),
              CustomProfileTile(
                text: "notification",
                icon: Assets.icons.notification.svg(height: 20, width: 20, colorFilter: isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: () => AppRouter.route.pushNamed(RoutePath.notificationScreen),
              ),
              const Gap(24),
              widget.isUser
                  ? Column(
                      children: [
                        CustomProfileTile(
                          text: "upgrade",
                          icon: Assets.icons.updrade.svg(height: 20, width: 20, colorFilter: isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                          onTap: () => AppRouter.route.pushNamed(RoutePath.upgradeScreen),
                        ),
                        const Gap(24),
                      ],
                    )
                  : const SizedBox(),
              CustomProfileTile(
                text: "logout",
                icon: Assets.icons.logOut.svg(height: 20, width: 20),
                isLast: true,
                onTap: () => showLogoutDialog(context),
              ),
              const Gap(44),
            ],
          ),
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
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
                  CustomText(text: "logout".tr, family: "Bola", fontWeight: FontWeight.w800, fontSize: 22, color: AppColors.blackColor),
                  const Gap(12),
                  CustomText(text: "are_you_sure_you_want_logout".tr, fontWeight: FontWeight.w500, color: AppColors.blackColor),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => AppRouter.route.pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.blackColor), color: AppColors.whiteColor, borderRadius: BorderRadius.circular(20)),
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
                          decoration: BoxDecoration(border: Border.all(color: AppColors.blackColor), color: AppColors.blackColor, borderRadius: BorderRadius.circular(20)),
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
