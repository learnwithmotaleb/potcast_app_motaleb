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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "top_artists".tr,fontSize: 22, fontWeight: FontWeight.w800),
                GestureDetector(onTap: ()=>AppRouter.route.pushNamed(RoutePath.seeAllTopCreator),child: Text("see_all".tr, style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor))),
              ],
            ),
          ),
          const Gap(12),
          SizedBox(
            height: 120.h,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (controller.model.value.data?.creators?.length??0)+1,
              itemBuilder: (BuildContext context, int index){
                if(index ==0){
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: ()=>controller.model.value.data?.admin?.podcast != null?AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.model.value.data?.admin?.podcast??""):null,
                          child: Container(
                            height: 80.w,
                            width: 80.w,
                            padding: EdgeInsets.all(index ==0?3:5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: index ==0?Border.all(color: const Color(0xFFFE7A15),width: 3):Border.all(color: isDarkMode?AppColors.whiteColor:AppColors.primaryColor,width: 1)
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40.r),
                                child: controller.model.value.data?.admin?.avatar != null?
                                CustomNetworkImage(imageUrl: controller.model.value.data?.admin?.avatar??""):
                                Assets.images.splashLogo.image()
                            ),
                          ),
                        ),
                        const Gap(5),
                        CustomText(text: controller.model.value.data?.admin?.name??"", fontSize: 16,),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.model.value.data?.creators?[index-1].podcast??""),
                        child: Container(
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
                                    child: CustomNetworkImage(imageUrl: controller.model.value.data?.creators?[index-1].avatar??""),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(5),
                      CustomText(text: controller.model.value.data?.creators?[index-1].name??"", fontSize: 16),
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
