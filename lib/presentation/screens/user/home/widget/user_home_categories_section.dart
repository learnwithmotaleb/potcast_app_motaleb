import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeCategoriesSection extends StatelessWidget {
  UserHomeCategoriesSection({super.key, required this.index});
  final controller = Get.find<UserHomeController>();
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: "genres_podcast_only"),
      child: Container(
        height: 80.h,
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
                child: CustomText(text: "genres_podcast".tr, color: AppColors.whiteColor, maxLines: 2, textAlign: TextAlign.start),
              ),
            ),
            SizedBox(
              height: 80.h,
              width: 100.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
                child: CachedNetworkImage(
                  imageUrl: controller.popularItem[index+1].image,
                  placeholder: (context, data)=>const SizedBox(),
                  errorWidget: (context, data, errorWidget)=>const Icon(Icons.person),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
