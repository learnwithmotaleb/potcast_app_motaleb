import 'package:flutter/material.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeCategoriesSection extends StatelessWidget {
  const UserHomeCategoriesSection({super.key, required this.category});
  final HomeCategoryElement? category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRouter.route.pushNamed(
        RoutePath.categoriesScreen,
        extra: category?.id ?? "",
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2B31),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 8, right: 90, bottom: 2),
              child: CustomText(
                text: category?.name ?? "",
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                textAlign: TextAlign.start,
                maxLines: 3,
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              top: -2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomNetworkImage(
                  imageUrl: category?.categoryImage ?? "",
                  width: 70,
                  height: 100,
                  borderRadius: BorderRadius.circular(12),
                  // fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
