import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

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
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.whiteColor : const Color(0xFFB6B4B4),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomText(
                        text: "profile",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                      ),
                      Gap(12.h),
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
                                color: controller.profile.value.data?.avatar != null ? null : AppColors.blackColor,
                              ),
                              child: controller.selectedImage.value != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(File(controller.selectedImage.value?.path ?? ""), fit: BoxFit.cover),
                                    )
                                  : controller.profile.value.data?.avatar != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: "${AppConstants.baseUrl}${controller.profile.value.data?.avatar}",
                                            placeholder: (context, data) => const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.image_outlined),
                            ),
                          ),
                        );
                      }),
                      Gap(8.h),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(44.h),
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
                            return 'enter_your_phone_number';
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

                                if(controller.selectedImage.value != null){
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
