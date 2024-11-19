import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key, required this.isUser});
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("forgot_password".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(12),
            Assets.images.verification.image(
                width: MediaQuery.of(context).size.width/3
            ),
            const Gap(44),
            CustomText(text: "email_to_recover_password".tr,fontWeight: FontWeight.w300,fontSize: 20,),
            Gap(24.h),
            CustomAlignText(text: "enter_your_email".tr),
            const Gap(8),
            const CustomTextField(
              hintText: "example@example.com",
              keyboardType: TextInputType.emailAddress,
            ),
            Gap(44.h),
            CustomButton(text: "continue".tr,onTap: ()=>AppRouter.route.pushNamed(RoutePath.otpScreen,extra: isUser)),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
