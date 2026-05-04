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
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/widget/card/home_reels_card.dart';
import 'package:podcast/presentation/widget/card/profile_podcast_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import '../home/model/top_fav_live_model.dart' as station_model;

class StationProfileScreen extends StatefulWidget {
  final String stationId;
  const StationProfileScreen({super.key, required this.stationId});

  @override
  State<StationProfileScreen> createState() => _StationProfileScreenState();
}

class _StationProfileScreenState extends State<StationProfileScreen> {
  final controller = Get.put(StationProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStationProfile(widget.stationId);
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
            return const Center(child: CustomText(text: "No station profile found", color: Colors.white));
          case Status.internetError:
            return const Center(child: CustomText(text: "Check your internet connection", color: Colors.white));
          case Status.completed:
            final station = controller.stationInfo.value;
            final podcasts = controller.podcasts;
            final reels = controller.reels;

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
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CustomNetworkImage(
                          imageUrl: station?.profileImage ?? "https://preach-radio.com/wp-content/uploads/2023/04/preach-radio-logo.png",
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  
                  // Profile Name
                  CustomText(
                    text: station?.name ?? "Station Name",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const Gap(12),
                  
                  // Station Info (Gender/DOB/Location)
                  _buildSubInfoRow(station),
                  const Gap(32),

                  // Albums Section
                  if (controller.albums.isNotEmpty) ...[
                    _buildSectionHeader("Albums", onTap: () => context.pushNamed(RoutePath.albumSeeAllScreen)),
                    const Gap(16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: min(controller.albums.length, 4),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.2,
                      ),
                      itemBuilder: (context, index) {
                        final album = controller.albums[index];
                        return _buildAlbumCard(
                          album['name'] ?? "Album",
                          Iconsax.music,
                          onTap: () => context.pushNamed(
                            RoutePath.albumPodcastScreen,
                            extra: {
                              "title": album['name'],
                              "id": album['_id'],
                            },
                          ),
                        );
                      },
                    ),
                    const Gap(32),
                  ],

                  // Podcasts Section
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
                            duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                            url: item.podcastUrl ?? "",
                          ),
                          onTap: () {
                            context.pushNamed(RoutePath.audioPlayScreen, extra: AudioPlayerModel(
                                id: item.id ?? "",
                                title: item.title ?? "",
                                image: item.coverImage ?? "",
                                url: item.podcastUrl ?? "",
                                duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                                stationId: widget.stationId,
                            ));
                          },
                        );
                      },
                    ),
                  ),
                  const Gap(32),

                  // Reels Section
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
                            duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                            url: item.podcastUrl ?? "",
                          ),
                          onTap: () {
                            context.pushNamed(RoutePath.reelsScreen, extra: AudioPlayerModel(
                                id: item.id ?? "",
                                title: item.title ?? "",
                                image: item.coverImage ?? "",
                                url: item.podcastUrl ?? "",
                                duration: "${(item.duration ?? 0) ~/ 60}:${(item.duration ?? 0) % 60}",
                                reels: true,
                                stationId: widget.stationId,
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

  Widget _buildSubInfoRow(station_model.Data? station) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallInfoItem(Iconsax.man, "Male", Colors.redAccent),
            const Gap(12),
            _buildSmallInfoItem(Iconsax.calendar, "9th Feb 2002", Colors.redAccent),
          ],
        ),
        const Gap(8),
        _buildSmallInfoItem(Iconsax.location, station?.address ?? "Location", Colors.redAccent),
      ],
    );
  }

  Widget _buildSmallInfoItem(IconData icon, String text, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const Gap(4),
        CustomText(
          text: text,
          fontSize: 12,
          color: Colors.white.withOpacity(0.7),
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

  Widget _buildAlbumCard(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
            // Stack of small icons or images to mimic the screenshot
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                   Positioned(
                     right: 0,
                     bottom: 0,
                     child: Icon(icon, color: Colors.blueAccent.withOpacity(0.5), size: 24),
                   ),
                   Positioned(
                     left: 0,
                     top: 0,
                     child: Icon(icon, color: Colors.redAccent.withOpacity(0.5), size: 20),
                   ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
