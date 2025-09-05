import 'package:flutter/material.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import '../loading/loading_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.bgColor,
    this.textColor,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final color = bgColor ?? AppColors.whiteColor;
    final Border border = Border.all(color: color);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
          border: border,
        ),
        child: buildWidget(isLoading),
      ),
    );
  }

  Widget buildWidget(bool isLoading){
    if(isLoading){
      return LoadingWidget(
        color: textColor ?? AppColors.blackColor,
      );
    }
    return CustomText(
      text: text,
      color: textColor ?? AppColors.blackColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
