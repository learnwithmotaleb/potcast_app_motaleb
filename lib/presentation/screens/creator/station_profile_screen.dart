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
import 'package:podcast/presentation/screens/creator/creator_profile_screen.dart';
import 'package:podcast/presentation/screens/see_all/podcast_list_screen.dart';
import 'package:podcast/presentation/widget/card/home_reels_card.dart';
import 'package:podcast/presentation/widget/card/profile_podcast_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/streaming/streaming_screen.dart';
import 'package:podcast/presentation/screens/home/model/home_model.dart';
import 'package:podcast/presentation/screens/home/model/top_fav_live_model.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class StationProfileScreen extends StatefulWidget {
  final String stationId;
  const StationProfileScreen({super.key, required this.stationId});

  @override
  State<StationProfileScreen> createState() => _StationProfileScreenState();
}

class _StationProfileScreenState extends State<StationProfileScreen>
    with TickerProviderStateMixin {
  late final StationProfileController controller;
  final _profileController = Get.find<ProfileController>();

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StationProfileController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStationProfile(widget.stationId);
    });

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    Get.delete<StationProfileController>();
    super.dispose();
  }

  Future<bool> getPermissions() async {
    try {
      if (Platform.isIOS) {
        final camera = await Permission.camera.request();
        final mic = await Permission.microphone.request();
        return camera.isGranted && mic.isGranted;
      } else {
        final camera = await Permission.camera.request();
        final mic = await Permission.microphone.request();
        return camera.isGranted && mic.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  void _showJoinHostLiveDialog(StationData stationData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.red, width: 1),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.live_tv, color: Colors.red, size: 32),
            ),
            const Gap(16),
            CustomText(
              text: "${stationData.name} is Live!",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
        content: const CustomText(
          text:
              "Would you like to join the live session and interact with the host?",
          fontSize: 14,
          color: Colors.white70,
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Maybe Later",
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _joinHostLiveSession(stationData);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                    shadowColor: Colors.red.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Join Now",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _joinHostLiveSession(StationData stationData) async {
    if (stationData.isLiveRunning) {
      final participantCode = stationData.streamRoom?.roomCodes?.firstWhere(
        (roomCode) =>
            roomCode.role == "participants" &&
            roomCode.code != null &&
            roomCode.code!.isNotEmpty,
        orElse: () => RoomCode(),
      );

      if (participantCode?.code != null) {
        final hasPermissions = await getPermissions();

        if (hasPermissions) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamingScreen(
                authToken: "",
                roomCode: participantCode!.code!,
                userName:
                    _profileController.profile.value.data?.name ?? "Viewer",
                userID: _profileController.profile.value.data?.id ??
                    "46464645645645",
              ),
            ),
          );
        } else {
          _showPermissionDialog();
        }
      } else {
        _showErrorDialog(
            "Live session is not available. Please try again in a moment.");
      }
    } else {
      _showErrorDialog(
          "Live session is starting up. Please try again in a moment.");
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            Gap(8),
            Text("Permissions Required", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          "Camera and microphone permissions are required to join the live stream.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
                const Text("Settings", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            Gap(8),
            Text("Error", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
                child:
                    CircularProgressIndicator(color: AppColors.primaryColor));
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
                    text: "No station profile found", color: Colors.white));
          case Status.internetError:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white54, size: 48),
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
            child: GestureDetector(
              onTap: () {
                if (station?.isLive == true && station != null) {
                  _showJoinHostLiveDialog(station);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (station?.isLive == true)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.6),
                                width: 4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: (station?.isLive == true)
                              ? Colors.red
                              : Colors.white.withValues(alpha: 0.1),
                          width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: (station?.isLive == true
                                  ? Colors.red
                                  : Colors.black)
                              .withValues(alpha: 0.3),
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
                  if (station?.isLive == true)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(4),
                            const Text(
                              "LIVE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
                onTap: () => context.pushNamed(RoutePath.categoriesScreen)),
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
            _buildSectionHeader("Podcasts", onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PodcastListScreen(title: "All PodCasts")));
            }),
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
            _buildSectionHeader("Reels", onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PodcastListScreen(title: "All Reels")));
            }),
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
