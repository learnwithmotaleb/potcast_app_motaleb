import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _controller = Get.find<AuthController>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () => AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("create_account".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("choose_your_role_in_our_community".tr, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18), textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Obx(() {
                        return Radio<String>(
                          value: "USER",
                          groupValue: _controller.selectedRoll.value,
                          activeColor: AppColors.whiteColor,
                          onChanged: _controller.updateRoll,
                        );
                      }),
                      Text(
                        'user'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Obx(() {
                        return Radio<String>(
                          value: "CREATOR",
                          activeColor: AppColors.whiteColor,
                          groupValue: _controller.selectedRoll.value,
                          onChanged: _controller.updateRoll,
                        );
                      }),
                      Text('creator'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              CustomAlignText(text: "full_name".tr),
              const Gap(8),
              CustomTextField(
                hintText: "enter_your_full_name".tr,
                keyboardType: TextInputType.name,
                controller: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                  if (!nameRegex.hasMatch(value)) {
                    return 'Name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              const Gap(12),
              CustomAlignText(text: "email_only".tr),
              const Gap(8),
              CustomTextField(
                hintText: "enter_your_email_here".tr,
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const Gap(12),
              CustomAlignText(text: "date_of_birth".tr),
              const Gap(8),
              CustomTextField(
                hintText: "dd-mm-yyy",
                keyboardType: TextInputType.phone,
                controller: _dob,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your ${'date_of_birth'.tr}';
                  }
                  return null;
                },
              ),
              Obx(() {
                return _controller.selectedRoll.value == "USER"?const SizedBox():
                Column(
                  children: [
                    const Gap(12),
                    CustomAlignText(text: "address".tr),
                    const Gap(8),
                    CustomTextField(
                      hintText: "enter_your_address".tr,
                      keyboardType: TextInputType.streetAddress,
                      controller: _address,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your ${'address'.tr}';
                        }
                        return null;
                      },
                    ),
                  ],
                );
              }),
              const Gap(12),
              CustomAlignText(text: "password".tr),
              const Gap(8),
              CustomTextField(
                hintText: "*************",
                isPassword: true,
                keyboardType: TextInputType.text,
                controller: _password,
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
                  if (value != _password.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const Gap(24),
              Obx(
                    () =>
                    CustomButton(
                      text: "sign_up".tr,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _controller.signUp(
                            body: {
                              "name": _name.text.trim(),
                              "email": _email.text.trim(),
                              "password": _password.text.trim(),
                              "confirmPassword": _confirmPassword.text.trim(),
                              "role": _controller.selectedRoll.value,
                              "address": _address.text.trim(),
                              "dateOfBirth": _dob.text.trim(),
                            },
                            email: _email.text.trim(),
                          );
                        }
                      },
                      isLoading: _controller.signUpLoading.value,
                    ),
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: CustomText(text: "already_have_an_account".tr)),
                  TextButton(
                    onPressed: () => AppRouter.route.pop(),
                    child: Text(
                      "login".tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.redColor,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
