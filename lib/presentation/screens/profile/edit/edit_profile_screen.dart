import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.find<ProfileController>();

  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birth = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: controller.profile.value.data?.name ?? "");
    phone = TextEditingController(text: controller.profile.value.data?.contact ?? "");
    address = TextEditingController(text: controller.profile.value.data?.address ?? "");
    birth = TextEditingController(text: controller.profile.value.data?.dateOfBirth ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(12),
                      Obx(() {
                        return Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: controller.pickImage,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.profile.value.data?.avatar != null ? null : AppColors.whiteColor,
                              ),
                              child: controller.selectedImage.value != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(File(controller.selectedImage.value?.path ?? ""), fit: BoxFit.cover),
                              )
                                  : controller.profile.value.data?.avatar != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CustomNetworkImage(imageUrl: controller.profile.value.data?.avatar??""),
                              ) : const Icon(Icons.image_outlined,color: AppColors.blackColor),
                            ),
                          ),
                        );
                      }),
                      const Gap(12),
                      CustomAlignText(text: "Cover".tr),
                      const Gap(8),
                      Obx(() {
                        return Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: controller.pickCoverImage,
                            child: Container(
                              height: 100,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF093028),
                                    Color(0xFF237A57),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: controller.selectedCoverImage.value != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(File(controller.selectedCoverImage.value?.path ?? ""), fit: BoxFit.cover),
                              ) : controller.profile.value.data?.backgroundImage != null ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CustomNetworkImage(imageUrl: controller.profile.value.data?.backgroundImage??""),
                              ) : const Icon(Icons.image_outlined,color: AppColors.blackColor),
                            ),
                          ),
                        );
                      }),
                      Gap(12.h),
                      CustomAlignText(text: "full_name".tr),
                      const Gap(8),
                      CustomTextField(
                        hintText: "enter_your_full_name".tr,
                        keyboardType: TextInputType.name,
                        controller: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                          if (!nameRegex.hasMatch(value)) {
                            return 'Name can only contain letters and spaces';
                          }
                          return null;
                        },
                      ),
                      const Gap(12),
                      CustomAlignText(text: "date_of_birth".tr),
                      const Gap(8),
                      CustomTextField(
                        hintText: "dd-mm-yyy".tr,
                        keyboardType: TextInputType.name,
                        controller: birth,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your ${'date_of_birth'.tr}';
                          }
                          return null;
                        },
                      ),
                      const Gap(12),
                      CustomAlignText(text: "address".tr),
                      const Gap(8),
                      CustomTextField(
                        hintText: "enter_your_address".tr,
                        keyboardType: TextInputType.streetAddress,
                        controller: address,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your ${'address'.tr}';
                          }
                          return null;
                        },
                      ),
                      const Gap(12),
                      CustomAlignText(text: "phone_number".tr),
                      const Gap(8),
                      CustomTextField(
                        hintText: "enter_your_phone_number".tr,
                        keyboardType: TextInputType.number,
                        controller: phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'enter_your_phone_number'.tr;
                          }
                          return null;
                        },
                      ),
                      const Gap(12),
                      CustomAlignText(text: "gender".tr),
                      Obx(() {
                        return Row(
                          children: [
                            Radio<String>(
                              value: "male",
                              groupValue: controller.gender.value,
                              onChanged: (value) {
                                controller.updateGender(value: "male");
                              },
                              activeColor: AppColors.redColor,
                            ),
                            CustomText(text: "male".tr),
                            const Gap(12),
                            Radio<String>(
                              value: "female",
                              groupValue: controller.gender.value,
                              onChanged: (value) {
                                controller.updateGender(value: "female");
                              },
                              activeColor: AppColors.redColor,
                            ),
                            CustomText(text: "female".tr),
                          ],
                        );
                      }),
                      const Gap(24),
                      Obx(() {
                        return CustomButton(
                          text: "update_profile".tr,
                          onTap: () {
                            if(_formKey.currentState!.validate()){
                              if(controller.gender.value != ""){
                                final Map<String, String> body = {
                                  "name": name.text,
                                  "dateOfBirth": birth.text,
                                  "gender": controller.gender.value,
                                  "contact": phone.text.trim(),
                                  "address": address.text,
                                };

                                if(controller.selectedImage.value != null || controller.selectedCoverImage.value != null){
                                  controller.editProfile(body: body);
                                }else{
                                  controller.editProfileOnlyBody(body: body);
                                }
                              }
                            }
                          },
                          isLoading: controller.editLoading.value,
                        );
                      }),
                      const Gap(24),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
