import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/presentation/screens/creator/controller/creator_profile_controller.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/widget/card/home_reels_card.dart';
import 'package:podcast/presentation/widget/card/profile_podcast_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class CreatorProfileScreen extends StatefulWidget {
  final String creatorId;
  final String? initialName;
  final String? initialImage;

  const CreatorProfileScreen({
    super.key,
    this.creatorId = "",
    this.initialName,
    this.initialImage,
  });

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  late final CreatorProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CreatorProfileController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCreatorProfile(widget.creatorId);
    });
  }

  @override
  void dispose() {
    Get.delete<CreatorProfileController>();
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
      body: Obx(() {
        final status = controller.loading.value;
        
        // Show actual content if completed, OR show initial data while loading
        if (status == Status.completed || (status == Status.loading && widget.initialName != null)) {
          return _buildProfileBody();
        }

        switch (status) {
          case Status.loading:
            return const Center(
                child: CircularProgressIndicator(
                    color: AppColors.primaryColor));
          case Status.error:
            return _buildErrorState("Something went wrong");
          case Status.noDataFound:
            return _buildErrorState("No profile found");
          case Status.internetError:
            return _buildErrorState("Check your internet connection",
                icon: Icons.wifi_off);
          default:
            return const SizedBox();
        }
      }),
    );
  }

  Widget _buildErrorState(String message, {IconData icon = Icons.error_outline}) {
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white54, size: 48),
            const Gap(16),
            CustomText(text: message, color: Colors.white),
            const Gap(16),
            ElevatedButton.icon(
              onPressed: () =>
                  controller.getCreatorProfile(widget.creatorId),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBody() {
    final creator = controller.creatorInfo.value;
    final podcasts = controller.podcasts;
    final categories = controller.categories;
    
    // Use initial data if API hasn't loaded yet
    final String displayName = creator?.name ?? widget.initialName ?? "Creator";
    final String displayImage = creator?.profileImage ?? widget.initialImage ?? "";

    return CustomScrollView(
      slivers: [
        // ─── Collapsing header with profile image ───
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: const Color(0xFF111111),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Cover / background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColor.withValues(alpha: 0.3),
                        Colors.black,
                      ],
                    ),
                  ),
                ),

                // Profile content
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 3),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primaryColor.withValues(alpha: 0.2),
                              blurRadius: 16,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: CustomNetworkImage(
                            imageUrl: displayImage,
                          ),
                        ),
                      ),
                      const Gap(12),

                      // Name
                      CustomText(
                        text: displayName,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      const Gap(6),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatChip(
                              Iconsax.music_circle, "${podcasts.length} Podcasts"),
                          if (podcasts.isNotEmpty &&
                              podcasts.first.address != null &&
                              podcasts.first.address!.isNotEmpty) ...[
                            const Gap(12),
                            _buildStatChip(
                                Iconsax.location, podcasts.first.address!),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─── Body content ───
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.loading.value == Status.loading && podcasts.isEmpty)
                   const Padding(
                     padding: EdgeInsets.only(top: 40),
                     child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
                   )
                else ...[
                  const Gap(24),

                  // Albums Section (Categories)
                  if (categories.isNotEmpty) ...[
                    _buildSectionHeader("Albums", onTap: () {
                      context.pushNamed(RoutePath.categoriesScreen);
                    }),
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
                        final cat = categories[index];
                        return _buildCategoryCard(
                          cat.name ?? "Category",
                          cat.categoryImage ?? "",
                          onTap: () => context.pushNamed(
                            RoutePath.categoriesScreen,
                            extra: cat.id ?? "",
                          ),
                        );
                      },
                    ),
                    const Gap(32),
                  ],

                  // Podcasts Section
                  if (podcasts.isNotEmpty) ...[
                    _buildSectionHeader("Podcasts", onTap: () {
                      context.pushNamed(
                        RoutePath.podcastListScreen,
                        extra: {'title': 'Podcasts', 'reels': false},
                      );
                    }),
                    const Gap(16),
                    SizedBox(
                      height: 200,
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
                              try {
                                Get.find<PodcastManuallyPlayController>()
                                    .getPodcast(
                                  firstPodcastId: item.id,
                                  updateMainStatus: true,
                                );
                              } catch (_) {}
                              context.pushNamed(
                                RoutePath.audioPlayScreen,
                                extra: AudioPlayerModel(
                                  id: item.id ?? "",
                                  title: item.title ?? "",
                                  image: item.coverImage ?? "",
                                  url: item.podcastUrl ?? "",
                                  duration: _formatDuration(item.duration),
                                  isCreator: true,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const Gap(32),
                  ],

                  // Reels Section
                  if (podcasts.isNotEmpty) ...[
                    _buildSectionHeader("Reels", onTap: () {
                      context.pushNamed(
                        RoutePath.podcastListScreen,
                        extra: {'title': 'Reels', 'reels': true},
                      );
                    }),
                    const Gap(16),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: podcasts.length,
                        itemBuilder: (context, index) {
                          final item = podcasts[index];
                          return HomeReelsCard(
                            data: AudioPlayerModel(
                              id: item.id ?? "",
                              title: item.title ?? "",
                              image: item.coverImage ?? "",
                              duration: _formatDuration(item.duration),
                              url: item.podcastUrl ?? "",
                            ),
                            onTap: () {
                              try {
                                Get.find<PodcastManuallyPlayController>()
                                    .getPodcast(
                                  firstPodcastId: item.id,
                                  reels: true,
                                  updateMainStatus: true,
                                );
                              } catch (_) {}
                              context.pushNamed(
                                RoutePath.audioPlayScreen,
                                extra: AudioPlayerModel(
                                  id: item.id ?? "",
                                  title: item.title ?? "",
                                  image: item.coverImage ?? "",
                                  url: item.podcastUrl ?? "",
                                  duration: _formatDuration(item.duration),
                                  reels: true,
                                  isCreator: true,
                                  creatorImage: displayImage,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],

                  // Empty state
                  if (podcasts.isEmpty && categories.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
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
                    ),
                ],
                const Gap(40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 13,
              color: AppColors.primaryColor.withValues(alpha: 0.8)),
          const Gap(5),
          Flexible(
            child: CustomText(
              text: text,
              fontSize: 12,
              color: Colors.white70,
              maxLines: 1,
            ),
          ),
        ],
      ),
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
