import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeCategoriesSection extends StatelessWidget {
  const UserHomeCategoriesSection({super.key, required this.category});
  final CategoryElement? category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: category?.id??""),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFEF4849),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
                child: CustomText(text: category?.title??"", color: AppColors.whiteColor, maxLines: 2, textAlign: TextAlign.start),
              ),
            ),
            SizedBox(
              height: 70,
              width: 100.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
                child: CustomNetworkImage(
                    imageUrl: category?.image??"",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}