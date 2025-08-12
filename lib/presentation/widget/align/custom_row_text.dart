import 'package:flutter/material.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class CustomRowText extends StatelessWidget {
  const CustomRowText({
    super.key,
    required this.text,
    required this.text1,
    this.fontWeight = FontWeight.w800,
    this.fontWeight1 = FontWeight.w400,
    this.fontSize = 14,
    this.fontSize1 = 14,
    this.maxLine = 1,
    this.maxLine1 = 1,
    this.alignment = MainAxisAlignment.spaceBetween,
  });
  final String text;
  final FontWeight fontWeight;
  final FontWeight fontWeight1;
  final double fontSize;
  final double fontSize1;
  final String text1;
  final int maxLine;
  final int maxLine1;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: text,
              fontWeight: fontWeight,
              fontSize: fontSize,
              maxLines: maxLine),
          Flexible(
              child: CustomText(
                  text: text1,
                  fontWeight: fontWeight1,
                  fontSize: fontSize1,
                  maxLines: maxLine1,
                  textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
