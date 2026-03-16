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
  const CreatorProfileScreen({super.key, this.creatorId = ""});

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  final controller = Get.put(CreatorProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCreatorProfile(widget.creatorId);
    });
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
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          case Status.error:
            return const Center(child: CustomText(text: "Something went wrong", color: Colors.white));
          case Status.noDataFound:
            return const Center(child: CustomText(text: "No profile found", color: Colors.white));
          case Status.internetError:
            return const Center(child: CustomText(text: "Check your internet connection", color: Colors.white));
          case Status.completed:
            final creator = controller.creatorInfo.value;
            final podcasts = controller.creatorPodcasts.value.data?.result ?? [];
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
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CustomNetworkImage(
                          imageUrl: creator?.profileImage ?? "https://preach-radio.com/wp-content/uploads/2023/04/preach-radio-logo.png",
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  // Profile Name
                  CustomText(
                    text: creator?.name ?? "Creator",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const Gap(12),
                  // Creator Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: _buildInfoItem(Iconsax.man, "Creator")),
                      const Gap(16),
                      Flexible(child: _buildInfoItem(Iconsax.music_circle, "${podcasts.length} Podcasts")),
                    ],
                  ),
                  const Gap(8),
                  if (podcasts.isNotEmpty && podcasts.first.address != null)
                    _buildInfoItem(Iconsax.location, podcasts.first.address!),
                  const Gap(32),

                  // Albums Section
                  _buildSectionHeader(
                    "Albums",
                    onTap: () => context.pushNamed(RoutePath.albumSeeAllScreen),
                  ),
                  const Gap(16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: [
                      _buildAlbumCard("Popular", Iconsax.music),
                      _buildAlbumCard("Recent", Iconsax.music_play),
                      _buildAlbumCard("Featured", Iconsax.music_square),
                      _buildAlbumCard("Top Tracks", Iconsax.audio_square),
                    ],
                  ),
                  const Gap(32),

                  // Podcasts Section
                  _buildSectionHeader(
                    "Podcasts",
                    onTap: () => context.pushNamed(
                      RoutePath.podcastListScreen,
                      extra: {'title': 'Podcasts', 'reels': false},
                    ),
                  ),
                  const Gap(16),
                  SizedBox(
                    height: 180,
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
                            duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                            url: item.podcastUrl ?? "",
                          ),
                          onTap: () {
                            Get.find<PodcastManuallyPlayController>().getPodcast(
                                firstPodcastId: item.id,
                                updateMainStatus: true
                            );
                            context.pushNamed(RoutePath.audioPlayScreen, extra: AudioPlayerModel(
                                id: item.id ?? "",
                                title: item.title ?? "",
                                image: item.coverImage ?? "",
                                url: item.podcastUrl ?? "",
                                duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                                isCreator: true,
                            ));
                          },
                        );
                      },
                    ),
                  ),
                  const Gap(32),

                  // Reels Section
                  _buildSectionHeader(
                    "Reels",
                    onTap: () => context.pushNamed(
                      RoutePath.podcastListScreen,
                      extra: {'title': 'Reels', 'reels': true},
                    ),
                  ),
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
                            duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                            url: item.podcastUrl ?? "",
                          ),
                          onTap: () {
                            Get.find<PodcastManuallyPlayController>().getPodcast(
                                firstPodcastId: item.id,
                                reels: true,
                                updateMainStatus: true
                            );
                            context.pushNamed(RoutePath.audioPlayScreen, extra: AudioPlayerModel(
                                id: item.id ?? "",
                                title: item.title ?? "",
                                image: item.coverImage ?? "",
                                url: item.podcastUrl ?? "",
                                duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                                reels: true,
                                isCreator: true,
                            ));
                          },
                        );
                      },
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            );
        }
      }),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryColor.withOpacity(0.7)),
        const Gap(6),
        Flexible(
          child: CustomText(
            text: text,
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
            textAlign: TextAlign.start,
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
        Expanded(
          child: CustomText(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.start,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: CustomText(
            text: "See All",
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2122),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
          ),
          const Gap(8),
          Icon(icon, color: AppColors.primaryColor.withOpacity(0.8), size: 32),
        ],
      ),
    );
  }
}
