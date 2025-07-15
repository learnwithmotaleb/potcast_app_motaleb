import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/service/api_url.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controller = Get.find<AuthController>();
  final TextEditingController _otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("forgot_password".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.splashLogo.image(),
              CustomText(text: "verification_code".tr, fontWeight: FontWeight.w800, fontSize: 20),
              const Gap(5),
              CustomText(text: widget.email, fontSize: 12, family: "Light"),
              const Gap(12),
              CustomText(text: "we_send_you_a_verification_code_to_verify_your_email".tr, fontSize: 16, family: "Light", maxLines: 2),
              const Gap(24),
              CustomAlignText(text: "enter_your_code_here".tr),
              const Gap(8),
              OTPField(controller: _otp),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => TextButton(
                      onPressed: () {
                        if (_controller.resendLoading.value == false) {
                          _controller.resendOTP(email: widget.email, url: ApiUrl.verifyOtpResend());
                        }
                      },
                      child: Text(
                        _controller.resendLoading.value ? "Loading...." : "resend_otp".tr,
                        style: const TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Obx(
                () => CustomButton(
                  text: "continue".tr,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _controller.otpVerify(
                        body: {
                          "email": widget.email,
                          "verificationOTP": _otp.text.trim(),
                        },
                        email: widget.email,
                      );
                    }
                  },
                  isLoading: _controller.otpLoading.value,
                ),
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPField extends StatelessWidget {
  const OTPField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Pinput(
      length: 6,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'OTP is required';
        }
        if (value.length != 6) {
          return 'OTP must be 6 digits';
        }
        return null;
      },
      focusedPinTheme: PinTheme(height: 70.h, width: 70.w, textStyle: TextStyle(fontSize: 22.sp,color: AppColors.blackColor), decoration: BoxDecoration(color: isDarkMode ? AppColors.whiteColor : null, border: isDarkMode ? null : Border.all(color: AppColors.primaryColor), borderRadius: BorderRadius.circular(5.r))),
      followingPinTheme: PinTheme(height: 70.h, width: 70.w, textStyle: TextStyle(fontSize: 22.sp,color: AppColors.blackColor), decoration: BoxDecoration(color: isDarkMode ? AppColors.whiteColor : null, border: isDarkMode ? null : Border.all(color: AppColors.blackColor), borderRadius: BorderRadius.circular(5.r))),
      disabledPinTheme: PinTheme(height: 70.h, width: 70.w, textStyle: TextStyle(fontSize: 22.sp,color: AppColors.blackColor), decoration: BoxDecoration(color: isDarkMode ? AppColors.whiteColor : null, border: isDarkMode ? null : Border.all(color: AppColors.blackColor), borderRadius: BorderRadius.circular(5.r))),
      submittedPinTheme: PinTheme(height: 70.h, width: 70.w, textStyle: TextStyle(fontSize: 22.sp,color: AppColors.blackColor), decoration: BoxDecoration(color: isDarkMode ? AppColors.whiteColor : null, border: isDarkMode ? null : Border.all(color: AppColors.blackColor), borderRadius: BorderRadius.circular(5.r))),
      defaultPinTheme: PinTheme(height: 70.h, width: 70.w, textStyle: TextStyle(fontSize: 22.sp,color: AppColors.blackColor), decoration: BoxDecoration(color: isDarkMode ? AppColors.blackColor : null, borderRadius: BorderRadius.circular(5.r), border: isDarkMode ? Border.all(color: const Color(0xFFFCFCF8)) : Border.all(color: AppColors.hintTextColor))),
    );
  }
}
