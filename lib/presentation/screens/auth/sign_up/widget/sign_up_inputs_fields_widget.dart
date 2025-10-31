import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:podcast/presentation/screens/auth/controller/auth_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../widget/custom_text/custom_text.dart';

class SignUpInputsFieldsWidget extends StatelessWidget {
  const SignUpInputsFieldsWidget({
    super.key,
    required this.controller,
    required this.name,
    required this.email,
    required this.dob,
    required this.address,
    required this.password,
    required this.confirmPassword,
  });

  final AuthController controller;
  final TextEditingController name;
  final TextEditingController email;
  final ValueNotifier<DateTime> dob;
  final TextEditingController address;
  final TextEditingController password;
  final TextEditingController confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomAlignText(text: "User Name".tr),
        const Gap(8),
        CustomTextField(
          hintText: "Enter Your User Name".tr,
          keyboardType: TextInputType.text,
          controller: name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'User Name is required';
            }
            if (value.length < 2) {
              return 'User Name must be at least 2 characters';
            }
/*            final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
            if (!nameRegex.hasMatch(value)) {
              return 'User Name can only contain letters and spaces';
            }*/
            return null;
          },
        ),
        const Gap(12),
        CustomAlignText(text: "email_only".tr),
        const Gap(8),
        CustomTextField(
          hintText: "enter_your_email_here".tr,
          keyboardType: TextInputType.emailAddress,
          controller: email,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            final emailRegex =
                RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const Gap(12),
        CustomAlignText(text: "date_of_birth".tr),
        const Gap(8),
        ValueListenableBuilder(
          valueListenable: dob,
          builder: (_, date, child) {
            return GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(1990),
                  maxTime: DateTime.now(),
                  onConfirm: (value) {
                    dob.value = value;
                  },
                  currentTime: DateTime(2000),
                );
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.whiteColor),
                ),
                child: CustomText(
                  text: DateFormat("dd MMMM yyyy - EEEE").format(date),
                ),
              ),
            );
          },
        ),
        Obx(() {
          return controller.selectedRoll.value == "user"
              ? const SizedBox()
              : Column(
                  children: [
                    const Gap(12),
                    CustomAlignText(text: "address".tr),
                    const Gap(8),
                    CustomTextField(
                      hintText: "enter_your_address".tr,
                      keyboardType: TextInputType.streetAddress,
                      controller: address,
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
          hintText: "Enter Your Password",
          isPassword: true,
          keyboardType: TextInputType.text,
          controller: password,
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
        CustomAlignText(text: "Repeat Your Password".tr),
        const Gap(8),
        CustomTextField(
          hintText: "Repeat Your Password",
          isPassword: true,
          keyboardType: TextInputType.text,
          controller: confirmPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Repeat your password';
            }
            if (value != password.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}
