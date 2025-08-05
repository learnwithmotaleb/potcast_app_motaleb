import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import '../../../../../core/custom_assets/assets.gen.dart';
import '../controller/podcast_audio_controller.dart';

class PickVideoWidget extends StatelessWidget {
  PickVideoWidget({super.key});

  final controller = Get.find<PodcastAudioController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.pickVideo(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.whiteColor,
          ),
        ),
        padding: const EdgeInsets.all(1),
        child: Obx(
              () => controller.createLoading.value ? Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_upload_rounded, size: 28),
                      const SizedBox(width: 8),
                      CustomText(
                        text: "uploading_video".tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      const Spacer(),
                      CustomText(
                        text: "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                  const Gap(12),
                  LinearProgressIndicator(
                    value: controller.uploadProgress.value,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "${controller.uploadedMB.value.toStringAsFixed(2)} MB / ${controller.totalMB.value.toStringAsFixed(2)} MB",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const Gap(8),
                ],
              ),
            ),
          ) : Container(
            width: width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.blackColor,
            ),
            child: controller.videoFile.value == null
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.cloudAdd.svg(
                  colorFilter: const ColorFilter.mode(
                    AppColors.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(8),
                CustomText(
                  text: "Pick a Video".tr,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                  fontSize: 16,
                ),
                const Gap(8),
                CustomText(
                  text: "max_10_MB_files_are_allowed".tr,
                  fontWeight: FontWeight.w100,
                )
              ],
            )
                : SizedBox(
              width: width,
              height: 50.h,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50.h,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.blackColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomText(
                        text: controller.videoFile.value?.path != null
                            ? path.basename(controller.videoFile.value!.path)
                            : "",
                      ),
                    ),
                  ),
                  const Gap(5),
                  GestureDetector(
                    onTap: () => controller.videoFile.value = null,
                    child: Container(
                      height: 25.h,
                      width: 25.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.whiteColor),
                          shape: BoxShape.circle),
                      padding: const EdgeInsets.all(2),
                      child: Assets.images.delete.image(color: AppColors.whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}