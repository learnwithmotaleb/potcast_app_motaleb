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
import 'package:podcast/presentation/screens/comments/comments_screen.dart';
import 'package:podcast/presentation/screens/creator/donate/donate_screen.dart';
import 'package:podcast/presentation/screens/creator/nav/creator_nav_screen.dart';
import 'package:podcast/presentation/screens/creator/play/creator_play_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/add/podcast_add_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/edit/podcast_edit_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/my_podcast_screen.dart';
import 'package:podcast/presentation/screens/intro/intro_screen.dart';
import 'package:podcast/presentation/screens/notification/notification_screen.dart';
import 'package:podcast/presentation/screens/playlist/add/playlist_add_screen.dart';
import 'package:podcast/presentation/screens/playlist/playlist_screen.dart';
import 'package:podcast/presentation/screens/profile/edit/edit_profile_screen.dart';
import 'package:podcast/presentation/screens/profile/view/view_profile_screen.dart';
import 'package:podcast/presentation/screens/role/role_screen.dart';
import 'package:podcast/presentation/screens/see/see_all_screen.dart';
import 'package:podcast/presentation/screens/settings/about_us_screen.dart';
import 'package:podcast/presentation/screens/settings/change_password_screen.dart';
import 'package:podcast/presentation/screens/settings/privacy_policy.dart';
import 'package:podcast/presentation/screens/settings/settings_screen.dart';
import 'package:podcast/presentation/screens/settings/support_screen.dart';
import 'package:podcast/presentation/screens/settings/terms_of_condition.dart';
import 'package:podcast/presentation/screens/splash/splash_screen.dart';
import 'package:podcast/presentation/screens/user/categories/categories_screen.dart';
import 'package:podcast/presentation/screens/user/country/select_country_screen.dart';
import 'package:podcast/presentation/screens/user/nav/user_nav_screen.dart';
import 'package:podcast/presentation/screens/user/play/user_play_screen.dart';
import 'package:podcast/presentation/screens/user/search/search_screen.dart';
import 'package:podcast/presentation/screens/user/upgrade/upgrade_screen.dart';

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

        ///======================= Auth Route =======================
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

        ///======================= Global Route =======================
        GoRoute(
          name: RoutePath.viewProfileScreen,
          path: RoutePath.viewProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ViewProfileScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.editProfileScreen,
          path: RoutePath.editProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const EditProfileScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.playlistScreen,
          path: RoutePath.playlistScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PlaylistScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.playlistAddScreen,
          path: RoutePath.playlistAddScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PlaylistAddScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.notificationScreen,
          path: RoutePath.notificationScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const NotificationScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.commentsScreen,
          path: RoutePath.commentsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const CommentsScreen(),
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
        GoRoute(
            name: RoutePath.seeAllScreen,
            path: "/seeAllScreen/:title/:roll",
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: SeeAllScreen(
                title: state.pathParameters['title'] ?? '',
                roll: state.pathParameters['roll']?? '',
              ),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.upgradeScreen,
            path: RoutePath.upgradeScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const UpgradeScreen(),
              state: state,
            ),
        ),

        ///======================= Creator Route =======================
        GoRoute(
          name: RoutePath.creatorNavScreen,
          path: RoutePath.creatorNavScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const CreatorNavScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.creatorPlayScreen,
          path: RoutePath.creatorPlayScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: state.extra != null?CreatorPlayScreen(model: state.extra as AudioPlayerModel):CreatorPlayScreen(model: AudioPlayerModel(image: "",id: "",title: "",album: "",artist: "",url: "")),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.donateScreen,
          path: RoutePath.donateScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const DonateScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.myPodcastScreen,
          path: RoutePath.myPodcastScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyPodcastScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.podcastAddScreen,
          path: RoutePath.podcastAddScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PodcastAddScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.podcastEditScreen,
          path: RoutePath.podcastEditScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PodcastEditScreen(),
            state: state,
          ),
        ),


        ///======================= Other Route =======================
        GoRoute(
            name: RoutePath.settingsScreen,
            path: RoutePath.settingsScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const SettingsScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.privacyPolicy,
            path: RoutePath.privacyPolicy.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const PrivacyPolicy(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.termsOfCondition,
            path: RoutePath.termsOfCondition.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const TermsOfCondition(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.aboutUsScreen,
            path: RoutePath.aboutUsScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const AboutUsScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.changePasswordScreen,
            path: RoutePath.changePasswordScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const ChangePasswordScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.supportScreen,
            path: RoutePath.supportScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const SupportScreen(),
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