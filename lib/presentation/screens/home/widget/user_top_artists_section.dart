import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/home/model/home_model.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/streaming/streaming_screen.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserTopArtistsSection extends StatefulWidget {
  const UserTopArtistsSection({super.key});

  @override
  State<UserTopArtistsSection> createState() => _UserTopArtistsSectionState();
}

class _UserTopArtistsSectionState extends State<UserTopArtistsSection>
    with TickerProviderStateMixin {
  final controller = Get.find<UserHomeController>();
  final _profileController = Get.find<ProfileController>();

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
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

  Future<void> _handleCreatorTap(TopCreator creator) async {
    if (creator.isLiveRunning) {
      final participantCode = creator.streamRoom?.roomCodes?.firstWhere(
        (roomCode) =>
            roomCode.role == "participants" && roomCode.code != null && roomCode.code!.isNotEmpty,
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
                userName: _profileController.profile.value.data?.name ?? "Viewer",
                userID: _profileController.profile.value.data?.id ?? "46464645645645",
              ),
            ),
          );
        } else {
          _showPermissionDialog();
        }
      } else {
        _showErrorDialog("Live session is not available");
      }
    } else {
      AppRouter.route.pushNamed(
        RoutePath.audioPlayScreen,
        extra: AudioPlayerModel(
          id: creator.creatorId ?? "",
          title: creator.latestPodcast?.title ?? "",
          image: creator.profileImage ?? "",
          url: creator.latestPodcast?.podcastUrl ?? "",
          artist: creator.name ?? "",
          duration: creator.donationLink ?? "",
          isCreator: true,
        ),
      );
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Settings", style: TextStyle(color: Colors.white)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Top Favorites",
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              TextButton(
                onPressed: () => AppRouter.route.pushNamed(RoutePath.seeAllTopCreator),
                child: Text(
                  "see_all".tr,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140.h,
          width: width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: (controller.model.value.data?.topCreators?.length ?? 0) + 1,
            itemBuilder: (BuildContext context, int index) {
              final creators = controller.model.value.data?.topCreators;

              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: _buildHostCard(),
                );
              }

              final item = creators != null && index - 1 < creators.length ? creators[index - 1] : null;

              if (item == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _buildCreatorCard(item),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHostCard() {
    return Container(
      width: 90.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.withValues(alpha: 0.3),
            Colors.pink.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.black, Colors.black12],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Assets.images.splashLogo.image(),
            ),
          ),
          const Gap(8),
          const CustomText(
            text: "Joe",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorCard(TopCreator creator) {
    final isLive = creator.isLiveRunning;

    return GestureDetector(
      onTap: () => _handleCreatorTap(creator),
      child: Container(
        width: 90.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isLive
                ? [Colors.red.withValues(alpha: 0.2), Colors.orange.withValues(alpha: 0.1)]
                : [Colors.grey[800]!.withValues(alpha: 0.3), Colors.grey[900]!.withValues(alpha: 0.1)],
          ),
          border: Border.all(
            color: isLive ? Colors.red.withValues(alpha: 0.6) : Colors.grey.withValues(alpha: 0.3),
            width: isLive ? 2 : 1,
          ),
          boxShadow: isLive
              ? [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isLive)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          height: 88,
                          width: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.6),
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isLive ? Colors.red : Colors.grey).withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(80.0, 80.0),
                        painter: PartialCirclePainter(
                          color: isLive ? Colors.red : AppColors.whiteColor,
                          strokeWidth: isLive ? 2.0 : 1.0,
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: CustomNetworkImage(
                              imageUrl: creator.profileImage ?? "",
                            ),
                          ),
                        ),
                      ),
                      if (isLive)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 6,
                                  width: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Gap(2),
                                const Text(
                                  "LIVE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(8),
            CustomText(
              text: _formatName(creator.name),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatName(String? name) {
    if (name == null || name.trim().isEmpty) return "Unknown";

    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts[0];
    final second = parts.length > 1 ? parts[1] : '';

    if (first.length < 6 && second.isNotEmpty) {
      return '$first $second';
    }

    return first;
  }
}

class PartialCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  PartialCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi / 2,
      5 * pi / 3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
