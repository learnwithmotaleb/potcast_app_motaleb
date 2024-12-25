import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/helper/extension/base_extension.dart';
import 'package:podcast/presentation/screens/auth/forget/forget_screen.dart';
import 'package:podcast/presentation/screens/auth/login/login_screen.dart';
import 'package:podcast/presentation/screens/auth/otp/otp_screen.dart';
import 'package:podcast/presentation/screens/auth/reset/reset_screen.dart';
import 'package:podcast/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:podcast/presentation/screens/auth/verification/verification_screen.dart';
import 'package:podcast/presentation/screens/comments/comments_screen.dart';
import 'package:podcast/presentation/screens/creator/donate/donate_screen.dart';
import 'package:podcast/presentation/screens/creator/nav/creator_nav_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/add/podcast_add_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/edit/podcast_edit_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/my_podcast_screen.dart';
import 'package:podcast/presentation/screens/intro/intro_screen.dart';
import 'package:podcast/presentation/screens/notification/notification_screen.dart';
import 'package:podcast/presentation/screens/play/audio_play_screen.dart';
import 'package:podcast/presentation/screens/playlist/add/playlist_add_screen.dart';
import 'package:podcast/presentation/screens/playlist/playlist_screen.dart';
import 'package:podcast/presentation/screens/playlist/songs/playlist_songs_screen.dart';
import 'package:podcast/presentation/screens/profile/edit/edit_profile_screen.dart';
import 'package:podcast/presentation/screens/profile/view/view_profile_screen.dart';
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
import 'package:podcast/presentation/screens/user/payment/payment_webview_screen.dart';
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
        ),

        ///======================= Auth Route =======================
       /* GoRoute(
            name: RoutePath.roleScreen,
            path: RoutePath.roleScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const RoleScreen(),
              state: state,
            ),
        ),*/
        GoRoute(
            name: RoutePath.introScreen,
            path: RoutePath.introScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const IntroScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.loginScreen,
            path: RoutePath.loginScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const LoginScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.signUpScreen,
            path: RoutePath.signUpScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const SignUpScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.verificationScreen,
            path: RoutePath.verificationScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?VerificationScreen(email: state.extra as String):const VerificationScreen(email: ""),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.forgetScreen,
            path: RoutePath.forgetScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const ForgetScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.otpScreen,
            path: RoutePath.otpScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?OtpScreen(email: state.extra as String):const OtpScreen(email: ""),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.resetScreen,
            path: RoutePath.resetScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null? ResetScreen(email: state.extra as String):const ResetScreen(email: ""),
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
            child: CommentsScreen(id: state.extra as String),
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
              child: CategoriesScreen(id: state.extra as String),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.searchScreen,
            path: RoutePath.searchScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const SearchScreen(),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.userPlayScreen,
            path: RoutePath.userPlayScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?UserPlayScreen(id: state.extra as String):const UserPlayScreen(id: ""),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.seeAllScreen,
            path: RoutePath.seeAllScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: state.extra != null?SeeAllScreen(
                title: state.extra as String,
              ):const SeeAllScreen(title: ""),
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
        GoRoute(
            name: RoutePath.playlistSongsScreen,
            path: RoutePath.playlistSongsScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: PlaylistSongsScreen(id: state.extra as String),
              state: state,
            ),
        ),
        GoRoute(
            name: RoutePath.paymentWebViewScreen,
            path: RoutePath.paymentWebViewScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: PaymentWebViewScreen(paymentUrl: state.extra as String),
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
            child: PodcastEditScreen(id: state.extra as String),
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