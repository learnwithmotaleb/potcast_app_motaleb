import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class CustomProfileTile extends StatelessWidget {
  const CustomProfileTile({super.key, required this.icon, required this.text, required this.onTap, this.isLast = false});
  final Widget icon;
  final String text;
  final VoidCallback onTap;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                icon,
                const Gap(12),
                CustomText(text: text.tr,fontSize: 16,family: "Bold",color: isLast?AppColors.redColor:null)
              ],
            ),
            const Gap(3),
            isLast?const SizedBox():const Divider(color: Color(0xFFCDE1F9),thickness: 2),
          ],
        ),
      ),
    );
  }
}
