import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/creator/podcast/model/categories_model.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:path/path.dart' as path;

class PodcastAddScreen extends StatefulWidget {
  const PodcastAddScreen({super.key});

  @override
  State<PodcastAddScreen> createState() => _PodcastAddScreenState();
}

class _PodcastAddScreenState extends State<PodcastAddScreen> {
  final controller = Get.find<PodcastController>();
  final TextEditingController title = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.getCategories();
    super.initState();
  }

  @override
  void dispose() {
    title.clear();
    location.clear();
    description.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () => AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("ddd_podcast".tr),
      ),
      body: Obx(
        () {
          switch (controller.loading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(onTap: () {
                controller.getCategories();
              });
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: () {
                controller.getCategories();
              });

            case Status.completed:
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomAlignText(text: "category".tr),
                      const Gap(8),
                      CategoriesWidget(),
                      const Gap(12),
                      CustomAlignText(text: "sub_category".tr),
                      const Gap(8),
                      SubCategoriesWidget(),
                      const Gap(12),
                      CustomAlignText(text: "cover_page_upload".tr),
                      const Gap(8),
                      PickCoverWidget(),
                      const Gap(12),
                      CustomAlignText(text: "add_audio".tr),
                      const Gap(8),
                      PickAudioWidget(),
                      const Gap(12.0),
                      CustomAlignText(text: "podcast_title".tr),
                      const Gap(8.0),
                      CustomTextField(
                        hintText: "enter_podcast_title".tr,
                        keyboardType: TextInputType.name,
                        controller: title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'enter_podcast_title'.tr;
                          }
                          return null;
                        },
                      ),
                      const Gap(12),
                      CustomAlignText(text: "location".tr),
                      const Gap(8.0),
                      CustomTextField(
                        hintText: "type_you_location".tr,
                        keyboardType: TextInputType.streetAddress,
                        controller: location,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'type_you_location'.tr;
                          }
                          return null;
                        },
                      ),
                      const Gap(12),
                      CustomAlignText(text: "description".tr),
                      const Gap(8.0),
                      CustomTextField(
                        hintText: "enter_your_description".tr,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        minLines: 3,
                        controller: description,
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
                          onTap: () {
                            if (_formKey.currentState!.validate() && controller.selectedCategory.value != "" && controller.selectedSubCategories.value != "") {
                              if (controller.selectedImage.value != null && controller.audioFile.value != null) {
                                final Map<String, String> body = {
                                  "categoryId": controller.categoriesId.value,
                                  "subCategoryId": controller.subCategoriesId.value,
                                  "title": title.text,
                                  "description": description.text,
                                  "location": location.text,
                                };
                                final List<MultipartBody> multipartBody = [
                                  MultipartBody('audio', File(controller.audioFile.value?.path ?? "")),
                                  MultipartBody('cover', File(controller.selectedImage.value?.path ?? "")),
                                ];

                                controller.createPodcast(body: body, multipartBody: multipartBody);
                              }
                            }
                          },
                          isLoading: controller.createLoading.value,
                        );
                      }),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class SubCategoriesWidget extends StatelessWidget {
  SubCategoriesWidget({super.key});

  final controller = Get.find<PodcastController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField2<String>(
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
              var selectedSubCategory = controller.subCategories.firstWhere((subCategory) => subCategory.title == newValue, orElse: () => SubCategory(id: "", title: ""));
              controller.subCategoriesId.value = selectedSubCategory.id ?? "";
            }
          },
        ));
  }
}

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({super.key});

  final controller = Get.find<PodcastController>();

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
        items: controller.categories.value.data != null && controller.categories.value.data!.isNotEmpty
            ? controller.categories.value.data!.map((category) {
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
            controller.updateSubCategories(newValue);
          }
        },
      );
    });
  }
}

class PickCoverWidget extends StatelessWidget {
  PickCoverWidget({
    super.key,
  });

  final controller = Get.find<PodcastController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.pickImage(),
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
            () => controller.selectedImage.value == null
                ? Container(
                    width: width,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.images.upload.image(width: 36.w, height: 24.h),
                        const Gap(8),
                        Container(
                          width: width / 3,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.blackColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Assets.icons.addAPhoto.svg(width: 24.w, height: 24.h), const Gap(5), CustomText(text: "add_image".tr, fontWeight: FontWeight.w600)],
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
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

  final controller = Get.find<PodcastController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.pickAudio(),
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
              child: controller.audioFile.value == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Assets.images.upload.image(width: 36.w, height: 24.h),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(text: "drag_your_file_or".tr, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                            const Gap(2),
                            CustomText(text: "browse".tr, fontWeight: FontWeight.w600, color: AppColors.redColor),
                          ],
                        ),
                        const Gap(8),
                        CustomText(
                          text: "max_10_MB_files_are_allowed".tr,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6D6D6D),
                        ),
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
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomText(
                                text: controller.audioFile.value?.path != null ? path.basename(controller.audioFile.value!.path) : "",
                              ),
                            ),
                          ),
                          const Gap(5),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.cancel_outlined),
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
