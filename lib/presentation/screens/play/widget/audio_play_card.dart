import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class AudioPlayCard extends StatefulWidget {
  const AudioPlayCard({super.key});

  @override
  State<AudioPlayCard> createState() => _AudioPlayCardState();
}

class _AudioPlayCardState extends State<AudioPlayCard> {
  final controller = Get.find<AudioPlayController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 80.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0.r),
            child: CachedNetworkImage(
              imageUrl: controller.clickAudioPlayerData.value.image,
              placeholder: (context, data) => const SizedBox(),
              errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Gap(5),
        Flexible(child: CustomText(text: controller.clickAudioPlayerData.value.title,maxLines: 3,fontWeight: FontWeight.w600,textAlign: TextAlign.start))
      ],
    );
  }
}
