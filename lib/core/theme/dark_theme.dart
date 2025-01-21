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
  bottomNavigationBarTheme: bottomNavigationBarTheme,
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
  backgroundColor: const Color(0xFF093028),
  centerTitle: true,
);

const BottomNavigationBarThemeData bottomNavigationBarTheme =  BottomNavigationBarThemeData(
  backgroundColor: AppColors.blackColor,
  elevation: 1,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: AppColors.whiteColor,
  showUnselectedLabels: true,
  showSelectedLabels: true,
  selectedIconTheme: IconThemeData(size: 28,color: AppColors.whiteColor),
  unselectedItemColor: AppColors.primaryColor,
  unselectedIconTheme: IconThemeData(size: 24,color: AppColors.primaryColor),
  unselectedLabelStyle: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w400,fontSize: 12,fontFamily: "Regular"),
  selectedLabelStyle: TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.w400,fontSize: 12,fontFamily: "Regular"),
);
