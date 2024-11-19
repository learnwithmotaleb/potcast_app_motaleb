import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';
import 'package:podcast/presentation/screens/creator/profile/creator_profile_screen.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class CreatorNavScreen extends StatefulWidget {
  const CreatorNavScreen({super.key});

  @override
  State<CreatorNavScreen> createState() => _CreatorNavScreenState();
}

class _CreatorNavScreenState extends State<CreatorNavScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    Container(),
    const HistoryScreen(),
    const FavoriteScreen(),
    const CreatorProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedPage,
        height: 60.h,
        items: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.home.svg(),
                CustomText(text: "home".tr,color: AppColors.primaryColor)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.history.svg(),
                CustomText(text: "history".tr,color: AppColors.primaryColor)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.favorite.svg(),
                CustomText(text: "favorite".tr,color: AppColors.primaryColor)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.profile.svg(),
                CustomText(text: "profile".tr,color: AppColors.primaryColor)
              ],
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
        animationCurve: Curves.easeInOut,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF282C30),
        buttonBackgroundColor: const Color(0xFF282C30),
      ),
    );
  }
}
