import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class AudioPlayControl extends StatelessWidget {
  const AudioPlayControl({
    super.key,
    required this.controller,
    required this.currentPageIndex,
    required this.pageController,
  });

  final PodcastFeedController controller;
  final RxInt currentPageIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LikeButton(
          isLiked: controller.isFavorite.value,
          circleColor: const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Color(0xff33b5e5),
            dotSecondaryColor: Color(0xff0099cc),
          ),
          onTap: (value) async {
            return true;
            /*return await controller
                .favoritePodcast(
                    id: controller.postModel.value.data?.podcast?.id ?? "", current: value)
                .then((value) {
              controller.isFavorite.value = value;
              return value;
            });*/
          },
          likeBuilder: (bool isLiked) {
            return Obx(() {
              return controller.favoriteLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.red : Colors.white,
                      size: 30,
                    );
            });
          },
        ),
        IconButton(
          icon: Assets.icons.audioLeft.svg(
            height: 20.w,
            width: 20.w,
            colorFilter:
                isDarkMode ? null : const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
          ),
          onPressed: controller.skipBackward,
          iconSize: 36,
        ),
        Obx(() {
          return GestureDetector(
            onTap: () => controller.togglePlayPause(),
            child: Icon(controller.isPlaying.value ? Icons.pause : Icons.play_circle_outline_sharp,
                size: 45),
          );
        }),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () {
            _goToNextPage(
              pageController: pageController,
              currentPageIndex: currentPageIndex,
              feedController: controller,
            );
          },
          iconSize: 36,
        ),
        LikeButton(
          isLiked: controller.isLike.value,
          circleColor: const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Color(0xff33b5e5),
            dotSecondaryColor: Color(0xff0099cc),
          ),
          onTap: (value) async {
            return true;
            /*return await controller
                .likePodcast(id: "", current: value)
                .then((value) {
              controller.isFavorite.value = value;
              return value;
            });*/
          },
          likeBuilder: (bool isLiked) {
            return Obx(() {
              return controller.likeLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Icon(
                      Iconsax.like_1,
                      color: isLiked
                          ? Colors.deepOrange
                          : (isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                    );
            });
          },
        ),
      ],
    );
  }

  void _goToNextPage({
    required PodcastFeedController feedController,
    required RxInt currentPageIndex,
    required PageController pageController,
  }) {
    final items = feedController.pagingController.itemList;
    if (items != null && currentPageIndex.value < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      feedController.playNextPodcast();
    }
  }
}
