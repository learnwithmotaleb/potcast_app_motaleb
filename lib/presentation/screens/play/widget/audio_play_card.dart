import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/helper/image/network_image.dart';
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
        CustomNetworkImage(
          imageUrl: controller.updatedAudioPlayModel.value.image,
          borderRadius: BorderRadius.circular(8.0.r),
          height: 80.h,
          width: 100,
        ),
        const Gap(5),
        Flexible(
          child: CustomText(
            text: controller.updatedAudioPlayModel.value.title,
            maxLines: 3,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
