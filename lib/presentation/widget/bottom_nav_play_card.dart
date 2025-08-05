import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marquee/marquee.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class BottomNavPlayCard extends StatelessWidget {
  BottomNavPlayCard({super.key});

  final playController = Get.find<AudioPlayController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      final isVisible = playController.isShowBottom.value;
      final podcastIdAvailable = playController.postModel.value.data?.podcast?.id != null;

      if (!isVisible || !podcastIdAvailable) {
        return const SizedBox();
      }

      return Container(
        height: 70,
        padding: const EdgeInsets.all(8),
        width: width,
        decoration: BoxDecoration(
            color: const Color(0xFFD3F3C5).withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                final data = playController.postModel.value.data?.podcast;
                AppRouter.route.pushNamed(RoutePath.audioPlayScreen, extra: AudioPlayerModel(
                  id: data?.id ?? "",
                  title: data?.title ?? "",
                  categories: data?.category?.title ?? "",
                  image: data?.cover ?? "",
                ));
              },
              child: SizedBox(
                height: 60,
                width: 80,
                child: Obx(() {
                  return CustomNetworkImage(
                    borderRadius: BorderRadius.circular(8.0),
                    imageUrl: playController.postModel.value.data?.podcast?.cover ?? "",
                  );
                }),
              ),
            ),
            const Gap(8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final title = playController.postModel.value.data?.podcast?.title;
                    bool isPodcast = title?.isNotEmpty == true;
                    final category = playController.postModel.value.data?.podcast?.category?.title;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          width: width - 180,
                          child: Marquee(
                            text: isPodcast ? (title ?? "Untitled Podcast") : "Untitled Podcast",
                            blankSpace: 39,
                          ),
                        ),
                        CustomText(
                          text: category ?? "Podcast",
                          color: AppColors.whiteColor,
                          fontSize: 12,
                        ),
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: () {
                      playController.togglePlayPause();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                      child: Obx(() {
                        return Icon(playController.isPlaying.value ? Icons.pause : Icons.play_arrow);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
