import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/creator/podcast/add/add_icon_main_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_controller.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/profile/profile_screen.dart';
import 'package:podcast/presentation/screens/user/home/user_home_screen.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class CreatorNavScreen extends StatefulWidget {
  const CreatorNavScreen({super.key, required this.index});

  final int index;

  @override
  State<CreatorNavScreen> createState() => _CreatorNavScreenState();
}

class _CreatorNavScreenState extends State<CreatorNavScreen> {
  int _selectedPage = 0;
  final controller = Get.find<PodcastController>();
  final _controller = Get.find<ProfileController>();

  final List<Widget> _pages = [
    const UserHomeScreen(),
    const HistoryScreen(),
    const AddIconMainScreen(),
    const FavoriteScreen(),
    const ProfileScreen(isUser: false),
  ];

  @override
  void initState() {
    _selectedPage = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        elevation: 0,
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color(0xFF5E5E60),
        ),
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if (index == 2) {
            buildShowModalBottomSheet(context);
          } else {
            setState(() {
              _selectedPage = index;
            });
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Iconsax.home, size: 32), label: ""),
          const BottomNavigationBarItem(icon: Icon(Iconsax.clock, size: 32), label: ""),
          const BottomNavigationBarItem(icon: Icon(Iconsax.add, size: 32), label: ""),
          const BottomNavigationBarItem(icon: Icon(Iconsax.lovely, size: 32), label: ""),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 32,
              width: 32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(() {
                  return CustomNetworkImage(
                    imageUrl: _controller.profile.value.data?.avatar,
                    errorIcon: Iconsax.user,
                  );
                }),
              ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(24),
                  const CustomText(text: "Add Content Station", fontSize: 20),
                  const Divider(),
                  ListTile(
                    leading: Assets.images.video.image(
                      height: 30,
                      width: 30,
                      color: AppColors.whiteColor,
                    ),
                    title: const Text("Upload Video"),
                    onTap: () {
                      controller.selectedScreenType.value = SelectedAddPostScreenType.video;
                      AppRouter.route.pop();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          _selectedPage = 2;
                        });
                      });
                    },
                  ),
                  ListTile(
                    leading: Assets.images.headphones.image(
                      height: 30,
                      width: 30,
                      color: AppColors.whiteColor,
                    ),
                    title: const Text("Upload Audio"),
                    onTap: () {
                      controller.selectedScreenType.value = SelectedAddPostScreenType.audio;
                      AppRouter.route.pop();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          _selectedPage = 2;
                        });
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
                      controller.selectedScreenType.value = SelectedAddPostScreenType.record;
                      AppRouter.route.pop();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          _selectedPage = 2;
                        });
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
                    onTap: () {
                      controller.selectedScreenType.value = SelectedAddPostScreenType.live;
                      AppRouter.route.pop();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          _selectedPage = 2;
                        });
                      });
                    },
                  ),
                  const Gap(44),
                ],
              ),
            ),
          );
  }
}
