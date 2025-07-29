import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class CustomProfileTile extends StatelessWidget {
  const CustomProfileTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isIcon = true,
    this.widget,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isIcon;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            isIcon?Icon(icon, size: 24,):(widget??const SizedBox()),
            const Gap(12),
            Flexible(child: CustomText(text: text.tr, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
