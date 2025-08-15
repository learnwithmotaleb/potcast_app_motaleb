import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/creator/podcast/widget/pick_cover_image_widget.dart';
import 'package:podcast/presentation/screens/playlist/controller/playlist_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';

class PlaylistAddInfoScreen extends StatefulWidget {
  const PlaylistAddInfoScreen({super.key, required this.podcastList});

  final List<String> podcastList;

  @override
  State<PlaylistAddInfoScreen> createState() => _PlaylistAddInfoScreenState();
}

class _PlaylistAddInfoScreenState extends State<PlaylistAddInfoScreen> {
  final controller = Get.find<PlaylistController>();
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final description = TextEditingController();
  final tag = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    tag.dispose();

    Future.microtask(() {
      controller.selectedImage.value = null;
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Playlist Info"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Gap(12),
              CustomAlignText(text: "cover_page_upload".tr),
              const Gap(8),
              Obx(() {
                return PickCoverImageWidget(
                  onTap: () => controller.pickImage(),
                  selectedImage: controller.selectedImage.value,
                );
              }),
              const Gap(12.0),
              CustomAlignText(text: "name".tr),
              const Gap(8.0),
              CustomTextField(
                hintText: "Enter Playlist name".tr,
                keyboardType: TextInputType.text,
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Playlist Name'.tr;
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
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      String textValue = tag.text.trim();
                      List<String> items = textValue
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      if (widget.podcastList.isNotEmpty) {
                        final imagePath = controller.selectedImage.value?.path;
                        if (imagePath != null) {
                          final file = File(imagePath);
                          final body = {
                            "data": jsonEncode({
                              "userType": "NormalUser",
                              "name": name.text,
                              "description": description.text,
                              "tags": items,
                              "podcasts": widget.podcastList,
                            }),
                          };

                          controller.createPlayList(body: body, imageFile: file);
                        }
                      }
                    }
                  },
                  isLoading: controller.isLoading.value,
                );
              }),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
