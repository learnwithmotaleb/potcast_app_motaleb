import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    List<AudioPlayerModel> newItem = [
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text("my_play_list".tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()=>AppRouter.route.pushNamed(RoutePath.playlistAddScreen),
        backgroundColor: AppColors.primaryColor,
        label: Text(
          "add_new".tr,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 44),
        itemCount: newItem.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Assets.icons.sort.svg(height: 15, width: 15, colorFilter: isDarkMode ? null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                  const Gap(5),
                  CustomText(text: "recently_added".tr, fontWeight: FontWeight.w600, fontSize: 16),
                ],
              ),
            );
          } else {
            return MusicCard(data: newItem[index - 1], onTap: () => AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: newItem[index - 1]));
          }
        },
      ),
    );
  }
}
