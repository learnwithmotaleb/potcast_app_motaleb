import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("change_password".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            CustomAlignText(text: "current_password".tr),
            const Gap(5),
            CustomTextField(
              hintText: "************".tr,
              isPassword: true,
            ),
            const Gap(12),
            CustomAlignText(text: "new_password".tr),
            const Gap(5),
            CustomTextField(
              hintText: "enter_your_new_password".tr,
              isPassword: true,
            ),
            const Gap(12),
            CustomAlignText(text: "confirm_password".tr),
            const Gap(5),
            CustomTextField(
              hintText: "re_enter_your_new_password".tr,
              isPassword: true,
            ),
            Gap(24),
            CustomButton(text: "change_password".tr),
            Gap(12),
          ],
        ),
      ),
    );
  }
}
