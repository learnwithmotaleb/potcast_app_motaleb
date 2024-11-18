import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.isUser});
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            CustomText(text: "verification_code".tr,fontWeight: FontWeight.w800,fontSize: 20),
            const Gap(12),
            CustomText(text: "we_send_you_a_verification_code_to_verify_your_email".tr,fontSize: 16,family: "Light",maxLines: 2),
            const Gap(24),
            CustomAlignText(text: "enter_your_code_here".tr),
            const Gap(8),
            Pinput(
              length: 6,
              focusedPinTheme: PinTheme(
                height: 70.h,
                width: 70.w,
                textStyle: TextStyle(fontSize: 22.sp),
                decoration: BoxDecoration(
                    color: isDarkMode?AppColors.whiteColor:null,
                    border: isDarkMode?null:Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(5.r)
                )
              ),
              followingPinTheme: PinTheme(
                  height: 70.h,
                  width: 70.w,
                  textStyle: TextStyle(fontSize: 22.sp),
                  decoration: BoxDecoration(
                      color: isDarkMode?AppColors.whiteColor:null,
                      border: isDarkMode?null:Border.all(color: AppColors.blackColor),
                      borderRadius: BorderRadius.circular(5.r)
                  )
              ),
              disabledPinTheme: PinTheme(
                  height: 70.h,
                  width: 70.w,
                  textStyle: TextStyle(fontSize: 22.sp),
                  decoration: BoxDecoration(
                      color: isDarkMode?AppColors.whiteColor:null,
                      border: isDarkMode?null:Border.all(color: AppColors.blackColor),
                      borderRadius: BorderRadius.circular(5.r)
                  )
              ),
              submittedPinTheme: PinTheme(
                  height: 70.h,
                  width: 70.w,
                  textStyle: TextStyle(fontSize: 22.sp),
                  decoration: BoxDecoration(
                      color: isDarkMode?AppColors.whiteColor:null,
                      border: isDarkMode?null:Border.all(color: AppColors.blackColor),
                      borderRadius: BorderRadius.circular(5.r)
                  )
              ),
              defaultPinTheme: PinTheme(
                  height: 70.h,
                  width: 70.w,
                  textStyle: TextStyle(fontSize: 22.sp),
                  decoration: BoxDecoration(
                      color: isDarkMode?AppColors.blackColor:null,
                      borderRadius: BorderRadius.circular(5.r),
                    border: isDarkMode?Border.all(color: const Color(0xFFFCFCF8)):Border.all(color: AppColors.hintTextColor)
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){
                  showCustomSnackBar("otp_send_again".tr,isError: false,context: context);
                }, child: Text("resend_otp".tr,style: const TextStyle(color: AppColors.whiteColor),))
              ],
            ),
            const Gap(24),
            CustomButton(text: "continue".tr,onTap: ()=>AppRouter.route.pushNamed(RoutePath.resetScreen,extra: isUser)),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
