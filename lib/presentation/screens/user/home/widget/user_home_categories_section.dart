import 'dart:math';
import 'package:flutter/material.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeCategoriesSection extends StatelessWidget {
  const UserHomeCategoriesSection({super.key, required this.category});
  final CategoryElement? category;

  static const List<Color> _colorPalette = [
    Color(0xFFEF4849),
    Color(0xFF6A1B9A),
    Color(0xFF00897B),
    Color(0xFFF4511E),
    Color(0xFF039BE5),
    Color(0xFF00ACC1),
    Color(0xFFFFB300),
    Color(0xFF8E24AA),
    Color(0xFF43A047),
    Color(0xFF5E35B1),
    Color(0xFFD81B60),
    Color(0xFF3949AB),
    Color(0xFF00C853),
    Color(0xFFFF6F00),
    Color(0xFF1E88E5),
    Color(0xFF26C6DA),
    Color(0xFF9CCC65),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFF7E57C2),
  ];

  @override
  Widget build(BuildContext context) {
    final randomColor = _colorPalette[Random().nextInt(_colorPalette.length)];

    return GestureDetector(
      onTap: () => AppRouter.route.pushNamed(
        RoutePath.categoriesScreen,
        extra: category?.id ?? "",
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2B31),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 8, right: 100, bottom: 2),
              child: CustomText(
                text: category?.title ?? "",
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


/*
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeCategoriesSection extends StatelessWidget {
  const UserHomeCategoriesSection({super.key, required this.category});
  final CategoryElement? category;
  static const List<Color> _colorPalette = [
    Color(0xFFEF4849),
    Color(0xFF6A1B9A),
    Color(0xFF00897B),
    Color(0xFFF4511E),
    Color(0xFF039BE5),
    Color(0xFF00ACC1),
    Color(0xFFFFB300),
    Color(0xFF8E24AA),
    Color(0xFF43A047),
    Color(0xFF5E35B1),
    Color(0xFFD81B60),
    Color(0xFF3949AB),
    Color(0xFF00C853),
    Color(0xFFFF6F00),
    Color(0xFF1E88E5),
    Color(0xFF26C6DA),
    Color(0xFF9CCC65),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFF7E57C2),
  ];

  @override
  Widget build(BuildContext context) {
    final randomColor = _colorPalette[Random().nextInt(_colorPalette.length)];
    return GestureDetector(
      onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: category?.id??""),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: randomColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
                child: CustomText(text: category?.title??"", color: AppColors.whiteColor, maxLines: 2, textAlign: TextAlign.start),
              ),
            ),
            SizedBox(
              height: 80,
              width: 60,
              child: Center(
                child: Transform.rotate(
                  angle: 24 * pi / 180,
                  child: Transform.scale(
                    scale: 0.85,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomNetworkImage(
                        imageUrl: category?.categoryImage ?? "",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
