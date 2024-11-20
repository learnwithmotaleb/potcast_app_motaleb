import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/creator/play/controller/creator_play_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class CreatorAudioPlaySection extends StatefulWidget {
  const CreatorAudioPlaySection({super.key});

  @override
  State<CreatorAudioPlaySection> createState() => _CreatorAudioPlaySectionState();
}

class _CreatorAudioPlaySectionState extends State<CreatorAudioPlaySection> {
  final audioController = Get.find<CreatorPlayController>();
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double width= MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: const BoxDecoration(
        color: Color(0xFF772424)
      ),
      child: Column(
        children: [
          const Gap(5),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5,
              width: 75.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(3.r)
              ),
            ),
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0.r),
                  child: CachedNetworkImage(
                    imageUrl: audioController.clickAudioPlayerData.value.image,
                    placeholder: (context, data) => const SizedBox(),
                    errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(5),
              const Flexible(child: CustomText(text: "Dance party at the top of the town that got all celebrities talking and whining.",maxLines: 3,fontWeight: FontWeight.w600,textAlign: TextAlign.start))
            ],
          ),
          const Gap(12),
          Obx(() {
            final position = audioController.currentPosition.value;
            final total = audioController.totalDuration.value;

            return ProgressBar(
              progress: position,
              total: total,
              thumbColor: isDarkMode?AppColors.whiteColor:AppColors.blackColor,
              progressBarColor: isDarkMode?AppColors.whiteColor:AppColors.blackColor,
              bufferedBarColor: AppColors.redColor,
              baseBarColor: isDarkMode?AppColors.whiteColor.withOpacity(0.1):AppColors.blackColor.withOpacity(0.1),
              onSeek: audioController.seekAudio,
            );
          }),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Assets.icons.audioLeft.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                    onPressed: audioController.skipBackward,
                    iconSize: 36,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Obx(() {
                  return GestureDetector(
                    onTap: (){
                      if (audioController.isPlaying.value) {
                        audioController.pauseAudio();
                      } else {
                        audioController.play();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle
                      ),
                      child: Icon(audioController.isPlaying.value ? Iconsax.pause : Icons.play_arrow,color: AppColors.blackColor,size: 32),
                    ),
                  );
                }),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Assets.icons.audioRight.svg(height: 20.w,width: 20.w,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                      onPressed: audioController.skipForward,
                      iconSize: 36,
                    ),
                    LikeButton(
                      circleColor:
                      const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Iconsax.like_1,
                          color: isLiked ? Colors.red : (isDarkMode?AppColors.whiteColor:AppColors.blackColor),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12),
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Assets.icons.comments.svg(height: 20.h,width: 20.h),
                Assets.icons.donate.svg(height: 20.h,width: 20.h),
              ],
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
