import 'package:flutter/material.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/local_db/local_db.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DBHelper dbHelper = serviceLocator();

  Future<void> _navigation() async {
    final String token = await dbHelper.getToken();
    final String roll = await dbHelper.getUserRole();

    if(token != "" && roll != ""){
      if(roll == "USER"){
        Future.delayed(const Duration(seconds: 3),(){
          AppRouter.route.goNamed(RoutePath.userNavScreen);
        });
      }else if(roll == "CREATOR"){
        Future.delayed(const Duration(seconds: 3),(){
          AppRouter.route.goNamed(RoutePath.creatorNavScreen);
        });
      }else{
        Future.delayed(const Duration(seconds: 3),(){
          AppRouter.route.goNamed(RoutePath.loginScreen);
        });
      }
    }else{
      Future.delayed(const Duration(seconds: 3),(){
        AppRouter.route.goNamed(RoutePath.introScreen);
      });
    }
  }

  @override
  void initState() {
    _navigation();
    super.initState();
  }

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
