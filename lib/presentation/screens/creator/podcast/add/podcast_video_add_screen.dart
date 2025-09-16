import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/map/search_my_location.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/service/api_service.dart';
import 'package:podcast/service/media_duration.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import '../../../../../controller/global_controller.dart';
import '../../../../../helper/function/get_audio_duration.dart';
import '../../../../widget/common/category_subcategory_picker.dart';
import '../../../../widget/loading/loading_widget.dart';
import '../controller/podcast_audio_controller.dart';
import '../widget/pick_cover_image_widget.dart';
import '../widget/pick_video_widget.dart';

class PodcastVideoAddScreen extends StatefulWidget {
  const PodcastVideoAddScreen({super.key});

  @override
  State<PodcastVideoAddScreen> createState() => _PodcastVideoAddScreenState();
}

class _PodcastVideoAddScreenState extends State<PodcastVideoAddScreen> {
  final controller = Get.find<PodcastAudioController>();
  final globalController = Get.find<GlobalController>();
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final description = TextEditingController();
  final tag = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    tag.dispose();

    Future.microtask(() {
      controller.selectedImage.value = null;
      controller.audioFile.value = null;
      controller.videoFile.value = null;
      controller.selectedCategoryId.value = "";
      controller.selectedSubcategoryId.value = "";
      controller.createLoading.value = false;
    });

    super.dispose();
  }

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
                final globalState = globalController.loading.value;
                if (globalState == Status.loading) {
                  return const LoadingWidget(color: AppColors.whiteColor);
                }
                if (globalState == Status.internetError ||
                    globalState == Status.error) {
                  return NoInternetCard(
                      onTap: () => globalController.getCategories());
                }
                if (globalState == Status.noDataFound) {
                  return const Center(
                      child: CustomText(text: "No data found!"));
                }

                return Obx(() => CategorySubcategoryPicker(
                      selectedCategoryId: controller.selectedCategoryId.value,
                      selectedSubcategoryId:
                          controller.selectedSubcategoryId.value,
                      globalController: globalController,
                      onCategoryChanged: (id) {
                        controller.selectedCategoryId.value = id ?? '';
                        controller.selectedSubcategoryId.value = '';
                      },
                      onSubcategoryChanged: (id) {
                        controller.selectedSubcategoryId.value = id ?? '';
                      },
                    ));
              }),
              CustomAlignText(text: "cover_page_upload".tr),
              const Gap(8),
              Obx(() {
                return PickCoverImageWidget(
                  onTap: () => controller.pickImage(),
                  selectedImage: controller.selectedImage.value,
                );
              }),
              const Gap(12),
              CustomAlignText(text: "add_video".tr),
              const Gap(8),
              PickVideoWidget(),
              const Gap(12.0),
              CustomAlignText(text: "podcast_title".tr),
              const Gap(8.0),
              CustomTextField(
                hintText: "enter_podcast_title".tr,
                keyboardType: TextInputType.text,
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
              const Gap(8),
              GestureDetector(
                onTap: () async {
                  final location = await showMapDialog(context: context);
                  if (location != null && location.address.isNotEmpty) {
                    controller.selectedAddress.value = location;
                  } else {
                    debugPrint("User dismissed the dialog or nothing selected");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.whiteColor),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.blackColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Obx(() {
                        return Text(controller.selectedAddress.value?.address ??
                            "Select Your Location");
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
                controller: description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_your_description'.tr;
                  }
                  return null;
                },
              ),
              const Gap(12),
              CustomAlignText(text: "Tag".tr),
              const Gap(8.0),
              CustomTextField(
                hintText: "Enter tags like 'Explanation, Explanation'".tr,
                keyboardType: TextInputType.text,
                controller: tag,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter at least one tag'.tr;
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
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  void uploadAudio() async {
    final validate = _formKey.currentState!.validate();
    final hasCategory = controller.selectedCategoryId.isNotEmpty;
    final hasSubCategory = controller.selectedSubcategoryId.isNotEmpty;
    final city = controller.selectedAddress.value?.address ?? "";
    final double longitude = controller.selectedAddress.value?.longitude ?? 0;
    final double latitude = controller.selectedAddress.value?.latitude ?? 0;

    final File? audioFile = controller.audioFile.value;
    final File? videoFile = controller.videoFile.value;
    final File? imageFile = controller.selectedImage.value;

    if (!hasCategory) {
      toastMessage(message: "Please select a category.");
      return;
    }

    if (!hasSubCategory) {
      toastMessage(message: "Please select a subcategory.");
      return;
    }

    if (city.isEmpty || latitude == 0 || longitude == 0) {
      toastMessage(message: "Please select a valid location.");
      return;
    }

    if (imageFile == null) {
      toastMessage(message: "Cover image is required");
      return;
    }

    if (audioFile == null && videoFile == null) {
      toastMessage(message: "Please provide either an audio or a video file");
      return;
    }

    Duration? duration;

    try {
      final info = await MediaDuration.getMediaDuration(videoFile!.path);
      print(info);
      if (info['success'] == true) {
        final int? durationMillis = info['durationMillis'];
        if (durationMillis != null) {
          duration = Duration(milliseconds: durationMillis);
        }
        print('ms: $durationMillis, text: ${info['durationString']}');
      } else {
        toastMessage(message: "Please try again, duration get issue");
        return;
      }
    } catch (e) {
      print(e.toString());
      toastMessage(message: "Please try again, duration get issue");
      return;
    }

    try {
      if (validate && hasCategory && hasSubCategory) {

        String textValue = tag.text.trim();
        List<String> items = textValue
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();


        final Map<String, dynamic> body = {
          "category": controller.selectedCategoryId.value,
          "subCategory": controller.selectedSubcategoryId.value,
          "name": title.text,
          "title": title.text,
          "description": description.text,
          "address": city,
          "tags": items,
          "duration": duration?.inSeconds,
          "location": {
            "type": "Point",
            "coordinates": [
              longitude,
              latitude,
            ]
          },
        };
        final List<MultipartBody> multipartBody = [];

        final audioPath = controller.audioFile.value?.path;
        if (audioPath != null && audioPath.isNotEmpty) {
          multipartBody.add(MultipartBody('audio', File(audioPath)));
        }

        final imagePath = controller.selectedImage.value?.path;
        if (imagePath != null && imagePath.isNotEmpty) {
          multipartBody.add(MultipartBody('cover', File(imagePath)));
        }

        final videoPath = controller.videoFile.value?.path;
        if (videoPath != null && videoPath.isNotEmpty) {
          multipartBody.add(MultipartBody('video', File(videoPath)));
        }

        controller.uploadAllFiles(body: body, selectedFiles: multipartBody);
      } else {
        toastMessage(message: "Please Provide all information");
      }
    } catch (_) {
      toastMessage(message: "Please complete all required fields");
    }
  }
}
