import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key, required this.isUser});
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("set_password".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(24),
            CustomText(text: "please_select_a_password_that_uses_one_capital_letter_one_number_and_unique_symbol".tr,fontSize: 16,family: "Light",maxLines: 2),
            const Gap(24),
            CustomAlignText(text: "new_password".tr),
            const Gap(8),
            const CustomTextField(
              hintText: "*************",
              isPassword: true,
              keyboardType: TextInputType.text,
            ),
            const Gap(12),
            CustomAlignText(text: "confirm_password".tr),
            const Gap(8),
            const CustomTextField(
              hintText: "*************",
              isPassword: true,
              keyboardType: TextInputType.text,
            ),
            const Gap(24),
            CustomButton(text: "submit".tr,onTap: ()=>AppRouter.route.goNamed(RoutePath.loginScreen,extra: isUser)),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
