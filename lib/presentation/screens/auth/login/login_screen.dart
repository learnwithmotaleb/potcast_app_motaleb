import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = Get.find<AuthController>();
  final TextEditingController _email = TextEditingController(text: kDebugMode? "powexa8449@im5z.com" : "");
  /// jowexif304@devdigs.com - USER
  /// powexa8449@im5z.com - CREATOR
  final TextEditingController _password = TextEditingController(text: kDebugMode? "123456" : "");
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("login".tr),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.images.splashLogo.image(),
                CustomAlignText(text: "Email".tr),
                const Gap(8),
                CustomTextField(
                  hintText: "Enter Your Email",
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
                CustomAlignText(text: "password".tr),
                const Gap(8),
                CustomTextField(
                  hintText: "Enter Your Password",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => AppRouter.route.pushNamed(RoutePath.forgetScreen),
                      child: Text("forget_password".tr, style: const TextStyle(color: AppColors.hintTextColor)),
                    )
                  ],
                ),
                const Gap(12),
                Obx(
                  () => CustomButton(
                    text: "login".tr,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.login(
                          body: {"email": _email.text.trim(), "password": _password.text.trim()},
                        );
                      }
                    },
                    isLoading: _controller.loginLoading.value,
                  ),
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: CustomText(text: "don't_have_account".tr)),
                    TextButton(
                      onPressed: () => AppRouter.route.pushNamed(RoutePath.signUpScreen),
                      child: CustomText(text: "sign_up".tr, color: AppColors.redColor, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
