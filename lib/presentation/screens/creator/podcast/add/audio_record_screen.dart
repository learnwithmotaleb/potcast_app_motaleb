import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/creator/podcast/add/podcast_add_screen.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class AudioRecordScreen extends StatefulWidget {
  const AudioRecordScreen({super.key});

  @override
  State<AudioRecordScreen> createState() => _AudioRecordScreenState();
}

class _AudioRecordScreenState extends State<AudioRecordScreen> {
  final controller = Get.find<PodcastController>();
  final TextEditingController title = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        title: Text("ddd_podcast".tr),
      ),
      body: Obx(
            () {
          switch (controller.loading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return Center(
                child: NoInternetCard(onTap: () {
                  controller.getCategories();
                }),
              );
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return Center(
                child: NoInternetCard(onTap: () {
                  controller.getCategories();
                },text: controller.responseMessage.value),
              );

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
                              }else{
                                print("***999");
                              }
                            }else{
                              print("***");
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
