import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';
import 'package:podcast/presentation/screens/profile/profile_screen.dart';
import 'package:podcast/presentation/screens/user/home/user_home_screen.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserNavScreen extends StatefulWidget {
  const UserNavScreen({super.key});

  @override
  State<UserNavScreen> createState() => _UserNavScreenState();
}

class _UserNavScreenState extends State<UserNavScreen> {
  int _selectedPage = 0;

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index){
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Assets.icons.home.svg(colorFilter: _selectedPage==0?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null)),
          BottomNavigationBarItem(icon: Assets.icons.history.svg(colorFilter: _selectedPage==1?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null)),
          BottomNavigationBarItem(icon: Assets.icons.favorite.svg(colorFilter: _selectedPage==2?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null)),
          BottomNavigationBarItem(icon: Assets.icons.profile.svg(colorFilter: _selectedPage==3?const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn):null)),
        ],
      ),
    );
  }
}
