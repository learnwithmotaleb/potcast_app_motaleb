import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:shimmer/shimmer.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomHomeAppBar({super.key});

  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).size.width;
    return AppBar(
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              shape: BoxShape.circle
          ),
          child: Obx(()=>controller.loading.value == Status.completed?ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CustomNetworkImage(imageUrl: controller.profile.value.data?.avatar??"")
          ):Shimmer.fromColors(
            baseColor: isDarkMode?AppColors.whiteColor.withOpacity(0.2):AppColors.blackColor.withOpacity(0.2),
            highlightColor: isDarkMode?AppColors.whiteColor.withOpacity(0.5):AppColors.blackColor.withOpacity(0.5),
            child: Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.hintTextColor,
              ),
            ),
          )),
        ),
      ),
      centerTitle: false,
      title: Obx(()=>controller.loading.value == Status.completed?Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.profile.value.data?.name ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
          Text(controller.profile.value.data?.email ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
        ],
      ):Shimmer.fromColors(
        baseColor: isDarkMode?AppColors.whiteColor.withOpacity(0.2):AppColors.blackColor.withOpacity(0.2),
        highlightColor: isDarkMode?AppColors.whiteColor.withOpacity(0.5):AppColors.blackColor.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 10,
              width: width/3,
              color: AppColors.hintTextColor,
            ),
            const Gap(5),
            Container(
              height: 10,
              width: width/2,
              color: AppColors.hintTextColor,
            ),
          ],
        ),
      )),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? const Color(0xFF1C1B1B) : const Color(
                  0xFFE6F2FF),
            ),
            child: IconButton(
              onPressed: () {
                AppRouter.route.pushNamed(RoutePath.notificationScreen);
              },
              icon: const Icon(Iconsax.notification, color: AppColors.whiteColor),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}