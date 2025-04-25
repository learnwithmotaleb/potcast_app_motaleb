import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/play/widget/audio_play_control.dart';

class BottomNavPlayCard extends StatelessWidget {
  BottomNavPlayCard({super.key});

  final playController = Get.put(AudioPlayController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              AppRouter.route.pushNamed(RoutePath.userPlayScreen, extra: playController.postModel.value.data?.podcast?.id);
            },
            child: SizedBox(
              height: 60,
              width: 80,
              child: Obx(() {
                return CustomNetworkImage(
                  borderRadius: BorderRadius.circular(8.0),
                  imageUrl: playController.postModel.value.data?.podcast?.cover??"",
                );
              }),
            ),
          ),
          const Gap(24),
          const Expanded(child: AudioPlayControl(isRemove: true)),
          const Gap(12),
        ],
      ),
    );
  }
}
