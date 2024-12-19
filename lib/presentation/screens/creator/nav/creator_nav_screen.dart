import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/creator/podcast/my_podcast_screen.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';
import 'package:podcast/presentation/screens/profile/profile_screen.dart';
import 'package:podcast/presentation/screens/user/home/user_home_screen.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class CreatorNavScreen extends StatefulWidget {
  const CreatorNavScreen({super.key});

  @override
  State<CreatorNavScreen> createState() => _CreatorNavScreenState();
}

class _CreatorNavScreenState extends State<CreatorNavScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const UserHomeScreen(),
    const HistoryScreen(),
    const FavoriteScreen(),
    const MyPodcastScreen(isBack: false),
    const ProfileScreen(isUser: false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index){
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Assets.icons.home.svg(colorFilter: _selectedPage==0?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null), label: "home".tr,),
          BottomNavigationBarItem(icon: Assets.icons.history.svg(colorFilter: _selectedPage==1?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null), label: "history".tr),
          BottomNavigationBarItem(icon: Assets.icons.favorite.svg(colorFilter: _selectedPage==2?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null), label: "favorite".tr),
          BottomNavigationBarItem(icon: Assets.icons.myPodcast.svg(colorFilter: _selectedPage==3?null:const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)), label: "my_podcast".tr),
          BottomNavigationBarItem(icon: Assets.icons.profile.svg(colorFilter: _selectedPage==4?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null), label: "profile".tr),
        ],
      ),
    );
  }
}
