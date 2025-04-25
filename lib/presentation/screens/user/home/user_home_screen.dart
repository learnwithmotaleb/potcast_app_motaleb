import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/screens/play/widget/audio_play_control.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/screens/user/home/widget/user_home_categories_section.dart';
import 'package:podcast/presentation/widget/bottom_nav_play_card.dart';
import 'package:podcast/presentation/widget/card/home_music_card.dart';
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
      bottomNavigationBar: Obx((){
        return playController.isPlaying.value? BottomNavPlayCard(): const SizedBox();
      }),
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

            final List<CategoryElement>? categories = controller.model.value.data?.categories != null && controller.model.value.data!.categories!.isNotEmpty?controller.model.value.data?.categories:[];
            final List<Podcast>? newItem = controller.model.value.data?.newPodcasts != null && controller.model.value.data!.newPodcasts!.isNotEmpty?controller.model.value.data?.newPodcasts:[];
            final List<Podcast>? popularItem = controller.model.value.data?.popularPodcasts != null && controller.model.value.data!.popularPodcasts!.isNotEmpty?controller.model.value.data?.popularPodcasts:[];
            final List<Podcast>? reelsItem = controller.model.value.data?.shortPodcasts != null && controller.model.value.data!.shortPodcasts!.isNotEmpty?controller.model.value.data?.shortPodcasts:[];

            return RefreshIndicator(
              onRefresh: ()async{
                profileController.getProfile();
                controller.getHome();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: UserHomeTopSection(categories: categories != null && categories.isNotEmpty?categories.first:CategoryElement()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 8),
                    sliver: SliverGrid.builder(
                      itemBuilder: (BuildContext context, int index) {
                        if (categories == null || index + 1 >= categories.length) {
                          return const SizedBox.shrink();
                        }
                        return UserHomeCategoriesSection(category: categories[index + 1]);
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 70,
                      ),
                      itemCount: math.max(0, (categories?.length ?? 0) - 1), // Prevent negative count
                    ),
                  ),
                  const SliverGap(12),
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
                                categories: newItem?[index].category?.title??"",
                                image: newItem?[index].cover??"",
                                duration: newItem?[index].audioDuration??""
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
                                categories: popularItem?[index].category?.title??"",
                                image: popularItem?[index].cover??"",
                                duration: popularItem?[index].audioDuration??""
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
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        itemCount: reelsItem?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index){
                          return HomeMusicCard(
                            data: AudioPlayerModel(
                                id: reelsItem?[index].id??"",
                                title: reelsItem?[index].title??"",
                                categories: reelsItem?[index].category?.title??"",
                                image: reelsItem?[index].cover??"",
                                duration: reelsItem?[index].audioDuration??""
                            ),
                            onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: reelsItem?[index].id??""),
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
}
