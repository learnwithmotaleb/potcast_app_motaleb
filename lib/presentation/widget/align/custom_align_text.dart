import 'package:flutter/material.dart';

class CustomAlignText extends StatelessWidget {
  const CustomAlignText(
      {super.key,
      this.alignment = Alignment.centerLeft,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.color});
  final Alignment alignment;
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(text,
          style: TextStyle(
              fontSize: fontSize ?? 18,
              color: color,
              fontWeight: fontWeight ?? FontWeight.w800,
              fontFamily: "SemiBold"),
          maxLines: 1),
    );
  }
}
