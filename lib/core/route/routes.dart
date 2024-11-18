import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/helper/extension/base_extension.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/auth/forget/forget_screen.dart';
import 'package:podcast/presentation/screens/auth/login/login_screen.dart';
import 'package:podcast/presentation/screens/auth/otp/otp_screen.dart';
import 'package:podcast/presentation/screens/auth/reset/reset_screen.dart';
import 'package:podcast/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:podcast/presentation/screens/intro/intro_screen.dart';
import 'package:podcast/presentation/screens/role/role_screen.dart';
import 'package:podcast/presentation/screens/splash/splash_screen.dart';
import 'package:podcast/presentation/screens/user/categories/categories_screen.dart';
import 'package:podcast/presentation/screens/user/country/select_country_screen.dart';
import 'package:podcast/presentation/screens/user/nav/user_nav_screen.dart';
import 'package:podcast/presentation/screens/user/play/user_play_screen.dart';
import 'package:podcast/presentation/screens/user/search/search_screen.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
      initialLocation: RoutePath.splashScreen.addBasePath,
      debugLogDiagnostics: true,
      routes: [

        ///======================= Initial Route =======================
        GoRoute(
          name: RoutePath.splashScreen,
          path: RoutePath.splashScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SplashScreen(),
            state: state,
          ),
          redirect: (context, state) {
            Future.delayed(const Duration(seconds: 6), () {
              AppRouter.route.goNamed(RoutePath.roleScreen);
            });
            return null;
          },
        ),

        ///======================= Global Route =======================
        GoRoute(
            name: RoutePath.roleScreen,
            path: RoutePath.roleScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const RoleScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.introScreen,
            path: RoutePath.introScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?IntroScreen(isUser: state.extra as bool):const IntroScreen(isUser: true),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.loginScreen,
            path: RoutePath.loginScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?LoginScreen(isUser: state.extra as bool):const LoginScreen(isUser: true),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.signUpScreen,
            path: RoutePath.signUpScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?SignUpScreen(isUser: state.extra as bool):const SignUpScreen(isUser: true),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.forgetScreen,
            path: RoutePath.forgetScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?ForgetScreen(isUser: state.extra as bool):const ForgetScreen(isUser: true),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.otpScreen,
            path: RoutePath.otpScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?OtpScreen(isUser: state.extra as bool):const OtpScreen(isUser: true),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.resetScreen,
            path: RoutePath.resetScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?ResetScreen(isUser: state.extra as bool):const ResetScreen(isUser: true),
              state: state,
            ),
        ),

        ///======================= User Route =======================
        GoRoute(
            name: RoutePath.userNavScreen,
            path: RoutePath.userNavScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const UserNavScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.selectCountryScreen,
            path: RoutePath.selectCountryScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const SelectCountryScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.categoriesScreen,
            path: RoutePath.categoriesScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null? CategoriesScreen(name: state.extra as String):const CategoriesScreen(name: "genres_podcast_only"),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.searchScreen,
            path: RoutePath.searchScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null? SearchScreen(name: state.extra as String):const CategoriesScreen(name: "genres_podcast_only"),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.userPlayScreen,
            path: RoutePath.userPlayScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?UserPlayScreen(model: state.extra as AudioPlayerModel):UserPlayScreen(model: AudioPlayerModel(image: "",id: "",title: "",album: "",artist: "",url: "")),
              state: state,
            ),
        ),
      ]);

  static CustomTransitionPage _buildPageWithAnimation({required Widget child, required GoRouterState state}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static GoRouter get route => initRoute;
}