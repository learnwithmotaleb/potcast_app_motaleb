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
  });

  final String text;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const color = AppColors.whiteColor;
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
        child: buildWidget(color, isLoading),
      ),
    );
  }

  Widget buildWidget(Color color, bool isLoading){
    if(isLoading){
      return const LoadingWidget(
        color: AppColors.blackColor,
      );
    }
    return CustomText(
      text: text,
      color: AppColors.blackColor,
      fontSize: 16,
    );
  }
}
