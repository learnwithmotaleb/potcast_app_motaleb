import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/creator/podcast/add/add_icon_main_screen.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/profile/profile_screen.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import '../../home/user_home_screen.dart';
import '../../creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/screens/creator/nav/controller/creator_nav_controller.dart';

class AdminNavScreen extends StatefulWidget {
  const AdminNavScreen({super.key, required this.index});

  final int index;

  @override
  State<AdminNavScreen> createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends State<AdminNavScreen> {
  final controller = Get.find<PodcastAudioController>();
  final profileController = Get.find<ProfileController>();
  final navController = Get.find<CreatorNavController>();

  final List<Widget> _pages = [
    const UserHomeScreen(),
    const HistoryScreen(),
    const AddIconMainScreen(),
    const FavoriteScreen(),
    const ProfileScreen(isUser: false),
  ];

  @override
  void initState() {
    navController.selectedPage.value = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Obx(() {
          return _pages[navController.selectedPage.value];
        }),
        bottomNavigationBar: Obx(() {
          final index = navController.selectedPage.value;

          return BottomNavigationBar(
            currentIndex: index,
            elevation: 0,
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
            ),
            unselectedIconTheme: const IconThemeData(
              color: Color(0xFF5E5E60),
            ),
            type: BottomNavigationBarType.fixed,
            onTap: (int newIndex) {
              if (newIndex == 2) {
                buildShowModalBottomSheet(context);
              } else {
                navController.changeIndex(newIndex);
              }
            },
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Iconsax.home, size: 32), label: ""),
              const BottomNavigationBarItem(
                  icon: Icon(Iconsax.clock, size: 32), label: ""),
              const BottomNavigationBarItem(
                  icon: Icon(Iconsax.add, size: 32), label: ""),
              const BottomNavigationBarItem(
                  icon: Icon(Iconsax.lovely, size: 32), label: ""),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 32,
                  width: 32,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Obx(() {
                      final image =
                          profileController.profile.value.data?.profileImage ??
                              "";
                      const defaultImage =
                          "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";

                      return CustomNetworkImage(
                        imageUrl: image.isNotEmpty ? image : defaultImage,
                        errorIcon: Iconsax.user,
                      );
                    }),
                  ),
                ),
                label: "",
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(24),
              const CustomText(text: "Add Content Station", fontSize: 20),
              const Divider(),
              ListTile(
                leading: Assets.images.headphones.image(
                  height: 30,
                  width: 30,
                  color: AppColors.whiteColor,
                ),
                title: const Text("Upload Audio"),
                onTap: () {
                  controller.selectedScreenType.value =
                      SelectedAddPostScreenType.audio;
                  AppRouter.route.pop();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    navController.changeIndex(2);
                  });
                },
              ),
              ListTile(
                leading: Assets.images.video.image(
                  height: 30,
                  width: 30,
                  color: AppColors.whiteColor,
                ),
                title: const Text("Upload Video"),
                onTap: () {
                  controller.selectedScreenType.value =
                      SelectedAddPostScreenType.video;
                  AppRouter.route.pop();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    navController.changeIndex(2);
                  });
                },
              ),
              ListTile(
                leading: Assets.images.microphone.image(
                  height: 30,
                  width: 30,
                  color: AppColors.whiteColor,
                ),
                title: const Text("Record Audio"),
                onTap: () {
                  controller.selectedScreenType.value =
                      SelectedAddPostScreenType.record;
                  AppRouter.route.pop();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    navController.changeIndex(2);
                  });
                },
              ),
              ListTile(
                leading: Assets.images.liveStream.image(
                  height: 30,
                  width: 30,
                  color: AppColors.whiteColor,
                ),
                title: const Text("Go Live"),
                onTap: () async {
                  final granted = await getPermissions();

                  if (!context.mounted) return;

                  if (granted) {
                    controller.selectedScreenType.value =
                        SelectedAddPostScreenType.live;
                    AppRouter.route.pop();
                    Future.delayed(const Duration(milliseconds: 300), () {
                      navController.changeIndex(2);
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Permissions Required"),
                        content: const Text(
                          "Camera, microphone, and Bluetooth permissions are needed to go live.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => openAppSettings(),
                            child: const Text("Open Settings"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const Gap(44),
            ],
          ),
        );
      },
    );
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
        // final bt = await Permission.bluetoothConnect.request();

        return camera.isGranted && mic.isGranted;
        // return camera.isGranted && mic.isGranted && bt.isGranted;
      }
    } catch (_) {
      return false;
    }
  }
}
