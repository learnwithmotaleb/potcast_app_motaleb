import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserTopArtistsSection extends StatefulWidget {
  const UserTopArtistsSection({super.key});

  @override
  State<UserTopArtistsSection> createState() => _UserTopArtistsSectionState();
}

class _UserTopArtistsSectionState extends State<UserTopArtistsSection> {
  final controller = Get.find<UserHomeController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "top_artists".tr, fontSize: 18, fontWeight: FontWeight.w800),
              TextButton(
                onPressed: () => AppRouter.route.pushNamed(RoutePath.seeAllTopCreator),
                child: Text(
                  "see_all".tr,
                ),
              ),
            ],
          ),
          const Gap(12),
          SizedBox(
            height: 120.h,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (controller.model.value.data?.topCreators?.length ?? 0) + 1,
              itemBuilder: (BuildContext context, int index) {
                final creators = controller.model.value.data?.topCreators;

                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SizedBox(
                      height: 100.0,
                      width: 80.0,
                      child: Column(
                        children: [
                          GestureDetector(
                            // onTap: ()=>controller.model.value.data?.admin?.podcast != null?AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.model.value.data?.admin?.podcast??""):null,
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFEF4849),
                                  width: 3,
                                ),
                              ),
                              child: Assets.images.splashLogo.image(),
                            ),
                          ),
                          const Gap(5),
                          const CustomText(
                            text: "Joe",
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final item =
                    creators != null && index - 1 < creators.length ? creators[index - 1] : null;

                if (item == null) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    height: 100.0,
                    width: 80.0,
                    child: Column(
                      children: [
                        GestureDetector(
                          // onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.model.value.data?.topCreators?[index-1].podcast??""),
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(80.0, 80.0),
                                  painter: PartialCirclePainter(
                                    color: AppColors.whiteColor,
                                    strokeWidth: 1.0,
                                  ),
                                ),
                                // Circle with CachedNetworkImage
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: CustomNetworkImage(
                                        imageUrl: item.profileImage ?? "",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(5),
                        CustomText(
                          text: _formatName(item.name),
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatName(String? name) {
    if (name == null || name.trim().isEmpty) return "Unknown";

    final parts = name.trim().split(RegExp(r'\s+'));

    final first = parts[0];
    final second = parts.length > 1 ? parts[1] : '';

    if (first.length < 6 && second.isNotEmpty) {
      return '$first $second';
    }

    return first;
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
