import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
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

import '../../../../../controller/global_controller.dart';
import '../../../../widget/common/category_subcategory_picker.dart';
import '../../../../widget/loading/loading_widget.dart';
import '../controller/podcast_audio_controller.dart';

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
                if (globalState == Status.loading) return const LoadingWidget(color: AppColors.whiteColor);
                if (globalState == Status.internetError || globalState == Status.error) {
                  return NoInternetCard(onTap: () => globalController.getCategories());
                }
                if (globalState == Status.noDataFound) {
                  return const Center(child: CustomText(text: "No data found!"));
                }

                return Obx(() => CategorySubcategoryPicker(
                  selectedCategoryId: controller.selectedCategoryId.value,
                  selectedSubcategoryId: controller.selectedSubcategoryId.value,
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
                    print("User dismissed the dialog or nothing selected");
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
                        return Text(controller.selectedAddress.value?.address ?? "");
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

  void uploadAudio() async{
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

    final File mediaFile = audioFile ?? videoFile!;
    final duration = await getAudioDuration(mediaFile);

    if (duration?.inSeconds == null) {
      toastMessage(message: "Please try again, duration get issue");
      return;
    }

    try{
      if (validate && hasCategory && hasSubCategory) {
        final Map<String, dynamic> body = {
          "category": controller.selectedCategoryId.value,
          "subCategory": controller.selectedSubcategoryId.value,
          "name": title.text,
          "title": title.text,
          "description": description.text,
          "address": city,
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
    }catch(_){
      toastMessage(message: "Please complete all required fields");
    }
  }
}

Future<Duration?> getAudioDuration(File file) async {
  final player = AudioPlayer();

  try {
    final audioSource = AudioSource.uri(
      Uri.file(file.path),
      tag: MediaItem(
        id: file.path,
        title: 'Temporary Audio',
      ),
    );

    await player.setAudioSource(audioSource);

    Duration? duration;
    int retryCount = 0;

    while (duration == null && retryCount < 30) {
      await Future.delayed(const Duration(milliseconds: 100));
      duration = player.duration;
      retryCount++;
    }

    return duration;
  } catch (e) {
    debugPrint("Logger 3");
    debugPrint(e.toString());
    return null;
  } finally {
    await player.dispose();
  }
}

class PickCoverWidget extends StatelessWidget {
  PickCoverWidget({super.key});

  final controller = Get.find<PodcastAudioController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.pickImage(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.whiteColor)),
        padding: const EdgeInsets.all(1),
        child: Obx(
              () => controller.selectedImage.value == null
              ? Container(
            width: width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), color: AppColors.blackColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.cloudAdd.svg(
                    colorFilter:
                    const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn)),
                const Gap(8),
                CustomText(
                    text: "Choose_a_file_or_it_here".tr,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor,
                    fontSize: 16),
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
              child: Image.file(File(controller.selectedImage.value?.path ?? ""),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

class PickAudioWidget extends StatelessWidget {
  PickAudioWidget({super.key});

  final controller = Get.find<PodcastAudioController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => controller.pickVideo(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.whiteColor,
          ),
        ),
        padding: const EdgeInsets.all(1),
        child: Obx(
          () => controller.createLoading.value ? Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_upload_rounded, size: 28),
                      const SizedBox(width: 8),
                      CustomText(
                        text: "uploading_video".tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      const Spacer(),
                      CustomText(
                        text: "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                  const Gap(12),
                  LinearProgressIndicator(
                    value: controller.uploadProgress.value,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "${controller.uploadedMB.value.toStringAsFixed(2)} MB / ${controller.totalMB.value.toStringAsFixed(2)} MB",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const Gap(8),
                ],
              ),
            ),
          ) : Container(
            width: width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.blackColor,
            ),
            child: controller.videoFile.value == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.cloudAdd.svg(
                        colorFilter: const ColorFilter.mode(
                          AppColors.whiteColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Gap(8),
                      CustomText(
                        text: "Pick a Video".tr,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                        fontSize: 16,
                      ),
                      const Gap(8),
                      CustomText(
                        text: "max_10_MB_files_are_allowed".tr,
                        fontWeight: FontWeight.w100,
                      )
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
                              text: controller.videoFile.value?.path != null
                                  ? path.basename(controller.videoFile.value!.path)
                                  : "",
                            ),
                          ),
                        ),
                        const Gap(5),
                        GestureDetector(
                          onTap: () => controller.videoFile.value = null,
                          child: Container(
                            height: 25.h,
                            width: 25.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.whiteColor),
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.all(2),
                            child: Assets.images.delete.image(color: AppColors.whiteColor),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
