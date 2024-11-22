import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'widget/audio_play_bottom.dart';
import 'widget/audio_play_card.dart';
import 'widget/audio_play_control.dart';
import 'widget/audio_play_progress.dart';
import 'widget/user_play_loading.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({super.key, required this.model});

  final AudioPlayerModel model;

  @override
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> {
  final controller = Get.find<AudioPlayController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.playAudio(widget.model);
    });
    return WillPopScope(
      onWillPop: () async {
        if (controller.overlayEntry == null) {
          controller.showAudioPlayerOverlayCard(context);
        }
        return true;
      },
      child: Scaffold(
        body: Obx(() {
          return controller.isLoading.value
              ? const UserPlayLoading()
              : Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl:
                        controller.clickAudioPlayerData.value.image,
                        placeholder: (context, data) =>
                        const SizedBox(),
                        errorWidget: (context, data, errorWidget) =>
                        const Icon(Icons.person),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 30,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: AppColors.blackColor),
                        onPressed: () {
                          if (controller.overlayEntry == null) {
                            controller.showAudioPlayerOverlayCard(context);
                          }
                          AppRouter.route.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF142B77),
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
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                    const Gap(12),
                    const AudioPlayCard(),
                    const Gap(12),
                    const AudioPlayProgress(),
                    const AudioPlayControl(),
                    const Gap(24),
                    const AudioPlayBottom(),
                    const Gap(24),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

