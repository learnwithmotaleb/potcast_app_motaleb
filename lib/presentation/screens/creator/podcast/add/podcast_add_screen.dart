import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'controller/podcast_add_controller.dart';

class PodcastAddScreen extends StatefulWidget {
  const PodcastAddScreen({super.key});

  @override
  State<PodcastAddScreen> createState() => _PodcastAddScreenState();
}

class _PodcastAddScreenState extends State<PodcastAddScreen> {
  final controller = Get.find<PodcastAddController>();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("ddd_podcast".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
        child: Column(
          children: [
            CustomAlignText(text: "category".tr),
            const Gap(8),
            Obx(() {
              return DropdownButtonFormField2(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                isExpanded: true,
                value: controller.selectedCategory.value,
                hint: const Text('Genres'),
                items: controller.dropdownData.keys.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  controller.selectedCategory.value = newValue;
                  controller.selectedItem.value = null;
                },
              );
            }),
            const Gap(12),
            CustomAlignText(text: "sub_category".tr),
            const Gap(8),
            Obx(() {
              return DropdownButtonFormField2(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                isExpanded: true,
                value: controller.selectedItem.value,
                hint: Text('select'.tr),
                items: controller.items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  controller.selectedItem.value = newValue;
                },
              );
            }),
            const Gap(12),
            CustomAlignText(text: "cover_page_upload".tr),
            const Gap(8),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12)
              ),
              padding: const EdgeInsets.all(1),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                strokeWidth: 1,
                dashPattern: const [10,5],
                color: const Color(0xFF1849D6),
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.images.upload.image(width: 36.w,height: 24.h),
                      const Gap(8),
                      Container(
                        width: width/3,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.blackColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Assets.icons.addAPhoto.svg(width: 24.w,height: 24.h),
                            const Gap(5),
                            CustomText(text: "add_image".tr,fontWeight: FontWeight.w600)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(12),
            CustomAlignText(text: "add_audio".tr),
            const Gap(8),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12)
              ),
              padding: const EdgeInsets.all(1),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                strokeWidth: 1,
                dashPattern: const [10,5],
                color: const Color(0xFF1849D6),
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Assets.images.upload.image(width: 36.w,height: 24.h),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(text: "drag_your_file_or".tr,fontWeight: FontWeight.w600,color: AppColors.blackColor),
                          const Gap(2),
                          CustomText(text: "browse".tr,fontWeight: FontWeight.w600,color: AppColors.redColor),
                        ],
                      ),
                      const Gap(8),
                      CustomText(text: "max_10_MB_files_are_allowed".tr,fontWeight: FontWeight.w600,color: const Color(0xFF6D6D6D),),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(12.0),
            CustomAlignText(text: "podcast_title".tr),
            const Gap(8.0),
            CustomTextField(
              hintText: "enter_podcast_title".tr,
              keyboardType: TextInputType.name,
            ),
            const Gap(12),
            CustomAlignText(text: "location".tr),
            const Gap(8.0),
            CustomTextField(
              hintText: "type_you_location".tr,
              keyboardType: TextInputType.streetAddress,
            ),
            const Gap(12),
            CustomAlignText(text: "description".tr),
            const Gap(8.0),
            CustomTextField(
              hintText: "enter_your_description".tr,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              minLines: 3,
            ),
            const Gap(24),
            CustomButton(text: "create".tr,onTap: ()=>AppRouter.route.pop()),
          ],
        ),
      ),
    );
  }
}
