import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'controller/creator_play_controller.dart';
import 'widget/creator_audio_play_section.dart';

class CreatorPlayScreen extends StatefulWidget {
  const CreatorPlayScreen({super.key, required this.model});
  final AudioPlayerModel model;

  @override
  State<CreatorPlayScreen> createState() => _CreatorPlayScreenState();
}

class _CreatorPlayScreenState extends State<CreatorPlayScreen> {
  final controller = Get.find<CreatorPlayController>();

  @override
  void initState() {
    super.initState();
    controller.playAudio(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Obx(() {
        return controller.isLoading.value?const Center(child: CircularProgressIndicator(),):
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: controller.clickAudioPlayerData.value.image,
                      placeholder: (context, data) => const SizedBox(),
                      errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: AppColors.blackColor),onPressed: ()=>AppRouter.route.pop(),),
                  ),
                  /*Positioned(
                    left: 12,
                    top: 44,
                    child: Container(
                      height: 50.h,
                      width: 50.h,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios,color: AppColors.blackColor),
                    ),
                  ),*/
                ],
              ),
            ),
            const CreatorAudioPlaySection(),
          ],
        );
      }),
    );
  }
}
