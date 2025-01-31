import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/profile/profile_screen.dart';
import 'package:podcast/presentation/screens/user/home/user_home_screen.dart';

class UserNavScreen extends StatefulWidget {
  const UserNavScreen({super.key});

  @override
  State<UserNavScreen> createState() => _UserNavScreenState();
}

class _UserNavScreenState extends State<UserNavScreen> {
  int _selectedPage = 0;
  final _controller = Get.find<ProfileController>();
  final List<Widget> _pages = [
    const UserHomeScreen(),
    const HistoryScreen(),
    const FavoriteScreen(),
    const ProfileScreen(isUser: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          currentIndex: _selectedPage,
          elevation: 10,
          backgroundColor: const Color(0xff151619),
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            const BottomNavigationBarItem(icon: Icon(Iconsax.home, size: 32), label: ""),
            const BottomNavigationBarItem(icon: Icon(Iconsax.clock, size: 32), label: ""),
            const BottomNavigationBarItem(icon: Icon(Iconsax.lovely, size: 32), label: ""),
            BottomNavigationBarItem(icon: SizedBox(
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
            ), label: ""),
          ],
        ),
      ),
    );
  }
}
