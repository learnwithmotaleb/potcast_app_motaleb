import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/categories/controller/categories_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class CategoriesTopSection extends StatefulWidget {
  const CategoriesTopSection({super.key, required this.id});
  final String id;

  @override
  State<CategoriesTopSection> createState() => _CategoriesTopSectionState();
}

class _CategoriesTopSectionState extends State<CategoriesTopSection> {
  final controller = Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
/*          Gap(24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: IconButton(onPressed: (){
                  AppRouter.route.pop();
                }, icon: const Icon(Icons.arrow_back)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Assets.images.splashLogo.image(
                    height: 60.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                    color: isDarkMode ? null : AppColors.blackColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: GestureDetector(
                  onTap: ()=>AppRouter.route.pushNamed(RoutePath.notificationScreen),
                  child: Assets.icons.notification.svg(height: 25.h, width: 25.w),
                ),
              ),
            ],
          ),
          const Gap(12),*/

          Gap(24.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CupertinoSearchTextField(
              itemColor: CupertinoColors.systemGrey,
              placeholder:  "what_would_you_like_to_listen".tr,
              // style: const TextStyle(fontSize: 16, color: CupertinoColors.white),
              // placeholderStyle: const TextStyle(color: AppColors.whiteColor),
              padding: const EdgeInsets.all(18),
              placeholderStyle: const TextStyle(color: Colors.grey),
              style: const TextStyle(color: AppColors.whiteColor),
              decoration: BoxDecoration(
                  color: const Color(0xFF2A2B31),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.whiteColor)
              ),
              onSubmitted: (value) {
                controller.getSearch(id: widget.id, search: value);
              },
            ),
          ),
/*          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 100.h,
              width: width,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4849),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(5),
                  Expanded(child: CustomText(text: controller.categoryModel.value.data?.category?.title ??"", maxLines: 2, fontSize: 16, color: AppColors.whiteColor, textAlign: TextAlign.center)),
                  Expanded(child: CustomNetworkImage(imageUrl: controller.categoryModel.value.data?.category?.categoryImage ?? ""))
                ],
              ),
            ),
          ),*/
          const Gap(12),
        ],
      ),
    );
  }
}
