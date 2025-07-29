import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import 'widget/sign_up_choose_role.dart';
import 'widget/sign_up_inputs_fields_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _controller = Get.find<AuthController>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final ValueNotifier<DateTime> dob = ValueNotifier(DateTime(2000));
  final TextEditingController _address = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    dob.dispose();
    _address.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
              Text(
                "choose_your_role_in_our_community".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SignUpChooseRole(
                controller: _controller,
              ),
              SignUpInputsFieldsWidget(
                name: _name,
                email: _email,
                dob: dob,
                address: _address,
                password: _password,
                confirmPassword: _confirmPassword,
                controller: _controller,
              ),
              const Gap(24),
              Obx(
                () => CustomButton(
                  text: "sign_up".tr,
                  isLoading: _controller.signUpLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final body = {
                        "name": _name.text.trim(),
                        "email": _email.text.trim(),
                        "password": _password.text.trim(),
                        "confirmPassword": _confirmPassword.text.trim(),
                        "role": _controller.selectedRoll.value,
                        "address": _address.text.trim(),
                        "dateOfBirth": dob.value.toUtc().toIso8601String(),
                      };

                      _controller.signUp(
                        body: body,
                        email: _email.text.trim(),
                      );
                    }
                  },
                ),
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CustomText(
                      text: "already_have_an_account".tr,
                    ),
                  ),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
