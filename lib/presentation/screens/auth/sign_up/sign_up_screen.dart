import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.isUser});
  final bool isUser;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("create_account".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAlignText(text: "full_name".tr),
            const Gap(8),
            CustomTextField(
              hintText: "enter_your_full_name".tr,
              keyboardType: TextInputType.name,
            ),
            const Gap(12),
            CustomAlignText(text: "email_only".tr),
            const Gap(8),
            CustomTextField(
              hintText: "enter_your_email_here".tr,
              keyboardType: TextInputType.emailAddress,
            ),
            const Gap(12),
            CustomAlignText(text: "date_of_birth".tr),
            const Gap(8),
            const CustomTextField(
              hintText: "dd-mm-yyy",
              keyboardType: TextInputType.phone,
            ),
            const Gap(12),
            CustomAlignText(text: "address".tr),
            const Gap(8),
            CustomTextField(
              hintText: "enter_your_address".tr,
              keyboardType: TextInputType.streetAddress,
            ),
            const Gap(12),
            CustomAlignText(text: "password".tr),
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
            CustomButton(text: "sign_up".tr,onTap: ()=>AppRouter.route.pop()),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: CustomText(text: "already_have_an_account".tr)),
                TextButton(onPressed: (){
                  AppRouter.route.pop();
                }, child: Text("login".tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w800,color: AppColors.redColor),))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
