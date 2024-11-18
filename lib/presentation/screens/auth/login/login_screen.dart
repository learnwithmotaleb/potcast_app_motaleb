import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.isUser});
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: ()=>AppRouter.route.goNamed(RoutePath.roleScreen), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("login".tr),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAlignText(text: "email".tr),
              const Gap(8),
              const CustomTextField(
                hintText: "Sy@example.com",
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(12),
              CustomAlignText(text: "password".tr),
              const Gap(8),
              const CustomTextField(
                hintText: "*************",
                isPassword: true,
                keyboardType: TextInputType.text,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: ()=>AppRouter.route.pushNamed(RoutePath.forgetScreen,extra: isUser), child: Text("forget_password".tr,style: const TextStyle(color: AppColors.hintTextColor)))
                ],
              ),
              const Gap(12),
              CustomButton(text: "login".tr,onTap: (){
                if(isUser){
                  AppRouter.route.goNamed(RoutePath.userNavScreen);
                }else{
                  // AppRouter.route.goNamed(RoutePath.partnerNavScreen);
                }
              }),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: CustomText(text: "don't_have_account".tr)),
                  TextButton(onPressed: ()=>AppRouter.route.pushNamed(RoutePath.signUpScreen,extra: isUser), child: CustomText(text: "sign_up".tr,color: AppColors.redColor,fontWeight: FontWeight.w800))
                ],
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
