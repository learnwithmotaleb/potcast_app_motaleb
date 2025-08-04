import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/screens/user/home/widget/user_home_categories_section.dart';
import 'package:podcast/presentation/widget/bottom_nav_play_card.dart';
import 'package:podcast/presentation/widget/card/home_music_card.dart';
import 'package:podcast/presentation/widget/card/home_reels_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'widget/user_home_top_section.dart';
import 'widget/user_top_artists_section.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  final controller = Get.find<UserHomeController>();
  final profileController = Get.find<ProfileController>();
  final playController = Get.put(AudioPlayController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      bottomNavigationBar: BottomNavPlayCard(),
      body: Obx(() {
        switch (controller.loading.value) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator(),);
          case Status.internetError:
            return NoInternetCard(onTap: ()=>controller.getHome(),text: "Please check internet connection!",);
          case Status.noDataFound:
            return const Center(child: CustomText(text: "No data found!"));
          case Status.error:
            return NoInternetCard(onTap: ()=>controller.getHome());

          case Status.completed:
            final data = controller.model.value.data;

            final categoryNotEmpty = data?.categories != null && data!.categories!.isNotEmpty;
            final newNotEmpty = data?.newestPodcasts != null && data!.newestPodcasts!.isNotEmpty;
            final popularNotEmpty = data?.popularPodcasts != null && data!.popularPodcasts!.isNotEmpty;
            final reelsNotEmpty = data?.reels != null && data!.reels!.isNotEmpty;
            final albumNotEmpty = data?.albums != null && data!.albums!.isNotEmpty;

            final List<HomeCategoryElement>? categories = categoryNotEmpty ? data.categories : [];
            final List<HomeNewestPodcast>? newItem = newNotEmpty ? data.newestPodcasts : [];
            final List<HomeNewestPodcast>? popularItem = popularNotEmpty ? data.popularPodcasts : [];
            final List<HomeNewestPodcast>? reelsItem = reelsNotEmpty ? data.reels : [];
            final List<HomeAlbumItem>? albumItem = albumNotEmpty ? data.albums : [];

            return RefreshIndicator(
              onRefresh: ()async{
                profileController.getProfile();
                controller.getHome();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: UserHomeTopSection(categories: categories != null && categories.isNotEmpty?categories.first:HomeCategoryElement()),
                  ),
                  const SliverGap(8),
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 8),
                    sliver: SliverGrid.builder(
                      itemBuilder: (BuildContext context, int index) {
                        if (categories == null) {
                          return const SizedBox.shrink();
                        }
                        return UserHomeCategoriesSection(category: categories[index]);
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 85,
                      ),
                      itemCount: math.max(0, (categories?.length ?? 0) - 1), // Prevent negative count
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const UserTopArtistsSection(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: "latest".tr,fontSize: 22, fontWeight: FontWeight.w800,),
                              TextButton(
                                style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(EdgeInsets.zero)
                                ),
                                onPressed: () {
                                  AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "latest");
                                },
                                child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        itemCount: newItem?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index){
                          return HomeMusicCard(
                            data: AudioPlayerModel(
                                id: newItem?[index].id??"",
                                title: newItem?[index].title??"",
                                // categories: newItem?[index].category?.title??"",
                                image: newItem?[index].coverImage??"",
                                duration: formatDuration(newItem?[index].duration??0),
                            ),
                            onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: newItem?[index].id??""),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverGap(12),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "popular".tr,fontSize: 22, fontWeight: FontWeight.w800),
                          TextButton(
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)
                            ),
                            onPressed: () {
                              AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "popular");
                            },
                            child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        itemCount: popularItem?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index){
                          return HomeMusicCard(
                            data: AudioPlayerModel(
                                id: popularItem?[index].id??"",
                                title: popularItem?[index].title??"",
                                // categories: popularItem?[index].category?.title??"",
                                image: popularItem?[index].coverImage??"",
                              duration: formatDuration(popularItem?[index].duration??0),
                            ),
                            onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: popularItem?[index].id??""),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverGap(12),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "reels".tr,fontSize: 22, fontWeight: FontWeight.w800),
                          TextButton(
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)
                            ),
                            onPressed: () {
                              AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "short");
                            },
                            child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 250,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        itemCount: reelsItem?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index){
                          return HomeReelsCard(
                            data: AudioPlayerModel(
                                id: reelsItem?[index].id??"",
                                title: reelsItem?[index].title??"",
                                // categories: reelsItem?[index].category?.title??"",
                                image: reelsItem?[index].coverImage??"",
                              duration: formatDuration(reelsItem?[index].duration??0),
                            ),
                            onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: reelsItem?[index].id??""),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverGap(12),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "Album".tr,fontSize: 22, fontWeight: FontWeight.w800),
                          TextButton(
                            style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(EdgeInsets.zero)
                            ),
                            onPressed: () {
                              AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "popular");
                            },
                            child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        itemCount: albumItem?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index){
                          return HomeMusicCard(
                            data: AudioPlayerModel(
                                id: albumItem?[index].id??"",
                                title: albumItem?[index].name??"",
                                categories: albumItem?[index].description,
                                image: albumItem?[index].coverImage??"",
                              // duration: formatDuration(albumItem?[index].duration??0),
                            ),
                            onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: albumItem?[index].id??""),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverGap(24),
                ],
              ),
            );
        }
      },
      ),
    );
  }

  String formatDuration(num seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      final minutes = (seconds / 60).floor();
      return '$minutes min';
    }
  }
}
