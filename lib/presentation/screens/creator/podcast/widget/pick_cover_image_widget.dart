import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class PickCoverImageWidget extends StatelessWidget {
  const PickCoverImageWidget({
    super.key,
    this.selectedImage,
    required this.onTap,
  });

  final File? selectedImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteColor),
        ),
        padding: const EdgeInsets.all(1),
        child: Builder(
          builder: (context) {
            if(selectedImage == null){
              return Container(
                width: width,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.blackColor,
                ),
                child: Column(
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
                      text: "Choose_a_file_or_it_here".tr,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                      fontSize: 16,
                    ),
                    const Gap(8),
                    const CustomText(
                      text: "JPEG and PNG formats",
                      fontWeight: FontWeight.w100,
                    ),
                  ],
                ),
              );
            }
            return SizedBox(
              height: 150,
              width: width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(selectedImage?.path ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
