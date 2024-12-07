import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/home/widget/user_home_categories_section.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: UserHomeTopSection(),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 8),
            sliver: SliverGrid.builder(
              itemBuilder: (BuildContext context, int index) {
                return UserHomeCategoriesSection(index: index);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 80.h,
              ),
              itemCount: controller.popularItem.length-1,
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
                      CustomText(text: "new_music".tr),
                      TextButton(
                        onPressed: () {
                          AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "new_music");
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
            padding: const EdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return MusicCard(
                  data: controller.newItem[index],
                  onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: controller.newItem[index]),
                );
              },
                childCount: controller.newItem.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: "popular_music".tr),
                  TextButton(
                    onPressed: () {
                      AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "popular_music");
                    },
                    child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return MusicCard(
                  data: controller.popularItem[index],
                  onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: controller.popularItem[index]),
                );
              }, childCount: controller.popularItem.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
class TEst extends StatefulWidget {
  const TEst({super.key});

  @override
  State<TEst> createState() => _TEstState();
}

class _TEstState extends State<TEst> {
  final controller = Get.find<UserHomeController>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 44),
      itemCount: controller.newItem.length + controller.popularItem.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            children: [
              const UserHomeTopSection(),
              const UserTopArtistsSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: "new_music".tr),
                    TextButton(
                      onPressed: () {
                        AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "new_music");
                      },
                      child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor)),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (index <= controller.newItem.length) {

          /// New Music Section--------------------------------------------------------
          return MusicCard(
            data: controller.newItem[index - 1],
            onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: controller.newItem[index - 1]),
          );
        } else if (index == controller.newItem.length + 1) {

          /// Popular Music Header------------------------------------------------------
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "popular_music".tr),
                TextButton(
                  onPressed: () {
                    AppRouter.route.pushNamed(RoutePath.seeAllScreen, extra: "popular_music");
                  },
                  child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor)),
                ),
              ],
            ),
          );
        } else if (index <= controller.newItem.length + 1 + controller.popularItem.length) {

          /// Popular Music Section-----------------------------------------------------------
          return MusicCard(
            data: controller.popularItem[index - (controller.newItem.length + 2)],
            onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: controller.popularItem[index - (controller.newItem.length + 2)]),
          );
        }
        /// No other sections after Popular Music-----------------------------------------------
        return const SizedBox.shrink(); // Placeholder for any unused indices
      },
    );
  }
}*/
