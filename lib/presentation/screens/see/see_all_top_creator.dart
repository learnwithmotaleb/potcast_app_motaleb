import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/see/model/top_creator_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import 'controller/see_all_controller.dart';

class SeeAllTopCreator extends StatefulWidget {
  const SeeAllTopCreator({super.key});

  @override
  State<SeeAllTopCreator> createState() => _SeeAllTopCreatorState();
}

class _SeeAllTopCreatorState extends State<SeeAllTopCreator> {
  final controller = Get.put(SeeAllController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Creator"),
      ),
      body: PagedGridView<int, CreatorData>(
        pagingController: controller.pagingCreatorController,
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        builderDelegate: PagedChildBuilderDelegate<CreatorData>(
          itemBuilder: (index, item, context){
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: item.podcast??""),
                    child: Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(70.0, 70.0),
                            painter: PartialCirclePainter(
                              color: AppColors.primaryColor,
                              strokeWidth: 1.0,
                            ),
                          ),
                          // Circle with CachedNetworkImage
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70.0),
                                child: CustomNetworkImage(imageUrl: item.avatar??""),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(5),
                  CustomText(text: item.name??"", fontSize: 12),
                ],
              ),
            );
          },
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 120,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0
        ),
      ),
    );
  }
}

class PartialCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  PartialCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi / 2,
      5 * pi / 3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
