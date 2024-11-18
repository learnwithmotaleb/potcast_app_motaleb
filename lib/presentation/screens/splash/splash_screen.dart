import 'package:flutter/material.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Assets.images.splashLogo.image(color: isDarkMode?null:AppColors.blackColor),
      ),
    );
  }
}
