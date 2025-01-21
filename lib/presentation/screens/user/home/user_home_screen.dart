import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/screens/user/home/widget/user_home_app_bar.dart';
import 'package:podcast/presentation/screens/user/home/widget/user_home_categories_section.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomHomeAppBar(),
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
            final List<NewPodcastElement>? newItem = controller.model.value.data?.newPodcasts != null && controller.model.value.data!.newPodcasts!.isNotEmpty?controller.model.value.data?.newPodcasts:[];
            final List<NewPodcastElement>? popularItem = controller.model.value.data?.popularPodcasts != null && controller.model.value.data!.popularPodcasts!.isNotEmpty?controller.model.value.data?.popularPodcasts:[];

            return RefreshIndicator(
              onRefresh: ()async{
                controller.getHome();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: UserHomeTopSection(categories: categories != null && categories.isNotEmpty?categories.first:CategoryElement()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
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
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const UserTopArtistsSection(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: "latest".tr,fontSize: 16),
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
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return MusicCard(
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
                        childCount: newItem?.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "popular".tr, fontSize: 16,),
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
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return MusicCard(
                          data: AudioPlayerModel(
                              id: popularItem?[index].id??"",
                              title: popularItem?[index].title??"",
                              categories: popularItem?[index].category?.title??"",
                              image: popularItem?[index].cover??"",
                              duration: popularItem?[index].audioDuration??""
                          ),
                          onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: popularItem?[index].id??""),
                        );
                      }, childCount: popularItem?.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
      ),
    );
  }
}
