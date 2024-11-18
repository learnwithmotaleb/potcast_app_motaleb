import 'package:flutter/material.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

final darkTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.blackColor,
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: "Regular",
  splashColor: Colors.transparent,
  inputDecorationTheme: inputDecorationTheme,
  appBarTheme: appBarTheme,
);

final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.whiteColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.whiteColor),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.whiteColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.whiteColor),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.redColor),
  ),
  hintStyle: const TextStyle(color: AppColors.hintTextColor,fontWeight: FontWeight.w100),
);


const AppBarTheme appBarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: AppColors.blackColor,
);
