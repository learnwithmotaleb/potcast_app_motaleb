import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/presentation/screens/creator/controller/station_profile_controller.dart';
import 'package:podcast/presentation/widget/card/home_reels_card.dart';
import 'package:podcast/presentation/widget/card/profile_podcast_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class StationProfileScreen extends StatefulWidget {
  final String stationId;
  const StationProfileScreen({super.key, required this.stationId});

  @override
  State<StationProfileScreen> createState() => _StationProfileScreenState();
}

class _StationProfileScreenState extends State<StationProfileScreen> {
  late final StationProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StationProfileController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStationProfile(widget.stationId);
    });
  }

  @override
  void dispose() {
    Get.delete<StationProfileController>();
    super.dispose();
  }

  String _formatDuration(num? duration) {
    if (duration == null || duration == 0) return "0:00";
    final mins = duration ~/ 60;
    final secs = (duration % 60).toInt();
    return "$mins:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Obx(() {
        switch (controller.loading.value) {
          case Status.loading:
            return const Center(
                child: CircularProgressIndicator(
                    color: AppColors.primaryColor));
          case Status.error:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.white54, size: 48),
                  const Gap(16),
                  const CustomText(
                      text: "Something went wrong", color: Colors.white),
                  const Gap(16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        controller.getStationProfile(widget.stationId),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          case Status.noDataFound:
            return const Center(
                child: CustomText(
                    text: "No station profile found",
                    color: Colors.white));
          case Status.internetError:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off,
                      color: Colors.white54, size: 48),
                  const Gap(16),
                  const CustomText(
                      text: "Check your internet connection",
                      color: Colors.white),
                  const Gap(16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        controller.getStationProfile(widget.stationId),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          case Status.completed:
            return _buildProfileContent();
        }
      }),
    );
  }

  Widget _buildProfileContent() {
    final station = controller.stationInfo.value;
    final podcasts = controller.podcasts;
    final reels = controller.reels;
    final categories = controller.categories;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Profile Image
          Center(
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CustomNetworkImage(
                  imageUrl: station?.profileImage ?? "",
                ),
              ),
            ),
          ),
          const Gap(16),

          // Profile Name
          CustomText(
            text: station?.name ?? "Station",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const Gap(12),

          // Station Info (Location only — dynamic)
          if (station?.address != null && station!.address.isNotEmpty)
            _buildSmallInfoItem(
                Iconsax.location, station.address, Colors.redAccent),
          const Gap(32),

          // Albums Section (Requested to look like home categories)
          if (categories.isNotEmpty) ...[
            _buildSectionHeader("Albums",
                onTap: () =>
                    context.pushNamed(RoutePath.categoriesScreen)),
            const Gap(16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: min(categories.length, 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 85,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryCard(
                  category.name ?? "Category",
                  category.categoryImage ?? "",
                  onTap: () => context.pushNamed(
                    RoutePath.categoriesScreen,
                    extra: category.id ?? "",
                  ),
                );
              },
            ),
            const Gap(32),
          ],

          // Podcasts Section
          if (podcasts.isNotEmpty) ...[
            _buildSectionHeader("Podcasts", onTap: () {}),
            const Gap(16),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final item = podcasts[index];
                  return ProfilePodcastCard(
                    data: AudioPlayerModel(
                      id: item.id ?? "",
                      title: item.title ?? "",
                      image: item.coverImage ?? "",
                      duration: _formatDuration(item.duration),
                      url: item.podcastUrl ?? "",
                    ),
                    onTap: () {
                      context.pushNamed(RoutePath.audioPlayScreen,
                          extra: AudioPlayerModel(
                            id: item.id ?? "",
                            title: item.title ?? "",
                            image: item.coverImage ?? "",
                            url: item.podcastUrl ?? "",
                            duration: _formatDuration(item.duration),
                            stationId: widget.stationId,
                          ));
                    },
                  );
                },
              ),
            ),
            const Gap(32),
          ],

          // Reels Section
          if (reels.isNotEmpty) ...[
            _buildSectionHeader("Reels", onTap: () {}),
            const Gap(16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reels.length,
                itemBuilder: (context, index) {
                  final item = reels[index];
                  return HomeReelsCard(
                    data: AudioPlayerModel(
                      id: item.id ?? "",
                      title: item.title ?? "",
                      image: item.coverImage ?? "",
                      duration: _formatDuration(item.duration),
                      url: item.podcastUrl ?? "",
                    ),
                    onTap: () {
                      context.pushNamed(RoutePath.reelsScreen,
                          extra: AudioPlayerModel(
                            id: item.id ?? "",
                            title: item.title ?? "",
                            image: item.coverImage ?? "",
                            url: item.podcastUrl ?? "",
                            duration: _formatDuration(item.duration),
                            reels: true,
                            stationId: widget.stationId,
                            creatorImage: station?.profileImage,
                          ));
                    },
                  );
                },
              ),
            ),
          ],

          // Empty state if both sections are empty
          if (podcasts.isEmpty && reels.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Icon(Icons.library_music_outlined,
                      color: Colors.white24, size: 64),
                  Gap(16),
                  CustomText(
                    text: "No content available yet",
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          const Gap(40),
        ],
      ),
    );
  }

  Widget _buildSmallInfoItem(IconData icon, String text, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const Gap(4),
        Flexible(
          child: CustomText(
            text: text,
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: CustomText(
              text: "See All",
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2B31),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 8, right: 90, bottom: 2),
              child: CustomText(
                text: title,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                textAlign: TextAlign.start,
                maxLines: 3,
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              top: -2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomNetworkImage(
                  imageUrl: imageUrl,
                  width: 70,
                  height: 100,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
