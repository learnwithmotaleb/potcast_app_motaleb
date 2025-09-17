import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/function/logout_dailog.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/favorite/controller/favorite_controller.dart';
import 'package:podcast/presentation/screens/history/controller/history_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
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
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Iconsax.edit_2,
                          color: AppColors.blackColor,
                        ),
                      ),*/
                      Assets.images.splashLogo.image(height: 100),
                      /*IconButton(
                        onPressed: () => AppRouter.route.pushNamed(RoutePath.editProfileScreen),
                        icon: const Icon(
                          Iconsax.edit_2,
                          color: AppColors.redColor,
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.redColor,
                      width: 3,
                    ),
                  ),
                  child: Obx(() {
                    final profileImage = _controller.profile.value.data?.profileImage ?? "";
                    const image = "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
                    final finalImage = profileImage.isNotEmpty ? profileImage : image;

                    return CustomNetworkImage(
                      borderRadius: BorderRadius.circular(50),
                      imageUrl: finalImage,
                      height: 100,
                      width: 100,
                    );
                  }),
                ),
              ),
              const SliverGap(12),
              SliverToBoxAdapter(
                child: Obx(() {
                  final data = _controller.profile.value.data;
                  return Column(
                    children: [
                      CustomText(
                        text: data?.name ?? "",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        text: DateFormat("MM - dd - yyyy")
                            .format(data?.dateOfBirth ?? DateTime.now()),
                        fontSize: 16,
                        color: AppColors.whiteColor.withValues(alpha: 0.8),
                      ),
                      CustomText(
                        text: data?.address ?? "",
                        fontSize: 16,
                        color: AppColors.whiteColor.withValues(alpha: 0.5),
                      ),
                    ],
                  );
                }),
              ),
              const SliverGap(24),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 52,
                  ),
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return _items[index];
                  }, childCount: _items.length),
                ),
              ),
              const SliverGap(12),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                sliver: SliverToBoxAdapter(
                  child: Obx(() {
                    final items = historyController.lastTenItems;

                    if (historyController.getLstLoading.value) {
                      return const CustomAlignText(text: "Recently Played");
                    }

                    if (items.isEmpty) {
                      return const SizedBox();
                    }

                    return const CustomAlignText(text: "Recently Played");
                  }),
                ),
              ),
              const SliverGap(8),
              SliverToBoxAdapter(
                child: Obx(() {
                  final items = historyController.lastTenItems;

                  if (historyController.getLstLoading.value) {
                    if (historyController.getLstLoading.value) {
                      // Show shimmer placeholders
                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 14),
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return const ProfilePodcastCardShimmer();
                          },
                        ),
                      );
                    }
                  }

                  if (items.isEmpty) {
                    return const SizedBox();
                  }

                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 14),
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
              const SliverGap(12),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                sliver: SliverToBoxAdapter(
                  child: Obx(() {
                    final items = historyController.lastTenItems;

                    if (historyController.getLstLoading.value) {
                      return const CustomAlignText(text: "My Favorites");
                    }

                    if (items.isEmpty) {
                      return const SizedBox();
                    }

                    return const CustomAlignText(text: "My Favorites");
                  }),
                ),
              ),
              const SliverGap(8),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (favoriteController.getLstLoading.value) {
                    return SizedBox(
                      height: 100,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 14),
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => const ProfilePodcastCardShimmer(),
                      ),
                    );
                  }

                  final items = favoriteController.lastTenItems;
                  if (items.isEmpty) return const SizedBox();

                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 14),
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
              const SliverGap(12),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ProfileStatusCard(
                        onTap: () => showLogoutDialog(context),
                        text: "logout".tr,
                        icon: Iconsax.logout_copy,
                      ),
                    ),
                  ],
                ),
              ),
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.redColor.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.redColor.withValues(alpha: 0.7), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(
              icon,
              color: AppColors.redColor,
            ),
            CustomText(
              text: text,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
