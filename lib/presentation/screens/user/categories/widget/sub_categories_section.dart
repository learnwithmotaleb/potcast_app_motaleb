import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class SubCategoriesSection extends StatelessWidget {
  const SubCategoriesSection({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: name =="genres_podcast_only"?const Color(0xFFEF4849): name == "classical_audio"?const Color(0xFF03346E):const Color(0xFF016450),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: const CustomText(text: "National Baptist Convention", color: AppColors.whiteColor),
            ),
          );
        },
      ),
    );
  }
}
