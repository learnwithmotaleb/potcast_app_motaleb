import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'widget/audio_play_bottom.dart';
import 'widget/audio_play_card.dart';
import 'widget/audio_play_control.dart';
import 'widget/audio_play_progress.dart';
import 'widget/user_play_loading.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({super.key, required this.id});

  final String id;

  @override
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> {
  final controller = Get.put(AudioPlayController());

  @override
  void initState() {
    controller.playPodcast(id: widget.id);
    if (controller.overlayEntry != null) {
      controller.removeOverlay();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.overlayEntry == null && controller.isPlaying.value) {
          controller.showAudioPlayerOverlayCard(context);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Play"),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
            onPressed: () {
              if (controller.overlayEntry == null &&
                  controller.isPlaying.value) {
                controller.showAudioPlayerOverlayCard(context);
              }
              AppRouter.route.pop();
            },
          ),
          backgroundColor: const Color(0xFF0C3A30),
        ),
        body: Obx(() {
          switch (controller.loading.value) {
            case Status.loading:
              return const UserPlayLoading();
            case Status.noDataFound:
              return const Center(child: Text("No data found"));
            case Status.internetError:
              return Center(child: NoInternetCard(
                onTap: () => controller.playPodcast(id: widget.id),
                text: "No Internet Connection",));
            case Status.error:
              return Center(child: NoInternetCard(
                  onTap: () => controller.playPodcast(id: widget.id)));
            case Status.completed:
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF093028),
                      Color(0xFF237A57),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                          builder: (context, constant) {
                            controller.loadAd(width: constant.maxWidth.toInt()-20, height: constant.maxHeight.toInt());
                            return Obx(() {
                              return Stack(
                                children: [
                                  // Show music image only if the ad is not loaded
                                  if (!controller.isLoaded.value)
                                    Positioned.fill(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 20),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              8),
                                          child: CustomNetworkImage(
                                            imageUrl: controller.postModel.value
                                                .data
                                                ?.podcast?.cover ?? "",
                                          ),
                                        ),
                                      ),
                                    ),
                              
                                  // Show Banner Ad at the bottom once it's loaded
                                  if (controller.isLoaded.value)
                                    Positioned.fill(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: controller.bannerAd != null
                                              ? AdWidget(
                                              ad: controller.bannerAd!)
                                              : CustomNetworkImage(
                                            imageUrl: controller.postModel.value
                                                .data
                                                ?.podcast?.cover ?? "",
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            });
                          }
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: const Column(
                        children: [
                          /*const Gap(5),
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
                          ),*/
                          Gap(12),
                          AudioPlayCard(),
                          Gap(12),
                          AudioPlayProgress(),
                          AudioPlayControl(),
                          Gap(24),
                          AudioPlayBottom(),
                          Gap(24),
                        ],
                      ),
                    ),
                  ],
                ),
              );
          }
        }),
      ),
    );
  }
}

