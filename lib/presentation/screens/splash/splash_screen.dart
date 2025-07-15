import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
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
  final DBHelper dbHelper = serviceLocator<DBHelper>();

  Future<void> _navigation() async {
    try{
      final String token = await dbHelper.getToken();
      final String roll = await dbHelper.getUserRole();
      bool hasExpired = JwtDecoder.isExpired(token);

      await Future.delayed(const Duration(seconds: 3));

      if(token != "" && roll != "" && !hasExpired){
        if(roll == "user"){
          AppRouter.route.goNamed(RoutePath.userNavScreen);
        }else if(roll == "creator"){
          AppRouter.route.goNamed(RoutePath.creatorNavScreen);
        }else{
          AppRouter.route.goNamed(RoutePath.loginScreen);
        }
      }else{
        AppRouter.route.goNamed(RoutePath.introScreen);
      }
    }catch(_){
      AppRouter.route.goNamed(RoutePath.introScreen);
    }
  }

  @override
  void initState() {
    _navigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Assets.images.splashLogo.image(),
      ),
    );
  }
}
