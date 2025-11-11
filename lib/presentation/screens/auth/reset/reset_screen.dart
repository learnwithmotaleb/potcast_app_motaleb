import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key, required this.email});
  final String email;
  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _controller = Get.find<AuthController>();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text("set_password".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.splashLogo.image(
                color: AppColors.blackColor,
              ),
              CustomText(
                  text:
                      "please_select_a_password_that_uses_one_capital_letter_one_number_and_unique_symbol"
                          .tr,
                  fontSize: 16,
                  family: "Light",
                  maxLines: 2),
              const Gap(24),
              CustomAlignText(text: "new_password".tr),
              const Gap(8),
              CustomTextField(
                hintText: "*************",
                isPassword: true,
                keyboardType: TextInputType.text,
                controller: _newPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const Gap(12),
              CustomAlignText(text: "confirm_password".tr),
              const Gap(8),
              CustomTextField(
                hintText: "*************",
                isPassword: true,
                keyboardType: TextInputType.text,
                controller: _confirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _newPassword.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const Gap(24),
              Obx(
                () => CustomButton(
                  text: "reset_password".tr,
                  isLoading: _controller.resetLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _controller.resetPassword(
                        body: {
                          "email": widget.email.trim().toLowerCase(),
                          "password": _newPassword.text,
                          "confirmPassword": _confirmPassword.text,
                        },
                      );
                    }
                  },
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
