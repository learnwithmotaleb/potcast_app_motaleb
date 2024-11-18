import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/widget/align/custom_row_text.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
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
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 44),
        itemCount: controller.newItem.length + controller.popularItem.length + controller.stationItem.length + 3,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              children: [
                const UserHomeTopSection(),
                const UserTopArtistsSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomRowText(text: "new_music".tr, text1: "see_all".tr),
                ),
              ],
            );
          } else if (index <= controller.newItem.length) {
            // New Music Section
            return MusicCard(data: controller.newItem[index - 1],onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.newItem[index - 1]));
          } else if (index == controller.newItem.length + 1) {
            // Popular Music Header
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomRowText(text: "popular_music".tr, text1: "see_all".tr),
            );
          } else if (index <= controller.newItem.length + 1 + controller.popularItem.length) {
            // Popular Music Section
            return MusicCard(data: controller.popularItem[index - (controller.newItem.length + 2)],onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.popularItem[index - (controller.newItem.length + 2)]));
          } else if (index == controller.newItem.length + 2 + controller.popularItem.length) {
            // Station Music Header
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomRowText(text: "top_station".tr, text1: "see_all".tr),
            );
          } else {
            // Station Music Section
            return MusicCard(data: controller.stationItem[index - (controller.newItem.length + controller.popularItem.length + 3)],onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.stationItem[index - (controller.newItem.length + controller.popularItem.length + 3)]));
          }
        },
      ),
    );
  }
}
