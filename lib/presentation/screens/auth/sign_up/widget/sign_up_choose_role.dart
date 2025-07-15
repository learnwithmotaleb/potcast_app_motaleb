import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../controller/auth_controller.dart';

class SignUpChooseRole extends StatelessWidget {
  const SignUpChooseRole({super.key, required this.controller});
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Obx(() {
              return Radio<String>(
                value: "user",
                groupValue: controller.selectedRoll.value,
                activeColor: AppColors.greenLight,
                onChanged: controller.updateRoll,
              );
            }),
            Text(
              'user'.tr,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Obx(() {
              return Radio<String>(
                value: "creator",
                activeColor: AppColors.greenLight,
                groupValue: controller.selectedRoll.value,
                onChanged: controller.updateRoll,
              );
            }),
            Text(
              'creator'.tr,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
