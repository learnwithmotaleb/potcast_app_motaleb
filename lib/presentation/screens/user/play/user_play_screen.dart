import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/user/play/controller/user_play_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'widget/audio_play_section.dart';
import 'widget/user_play_bottom_section.dart';
import 'widget/user_play_loading.dart';
import 'widget/user_play_top_section.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({super.key, required this.model});

  final AudioPlayerModel model;

  @override
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> {
  final controller = Get.find<UserPlayController>();

  @override
  void initState() {
    super.initState();
    controller.playAudio(widget.model);
  }

  Future<bool> _onWillPop() async {
    AppRouter.route.goNamed(RoutePath.userNavScreen);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return controller.isLoading.value?const UserPlayLoading():ListView.builder(
          padding: const EdgeInsets.only(bottom: 44),
          itemCount: controller.newItem.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  UserPlayTopSection(),
                  const AudioPlaySection(),
                  Gap(8),
                  const UserPlayBottomSection()
                ],
              );
            } else {
              return MusicCard(data: controller.newItem[index - 1], onTap: () => controller.playAudio(controller.newItem[index - 1]));
            }
          },
        );
      }),
    );
  }
}
