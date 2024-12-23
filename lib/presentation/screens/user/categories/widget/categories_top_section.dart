import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
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
          Gap(24.h),
          GestureDetector(
            onTap: () => AppRouter.route.pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.images.splashLogo.image(height: 60.h, width: 100.w, fit: BoxFit.cover, color: isDarkMode ? null : AppColors.blackColor),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Assets.icons.notification.svg(height: 25.h, width: 25.w),
                ),
              ],
            ),
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CupertinoSearchTextField(
              itemColor: CupertinoColors.systemGrey,
              placeholder:  "what_would_you_like_to_listen".tr,
              style: const TextStyle(fontSize: 16, color: CupertinoColors.white),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(8),
              ),
              onSubmitted: (value) {
                controller.getSearch(id: widget.id, search: value);
              },
            ),
          ),
          const Gap(12),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(5),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(text: controller.categoryModel.value.data?.category?.title ??"", fontSize: 16, color: AppColors.whiteColor, textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: 100.h,
                    width: width / 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(75)
                      ),
                      child: CustomNetworkImage(imageUrl: controller.categoryModel.value.data?.category?.categoryImage ?? ""),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
