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
import 'package:podcast/presentation/screens/auth/verification/verification_screen.dart';
import 'package:podcast/presentation/screens/creator/creator_profile_screen.dart';
import 'package:podcast/presentation/screens/creator/nav/creator_nav_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/my_podcast_screen.dart';
import 'package:podcast/presentation/screens/intro/intro_screen.dart';
import 'package:podcast/presentation/screens/nav/user_nav_screen.dart';
import 'package:podcast/presentation/screens/play/stream_audio_play_screen.dart';
import 'package:podcast/presentation/screens/playlist/add/playlist_add_info_screen.dart';
import 'package:podcast/presentation/screens/playlist/add/playlist_add_screen.dart';
import 'package:podcast/presentation/screens/playlist/playlist_screen.dart';
import 'package:podcast/presentation/screens/playlist/songs/playlist_songs_screen.dart';
import 'package:podcast/presentation/screens/profile/edit/edit_profile_screen.dart';
import 'package:podcast/presentation/screens/settings/about_us_screen.dart';
import 'package:podcast/presentation/screens/settings/change_password_screen.dart';
import 'package:podcast/presentation/screens/settings/privacy_policy.dart';
import 'package:podcast/presentation/screens/settings/settings_screen.dart';
import 'package:podcast/presentation/screens/settings/support_screen.dart';
import 'package:podcast/presentation/screens/settings/terms_of_condition.dart';
import 'package:podcast/presentation/screens/splash/splash_screen.dart';
import 'package:podcast/presentation/screens/streaming/streaming_screen.dart';
import 'package:podcast/presentation/screens/subscription/subscription_screen.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';

import '../../presentation/screens/album/screen/album_podcast_screen.dart';
import '../../presentation/screens/categories/categories_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/see_all/album_see_all_screen.dart';
import '../../presentation/screens/see_all/podcast_list_screen.dart';
import '../../presentation/screens/see_all/see_all_top_creator.dart';

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
            child: state.extra != null
                ? VerificationScreen(email: state.extra as String)
                : const VerificationScreen(email: ""),
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
            child: state.extra != null
                ? OtpScreen(email: state.extra as String)
                : const OtpScreen(email: ""),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.resetScreen,
          path: RoutePath.resetScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: state.extra != null
                ? ResetScreen(email: state.extra as String)
                : const ResetScreen(email: ""),
            state: state,
          ),
        ),

        ///======================= Global Route =======================
        /*GoRoute(
          name: RoutePath.viewProfileScreen,
          path: RoutePath.viewProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ViewProfileScreen(),
            state: state,
          ),
        ),*/
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
          name: RoutePath.playlistAddInfoScreen,
          path: RoutePath.playlistAddInfoScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:
                PlaylistAddInfoScreen(podcastList: state.extra as List<String>),
            state: state,
          ),
        ),
        /*GoRoute(
          name: RoutePath.notificationScreen,
          path: RoutePath.notificationScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const NotificationScreen(),
            state: state,
          ),
        ),*/
        GoRoute(
          name: RoutePath.seeAllTopCreator,
          path: RoutePath.seeAllTopCreator.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SeeAllTopCreator(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.historyScreen,
          path: RoutePath.historyScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const HistoryScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.favoriteScreen,
          path: RoutePath.favoriteScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const FavoriteScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.albumPodcastScreen,
          path: RoutePath.albumPodcastScreen.addBasePath,
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>? ?? {};
            final title = extras['title'] as String? ?? '';
            final id = extras['id'] as String? ?? '';

            return _buildPageWithAnimation(
              child: AlbumPodcastScreen(
                title: title,
                id: id,
              ),
              state: state,
            );
          },
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
        /*GoRoute(
          name: RoutePath.selectCountryScreen,
          path: RoutePath.selectCountryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SelectCountryScreen(),
            state: state,
          ),
        ),*/
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
          name: RoutePath.albumSeeAllScreen,
          path: RoutePath.albumSeeAllScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const AlbumSeeAllScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.audioPlayScreen,
          path: RoutePath.audioPlayScreen.addBasePath,
          pageBuilder: (context, state) {
            final checking = state.extra != null;

            final audioModel = AudioPlayerModel(
              id: "id",
              title: "title",
              image: "image",
              duration: "duration",
              url: "url",
            );

            final model =
                checking ? state.extra as AudioPlayerModel : audioModel;

            debugPrint(model.toJson().toString());
            return _buildPageWithAnimation(
              child: StreamAudioPlayScreen(
                id: model.id,
                title: model.title,
                image: model.image,
                duration: model.duration,
                url: model.url,
                reels: model.reels,
                popular: model.popular,
                isAlbum: model.isAlbum,
                artist: model.artist,
                isPlaylist: model.isPlaylist,
                isCreator: model.isCreator,
              ),
              state: state,
            );
          },
        ),
        /*GoRoute(
          name: RoutePath.recordPlayScreen,
          path: RoutePath.recordPlayScreen.addBasePath,
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>? ?? {};
            final url = extras['url'] as String? ?? '';
            final startPosition = extras['startPosition'] as Duration? ?? Duration.zero;
            
            return _buildPageWithAnimation(
              child: RecordPlayScreen(
                url: url,
                startPosition: startPosition,
              ),
              state: state,
            );
          },
        ),*/
        /*GoRoute(
          name: RoutePath.seeAllRecord,
          path: RoutePath.seeAllRecord.addBasePath,
          pageBuilder: (context, state) {
            return _buildPageWithAnimation(
              child: const SeeAllRecord(),
              state: state,
            );
          },
        ),*/
        GoRoute(
          name: RoutePath.podcastListScreen,
          path: RoutePath.podcastListScreen.addBasePath,
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>? ?? {};
            final title = extras['title'] as String? ?? '';
            final searchTerm = extras['searchTerm'] as String? ?? '';
            final category = extras['category'] as String? ?? '';
            final subCategory = extras['subCategory'] as String? ?? '';
            final reels = extras['reels'] as bool? ?? false;
            final popular = extras['popular'] as bool? ?? false;

            return _buildPageWithAnimation(
              child: PodcastListScreen(
                title: title,
                searchTerm: searchTerm,
                reels: reels,
                popular: popular,
                category: category,
                subCategory: subCategory,
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          name: RoutePath.streamingScreen,
          path: RoutePath.streamingScreen.addBasePath,
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>?;
            return _buildPageWithAnimation(
              child: StreamingScreen(
                userID: extras?['userID'],
                userName: extras?['userName'],
                authToken: extras?['authToken'],
                roomCode: extras?['roomCode'],
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          name: RoutePath.subscriptionScreen,
          path: RoutePath.subscriptionScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SubscriptionScreen(),
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
        /*GoRoute(
          name: RoutePath.categoryAllPodcast,
          path: RoutePath.categoryAllPodcast.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: CategoryAllPodcast(id: state.extra as String),
            state: state,
          ),
        ),*/
        /*
        GoRoute(
            name: RoutePath.adminPodcastScreen,
            path: RoutePath.adminPodcastScreen.addBasePath,
            pageBuilder: (context, state) => _buildPageWithAnimation(
              child: AdminPodcastScreen(name: state.extra as String),
              state: state,
            ),
        ),*/

        ///======================= Creator Route =======================
        GoRoute(
          name: RoutePath.creatorNavScreen,
          path: RoutePath.creatorNavScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: CreatorNavScreen(
                index: (state.extra is int) ? state.extra as int : 0),
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
          name: RoutePath.creatorProfileScreen,
          path: RoutePath.creatorProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: CreatorProfileScreen(
                creatorId: (state.extra is String) ? state.extra as String : ""),
            state: state,
          ),
        ),
/*        GoRoute(
          name: RoutePath.podcastAddScreen,
          path: RoutePath.podcastAddScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: PodcastAddScreen(isRemoveIcon: (state.extra is bool)? (state.extra as bool): false),
            state: state,
          ),
        ),*/
/*        GoRoute(
          name: RoutePath.podcastEditScreen,
          path: RoutePath.podcastEditScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: PodcastEditScreen(id: state.extra as String),
            state: state,
          ),
        ),*/

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

  static CustomTransitionPage _buildPageWithAnimation(
      {required Widget child, required GoRouterState state}) {
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
