import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'controller/settings_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _controller = Get.find<SettingsController>();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("change_password".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomAlignText(text: "current_password".tr),
              const Gap(5),
              CustomTextField(
                hintText: "************".tr,
                isPassword: true,
                controller: _currentPassword,
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
              CustomAlignText(text: "new_password".tr),
              const Gap(5),
              CustomTextField(
                hintText: "enter_your_new_password".tr,
                isPassword: true,
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
              const Gap(5),
              CustomTextField(
                hintText: "re_enter_your_new_password".tr,
                isPassword: true,
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
                  isLoading: _controller.changePasswordLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _controller.changePassword(
                        body: {
                          "oldPassword": _currentPassword.text.trim(),
                          "newPassword": _newPassword.text.trim(),
                          "confirmNewPassword": _confirmPassword.text.trim()
                        },
                      );
                    }
                  },
                ),
              ),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}
