import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import '../controller/podcast_feed_controller.dart';

class AudioPlayControl extends StatelessWidget {
  final PodcastFeedController controller;

  const AudioPlayControl({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous button
        /*IconButton(
          onPressed: () {
            debugPrint('🎵 Previous button tapped');
            controller.playPreviousPodcast();
          },
          icon: const Icon(Iconsax.previous),
          iconSize: 32,
        ),*/
        Obx(() {
          return IconButton(
            onPressed: () {
              controller
                  .favoritePodcast(
                  id: controller.currentItem.value.id ?? "",
                  current: controller.isFavorite.value)
                  .then((value) {
                controller.isFavorite.value = value;
                return value;
              });
            },
            icon: Icon(
              Icons.favorite,
              size: 32,
              color: controller.isFavorite.value
                  ? AppColors.redColor
                  : AppColors.whiteColor,
            ),
          );
        }),

        // Skip backward 15s
        IconButton(
          onPressed: () {
            debugPrint('⏪ Skip backward button tapped');
            controller.skipBackward();
          },
          icon: const Icon(Iconsax.backward_15_seconds),
          iconSize: 28,
        ),

        // Play/Pause button
        Obx(() =>
            IconButton(
              onPressed: () {
                debugPrint('⏯️ Play/Pause button tapped');
                controller.togglePlayPause();
              },
              icon: Icon(
                controller.isPlaying.value ? Iconsax.pause : Icons.play_circle,
              ),
              iconSize: 48,
            )),

        // Skip forward 15s
        /*IconButton(
          onPressed: () {
            debugPrint('⏩ Skip forward button tapped');
            controller.skipForward();
          },
          icon: const Icon(Iconsax.forward_15_seconds),
          iconSize: 28,
        ),*/

        // Next button
        IconButton(
          onPressed: () {
            debugPrint('🎵 Next button tapped');
            controller.playNextPodcast();
          },
          icon: const Icon(Iconsax.next),
          iconSize: 32,
        ),
        Obx(() {
          return IconButton(
            onPressed: () {
              debugPrint('⏩ Skip forward button tapped');
              controller.likePodcast(
                id: controller.currentItem.value.id ?? "",
                current: controller.isLike.value,
              );
            },
            color: controller.isLike.value
                ? AppColors.redColor
                : AppColors.whiteColor,
            icon: const Icon(Iconsax.like_1),
            iconSize: 28,
          );
        }),
      ],
    );
  }
}
