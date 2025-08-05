import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'widget/audio_play_bottom.dart';
import 'widget/audio_play_control.dart';
import 'widget/audio_play_progress.dart';
import 'widget/user_play_loading.dart';

class UserPlayScreen extends StatefulWidget {
  const UserPlayScreen({super.key, required this.audioPlayerModel});
  final AudioPlayerModel audioPlayerModel;

  @override
  State<UserPlayScreen> createState() => _UserPlayScreenState();
}

class _UserPlayScreenState extends State<UserPlayScreen> {
  final controller = Get.find<AudioPlayController>();

  @override
  void initState() {
    controller.playPodcast(id: widget.audioPlayerModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // controller.loadAd(width: constant.maxWidth.toInt() - 20, height: constant.maxHeight.toInt());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final title = controller.postModel.value.data?.podcast?.title;
          final title1 = widget.audioPlayerModel.title;
          final isLoaded =  title != null && title.isNotEmpty;
          if(isLoaded ||  (title1 != null && title1.isNotEmpty)){
            return Text(
              title1 ?? controller.postModel.value.data!.podcast!.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey.withValues(alpha: 0.6),
            highlightColor: Colors.grey.withValues(alpha: 0.3),
            child: Container(
              height: 30,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.toggleAudio();
            AppRouter.route.pop();
          },
        ),
        actions: [
          IconButton(onPressed: ()=> controller.toggleMode(), icon: const Icon(Iconsax.arrow_swap)),
          IconButton(onPressed: ()=> controller.toggleMode(), icon: const Icon(Icons.report)),
          const Gap(12),
        ],
      ),
      body: Obx(() {
        switch (controller.loading.value) {
          case Status.loading:
            return const UserPlayLoading();
          case Status.noDataFound:
            return const Center(child: Text("No data found"));
          case Status.internetError:
            return Center(child: NoInternetCard(
              onTap: () => controller.playPodcast(id: widget.audioPlayerModel.id),
              text: "No Internet Connection",));
          case Status.error:
            return Center(child: NoInternetCard(
                onTap: () => controller.playPodcast(id: widget.audioPlayerModel.id)));
          case Status.completed:
            return Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                      builder: (context, constant) {
                        return Obx(() {
                          if(controller.loading.value == Status.loading){
                            return const Center(child: CircularProgressIndicator());
                          }else if(controller.loading.value == Status.error){
                            return const Center(child: CircularProgressIndicator());
                          }else if(controller.loading.value == Status.internetError){
                            return const Center(child: CircularProgressIndicator());
                          }else if(controller.loading.value == Status.noDataFound){
                            return Center(child: NoInternetCard(onTap: ()=> controller.playPodcast(id: widget.audioPlayerModel.id)));
                          }else{
                            if (controller.isAudioMode.value) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                                child: CustomNetworkImage(
                                  borderRadius: BorderRadius.circular(8),
                                  imageUrl: "https://plus.unsplash.com/premium_photo-1681335986095-5a9585e77246",
                                  // imageUrl: controller.postModel.value.data?.podcast?.cover ?? "",
                                ),
                              );
                            } else {
                              if (controller.videoPlayerController.value?.value.isInitialized?? false) {
                                return AspectRatio(
                                  aspectRatio: controller.videoPlayerController.value?.value.aspectRatio?? 9/16,
                                  child: VideoPlayer(controller.videoPlayerController.value!),
                                );
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                          }
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
                      // AudioPlayCard(),
                      Gap(12),
                      AudioPlayProgress(),
                      AudioPlayControl(),
                      Gap(24),
                      AudioPlayBottom(),
                      Gap(44),
                    ],
                  ),
                ),
              ],
            );
        }
      }),
    );
  }
}

