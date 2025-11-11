import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/screens/auth/otp/otp_screen.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/service/api_url.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _controller = Get.find<AuthController>();
  final TextEditingController _otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text("verify_email".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(12),
              CustomText(
                  text: "verification_code".tr,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
              const Gap(5),
              CustomText(text: widget.email, fontSize: 12, family: "Light"),
              const Gap(12),
              CustomText(
                  text:
                      "we_send_you_a_verification_code_to_verify_your_email".tr,
                  fontSize: 16,
                  family: "Light",
                  maxLines: 2),
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
                          _controller.resendOTP(
                              email: widget.email,
                              url: ApiUrl.activeOTPResend());
                        }
                      },
                      child: Text(
                        _controller.resendLoading.value
                            ? "Loading...."
                            : "resend_otp".tr,
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
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
                      final body = {
                        "email": widget.email.trim().toLowerCase(),
                        "verifyCode": int.tryParse(_otp.text.trim()),
                      };

                      _controller.activeAccount(body: body);
                    }
                  },
                  isLoading: _controller.activeLoading.value,
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
