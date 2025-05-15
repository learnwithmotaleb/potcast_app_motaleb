import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/controller/categories_controller.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_video_controller.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/categories_model.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/map/search_my_location.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:path/path.dart' as path;

class PodcastVideoAddScreen extends StatefulWidget {
  const PodcastVideoAddScreen({super.key});

  @override
  State<PodcastVideoAddScreen> createState() => _PodcastVideoAddScreenState();
}

class _PodcastVideoAddScreenState extends State<PodcastVideoAddScreen> {
  final controller = Get.find<PodcastVideoController>();
  final category = Get.find<GlobalCategoriesController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("add_video".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                  switch (category.loading.value) {
                    case Status.loading:
                      return const Center(child: CircularProgressIndicator());
                    case Status.internetError:
                      return NoInternetCard(onTap: () => category.getCategories());
                    case Status.noDataFound:
                      return const Center(child: CustomText(text: "No data found!"));
                    case Status.error:
                      return NoInternetCard(onTap: () => category.getCategories());
                    case Status.completed:
                      return Column(
                        children: [
                          CustomAlignText(text: "category".tr),
                          const Gap(8),
                          CategoriesWidget(),
                          const Gap(12),
                          CustomAlignText(text: "sub_category".tr),
                          const Gap(8),
                          SubCategoriesWidget(),
                          const Gap(12),
                        ],
                      );
                  }
                },
              ),
              CustomAlignText(text: "cover_page_upload".tr),
              const Gap(8),
              PickCoverWidget(),
              const Gap(12),
              CustomAlignText(text: "add_video".tr),
              const Gap(8),
              PickAudioWidget(),
              const Gap(12.0),
              CustomAlignText(text: "podcast_title".tr),
              const Gap(8.0),
              CustomTextField(
                hintText: "enter_podcast_title".tr,
                keyboardType: TextInputType.text,
                controller: controller.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_podcast_title'.tr;
                  }
                  return null;
                },
              ),
              const Gap(12),
              CustomAlignText(text: "location".tr),
              const Gap(8),
              GestureDetector(
                onTap: () async {
                  final location = await showMapDialog(context: context);

                  if (location != null && location.isNotEmpty) {
                    controller.selectedAddress.value = location;
                  } else {
                    print("User dismissed the dialog or nothing selected");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.whiteColor),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.greenLight.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Obx(() {
                        return Text(controller.selectedAddress.value.tr);
                      })),
                      const Icon(Iconsax.location),
                    ],
                  ),
                ),
              ),
              const Gap(12),
              CustomAlignText(text: "description".tr),
              const Gap(8.0),
              CustomTextField(
                hintText: "enter_your_description".tr,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                minLines: 3,
                controller: controller.description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_your_description'.tr;
                  }
                  return null;
                },
              ),
              const Gap(24),
              Obx(() {
                return CustomButton(
                  text: "create".tr,
                  onTap: () => uploadAudio(),
                  isLoading: controller.createLoading.value,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void uploadAudio() {
    final validate = _formKey.currentState!.validate();
    final cat = controller.categoriesId.value.isNotEmpty;
    final subCat = controller.subCategoriesId.value.isNotEmpty;
    final city = controller.selectedAddress.value;
    final allFile = controller.selectedImage.value != null && controller.videoFile.value != null;

    if (validate && cat && subCat) {
      if (allFile) {
        final Map<String, String> body = {
          "categoryId": controller.categoriesId.value,
          "subCategoryId": controller.subCategoriesId.value,
          "title": controller.title.text,
          "description": controller.description.text,
          "location": city,
          "isVideo": "true",
        };
        final List<MultipartBody> multipartBody = [
          MultipartBody('audio', File(controller.videoFile.value?.path ?? "")),
          MultipartBody('cover', File(controller.selectedImage.value?.path ?? "")),
        ];

        controller.createPodcast(body: body, multipartBody: multipartBody);
      } else {
        toastMessage(message: "Please Provide all information");
      }
    } else {
      toastMessage(message: "Please Provide all information");
    }
  }
}

class SubCategoriesWidget extends StatelessWidget {
  SubCategoriesWidget({super.key});

  final controller = Get.find<PodcastVideoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField2<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        isExpanded: true,
        value: controller.subCategories.isEmpty ? "" : controller.subCategories.first.title,
        hint: Text('sub categories'.tr),
        items: controller.subCategories.isNotEmpty
            ? controller.subCategories.map((subCategory) {
                return DropdownMenuItem<String>(
                  value: subCategory.title ?? "",
                  child: Text(subCategory.title ?? ""),
                );
              }).toList()
            : [
                const DropdownMenuItem<String>(
                  value: "",
                  child: Text("No subcategories available"),
                ),
              ],
        onChanged: (String? newValue) {
          if (newValue != null && newValue != "") {
            controller.selectedSubCategories.value = newValue;
            var selectedSubCategory =
                controller.subCategories.firstWhere((subCategory) => subCategory.title == newValue, orElse: () => SubCategory(id: "", title: ""));
            controller.subCategoriesId.value = selectedSubCategory.id ?? "";
          }
        },
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({super.key});

  final controller = Get.find<PodcastVideoController>();
  final category = Get.find<GlobalCategoriesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField2(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        isExpanded: true,
        hint: const Text('Category'),
        items: category.categories.value.data != null && category.categories.value.data!.isNotEmpty
            ? category.categories.value.data!.map((category) {
                return DropdownMenuItem<String>(
                  value: category.title,
                  child: Text(category.title ?? ""),
                );
              }).toList()
            : [
                const DropdownMenuItem<String>(
                  value: "",
                  child: Text("No categories available"),
                )
              ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.updateSubCategories(newValue, category.categories.value);
          }
        },
      );
    });
  }
}

class PickCoverWidget extends StatelessWidget {
  PickCoverWidget({super.key});

  final controller = Get.find<PodcastVideoController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.pickImage(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(1),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          strokeWidth: 1,
          dashPattern: const [10, 5],
          color: const Color(0xFF1849D6),
          child: Obx(
            () => controller.selectedImage.value == null
                ? Container(
                    width: width,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.greenLight.withValues(alpha: 0.1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.icons.cloudAdd.svg(),
                        const Gap(8),
                        CustomText(text: "Choose_a_file_or_it_here".tr, fontWeight: FontWeight.w600, fontSize: 16),
                        const Gap(8),
                        CustomText(text: "JPEG_PNG_and_MP4_formats".tr, fontWeight: FontWeight.w100)
                      ],
                    ),
                  )
                : SizedBox(
                    height: 150,
                    width: width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(controller.selectedImage.value?.path ?? ""), fit: BoxFit.cover),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class PickAudioWidget extends StatelessWidget {
  PickAudioWidget({super.key});

  final controller = Get.find<PodcastVideoController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.pickVideo(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(1),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          strokeWidth: 1,
          dashPattern: const [10, 5],
          color: const Color(0xFF1849D6),
          child: Obx(
            () => Container(
              width: width,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.greenLight.withValues(alpha: 0.1),
              ),
              child: controller.videoFile.value == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.icons.cloudAdd.svg(),
                        const Gap(8),
                        CustomText(text: "Choose_a_video".tr, fontWeight: FontWeight.w600, fontSize: 16),
                        const Gap(8),
                        CustomText(text: "max_10_MB_files_are_allowed".tr, fontWeight: FontWeight.w100)
                      ],
                    )
                  : SizedBox(
                      width: width,
                      height: 50.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50.h,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomText(
                                text: controller.videoFile.value?.path != null ? path.basename(controller.videoFile.value!.path) : "",
                              ),
                            ),
                          ),
                          const Gap(5),
                          GestureDetector(
                            onTap: () => controller.videoFile.value = null,
                            child: Container(
                              height: 50.h,
                              width: 50.w,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.cancel_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
