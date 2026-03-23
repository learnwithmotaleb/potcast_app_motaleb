import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/function/logout_dailog.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/history/controller/history_controller.dart';
import 'package:podcast/presentation/widget/card/profile_podcast_card.dart';
import 'package:podcast/presentation/widget/card/profile_podcast_shimmer.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
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
  final historyController = Get.find<HistoryController>();
  final favoriteController = Get.find<FavoriteController>();

  List<ProfileStatusCard> get _items {
    if (widget.isUser) {
      return [
        ProfileStatusCard(
          text: "Edit Profile",
          onTap: () => AppRouter.route.pushNamed(RoutePath.editProfileScreen),
          icon: Iconsax.edit_2_copy,
        ),
        ProfileStatusCard(
          text: "my_play_list",
          onTap: () => AppRouter.route.pushNamed(RoutePath.playlistScreen),
          icon: Iconsax.headphone_copy,
        ),
        ProfileStatusCard(
          text: "upgrade",
          onTap: () => AppRouter.route.pushNamed(RoutePath.subscriptionScreen),
          icon: Iconsax.diamonds_copy,
        ),
        ProfileStatusCard(
          text: "settings",
          onTap: () => AppRouter.route.pushNamed(RoutePath.settingsScreen),
          icon: Icons.settings_outlined,
        ),
        /*ProfileStatusCard(
          text: "notification",
          onTap: () => AppRouter.route.pushNamed(RoutePath.notificationScreen),
          icon: Icons.notifications_none,
        ),*/
      ];
    } else {
      return [
        ProfileStatusCard(
          text: "Edit Profile",
          onTap: () => AppRouter.route.pushNamed(RoutePath.editProfileScreen),
          icon: Iconsax.edit_2_copy,
        ),
        ProfileStatusCard(
          text: "My Contents",
          onTap: () => AppRouter.route.pushNamed(RoutePath.myPodcastScreen),
          icon: Iconsax.microphone_copy,
        ),
        ProfileStatusCard(
          text: "upgrade",
          onTap: () => AppRouter.route.pushNamed(RoutePath.subscriptionScreen),
          icon: Iconsax.diamonds_copy,
        ),
        ProfileStatusCard(
          text: "my_play_list",
          onTap: () => AppRouter.route.pushNamed(RoutePath.playlistScreen),
          icon: Iconsax.headphone,
        ),
        ProfileStatusCard(
          text: "settings",
          onTap: () => AppRouter.route.pushNamed(RoutePath.settingsScreen),
          icon: Icons.settings_outlined,
        ),
        /*ProfileStatusCard(
          text: "notification",
          onTap: () => AppRouter.route.pushNamed(RoutePath.notificationScreen),
          icon: Icons.notifications_none_outlined,
        ),*/
      ];
    }
  }

  @override
  void initState() {
    Future.wait([
      historyController.getLastTenHistory(),
      favoriteController.getLastTenFavorites(),
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async{
            Future.wait([
              historyController.getLastTenHistory(),
              favoriteController.getLastTenFavorites(),
              _controller.getProfile(),
            ]);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Modern Asymmetrical Header
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Icon(
                          Iconsax.user_copy,
                          size: 150,
                          color: AppColors.redColor.withValues(alpha: 0.05),
                        ),
                      ),
                      Column(
                        children: [
                          Center(
                            child: Assets.images.splashLogo.image(height: 70),
                          ),
                          const Gap(20),
                          // Squircle Profile Image
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(
                                  color: AppColors.redColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.redColor.withValues(alpha: 0.15),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Obx(() {
                                  final profileImage = _controller.profile.value.data?.profileImage ?? "";
                                  const image = "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
                                  final finalImage = profileImage.isNotEmpty ? profileImage : image;

                                  return CustomNetworkImage(
                                    imageUrl: finalImage,
                                    height: 110,
                                    width: 110,
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverGap(16),
              // Profile Info
              SliverToBoxAdapter(
                child: Obx(() {
                  final data = _controller.profile.value.data;
                  return Column(
                    children: [
                      CustomText(
                        text: data?.name ?? "User Name",
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                      const Gap(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.location_copy, size: 14, color: AppColors.redColor),
                          const Gap(6),
                          CustomText(
                            text: data?.address ?? "Address placeholder",
                            fontSize: 14,
                            color: AppColors.whiteColor.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
              const SliverGap(32),
              // Different Style Action Tiles
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 65,
                  ),
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return _items[index];
                  }, childCount: _items.length),
                ),
              ),
              const SliverGap(32),
              // Section with Accent Line
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Obx(() {
                    final items = historyController.lastTenItems;
                    if (items.isEmpty && !historyController.getLstLoading.value) {
                      return const SizedBox();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "Recently Played",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                                Container(
                                  height: 3,
                                  width: 40,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.redColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                AppRouter.route.pushNamed(RoutePath.historyScreen);
                              },
                                child: CustomText(
                                  text: "See All",
                                  fontSize: 13,
                                  color: AppColors.redColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                    );
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() {
                  final items = historyController.lastTenItems;

                  if (historyController.getLstLoading.value) {
                    return SizedBox(
                      height: 120,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 20),
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return const ProfilePodcastCardShimmer();
                        },
                      ),
                    );
                  }

                  if (items.isEmpty) {
                    return const SizedBox();
                  }

                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 20),
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ProfilePodcastCard(
                          data: AudioPlayerModel(
                            id: item.podcast?.id ?? "",
                            title: item.podcast?.title ?? "",
                            categories: item.podcast?.category?.name ?? "",
                            image: item.podcast?.coverImage ?? AppConstants.defaultCoverImage,
                            duration: "0.0",
                            url: "",
                          ),
                          onTap: () => AppRouter.route.pushNamed(
                            RoutePath.audioPlayScreen,
                            extra: AudioPlayerModel(
                              id: item.podcast?.id ?? "",
                              title: item.podcast?.title ?? "",
                              categories: item.podcast?.category?.name ?? "",
                              image: item.podcast?.coverImage ?? "",
                              url: "",
                              duration: formatDuration(item.podcast?.duration ?? 0),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
              const SliverGap(24),
              // Favorites Section with Accent Line
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Obx(() {
                    final items = favoriteController.lastTenItems;
                    if (items.isEmpty && !favoriteController.getLstLoading.value) {
                      return const SizedBox();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "My Favorites",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                                Container(
                                  height: 3,
                                  width: 40,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.redColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                AppRouter.route.pushNamed(RoutePath.favoriteScreen);
                              },
                                child: CustomText(
                                  text: "See All",
                                  fontSize: 13,
                                  color: AppColors.redColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                    );
                  }),
                ),
              ),
              const SliverGap(8),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (favoriteController.getLstLoading.value) {
                    return SizedBox(
                      height: 120,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 20),
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => const ProfilePodcastCardShimmer(),
                      ),
                    );
                  }

                  final items = favoriteController.lastTenItems;
                  if (items.isEmpty) return const SizedBox();

                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 20),
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ProfilePodcastCard(
                          data: AudioPlayerModel(
                            id: item.podcast?.id ?? "",
                            title: item.podcast?.title ?? "",
                            categories: item.podcast?.category?.name ?? "",
                            image: item.podcast?.coverImage ?? AppConstants.defaultCoverImage,
                            duration: "0.0",
                            url: "",
                          ),
                          onTap: () => AppRouter.route.pushNamed(
                            RoutePath.audioPlayScreen,
                            extra: AudioPlayerModel(
                              id: item.podcast?.id ?? "",
                              title: item.podcast?.title ?? "",
                              categories: item.podcast?.category?.name ?? "",
                              image: item.podcast?.coverImage ?? "",
                              url: "",
                              duration: formatDuration(item.podcast?.duration ?? 0),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
              const SliverGap(40),
              // Logout stylized button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: GestureDetector(
                    onTap: () => showLogoutDialog(context),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.redColor, width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.redColor.withValues(alpha: 0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.logout_copy, size: 22, color: AppColors.redColor),
                          const Gap(12),
                          CustomText(
                            text: "logout".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.redColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverGap(40),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(num seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      final minutes = (seconds / 60).floor();
      return '$minutes min';
    }
  }
}

class ProfileStatusCard extends StatelessWidget {
  const ProfileStatusCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1E2122),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.whiteColor.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.redColor, size: 24),
                const Gap(12),
                Expanded(
                  child: CustomText(
                    text: text.tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor,
                    maxLines: 1,
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
