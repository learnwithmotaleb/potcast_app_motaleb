/*
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:transport/core/custom_assets/assets.gen.dart';
import 'package:transport/presentation/widget/align/custom_align_text.dart';
import 'package:transport/presentation/widget/button/custom_button.dart';
import 'package:transport/presentation/widget/text_field/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("change_password".tr),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: isDarkMode ? Assets.images.whiteLogo.image() : Assets.images.logo.image(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            CustomAlignText(text: "set_your_new_password".tr,fontWeight: FontWeight.w800),
            const Gap(5),
            CustomAlignText(text: "enter_current_password".tr),
            const Gap(5),
            CustomTextField(
              hintText: "enter_current_password".tr,
              isPassword: true,
            ),
            const Gap(12),
            CustomAlignText(text: "enter_new_password".tr),
            const Gap(5),
            CustomTextField(
              hintText: "enter_new_password".tr,
              isPassword: true,
            ),
            const Gap(12),
            CustomAlignText(text: "retype_new_password".tr),
            const Gap(5),
            CustomTextField(
              hintText: "retype_new_password".tr,
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
*/
