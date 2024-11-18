import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserTopArtistsSection extends StatelessWidget {
  const UserTopArtistsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String,String>> images = [
      {
        "name": "Chris Tomlin",
        "image": "https://img.freepik.com/premium-photo/happy-singing-girl-beauty-woman-wearing-white-t-shirt-black-hat-with-microphone-white-background-hipster-style_118342-23501.jpg"
      },
      {
        "name": "Brandon Lake",
        "image": "https://img.freepik.com/free-photo/female-singer-portrait-neon-lights_155003-8240.jpg"
      },
      {
        "name": "Bethel Music",
        "image": "https://img.freepik.com/premium-photo/caucasian-female-singer-portrait-isolated-gradient-studio-background-neon-light_489646-16996.jpg"
      },
      {
        "name": "Lauren",
        "image": "https://img.freepik.com/free-photo/happy-young-woman-standing-smiling-against-blue_155003-19961.jpg"
      },
      {
        "name": "Cody",
        "image": "https://img.freepik.com/premium-photo/image-caucasian-dark-haired-woman-wearing-stylish-jacket-standing-with-closed-eyes-listening-music-holding-cell-phone-as-microphone-singing-posing-isolated-neon-light-background_176532-19786.jpg"
      }
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(12),
          CustomAlignText(text: "top_artists".tr),
          const Gap(12),
          SizedBox(
            height: 120.h,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    children: [
                      index ==0? Container(
                        height: 80.w,
                        width: 80.w,
                        padding: EdgeInsets.all(index ==0?3:5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: index ==0?Border.all(color: const Color(0xFFFE7A15),width: 3):Border.all(color: isDarkMode?AppColors.whiteColor:AppColors.primaryColor,width: 1)
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.r),
                            child: CachedNetworkImage(
                              imageUrl: images[index]['image'].toString(),
                              placeholder: (context, data)=>const SizedBox(),
                              errorWidget: (context, data, errorWidget)=>const Icon(Icons.person),
                              fit: BoxFit.cover,
                            )
                        ),
                      ):Container(
                        height: 80.0.h,
                        width: 80.0.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size(80.0.h, 80.0.h),
                              painter: PartialCirclePainter(
                                color: isDarkMode ? AppColors.whiteColor : AppColors.primaryColor,
                                strokeWidth: 1.0,
                              ),
                            ),
                            // Circle with CachedNetworkImage
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0.r), // Make it circular
                                  child: CachedNetworkImage(
                                    imageUrl: images[index]['image'].toString(),
                                    placeholder: (context, data) => const SizedBox(), // Placeholder for loading
                                    errorWidget: (context, data, errorWidget) => const Icon(Icons.person), // Error widget
                                    fit: BoxFit.cover, // Ensure the image fits inside the circle
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(5),
                      CustomText(text: images[index]['name'].toString()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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

