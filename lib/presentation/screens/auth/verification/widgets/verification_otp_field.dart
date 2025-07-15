import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

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
      focusedPinTheme: PinTheme(
        height: 70,
        width: 70,
        textStyle: const TextStyle(fontSize: 22, color: AppColors.blackColor),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.whiteColor : null,
          border: isDarkMode ? null : Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      followingPinTheme: PinTheme(
        height: 70,
        width: 70,
        textStyle: const TextStyle(fontSize: 22, color: AppColors.blackColor),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.whiteColor : null,
          border: isDarkMode ? null : Border.all(color: AppColors.blackColor),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      disabledPinTheme: PinTheme(
        height: 70,
        width: 70,
        textStyle: const TextStyle(fontSize: 22, color: AppColors.blackColor),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.whiteColor : null,
          border: isDarkMode ? null : Border.all(color: AppColors.blackColor),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      submittedPinTheme: PinTheme(
        height: 70,
        width: 70,
        textStyle: const TextStyle(fontSize: 22, color: AppColors.blackColor),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.whiteColor : null,
          border: isDarkMode ? null : Border.all(color: AppColors.blackColor),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      defaultPinTheme: PinTheme(
        height: 70,
        width: 70,
        textStyle: const TextStyle(fontSize: 22),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.blackColor : null,
          borderRadius: BorderRadius.circular(5),
          border: isDarkMode
              ? Border.all(color: const Color(0xFFFCFCF8))
              : Border.all(color: AppColors.hintTextColor),
        ),
      ),
    );
  }
}
