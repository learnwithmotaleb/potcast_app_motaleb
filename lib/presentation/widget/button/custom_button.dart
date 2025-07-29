import 'package:flutter/material.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import '../loading/loading_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.isBgWhite = true,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isBgWhite;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isBgWhite?AppColors.whiteColor:null,
          border: isBgWhite?(isDarkMode?null:Border.all(color: AppColors.blackColor)):Border.all(color: AppColors.primaryColor),
        ),
        child: isLoading?const LoadingWidget():
        CustomText(text: text,color: isBgWhite?AppColors.blackColor:AppColors.primaryColor,fontSize: 16),
      ),
    );
  }
}