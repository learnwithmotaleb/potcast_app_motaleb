import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/helper/local_db/local_db.dart';
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
  TextEditingController address = TextEditingController();
  TextEditingController donationUrl = TextEditingController();
  final ValueNotifier<DateTime> dob = ValueNotifier(DateTime(2000));

  @override
  void initState() {
    super.initState();
    final data = controller.profile.value.data;
    name = TextEditingController(text: controller.profile.value.data?.name ?? "");
    final gender = controller.profile.value.data?.gender;
    final isGender = ["Male", "Female", "Other"].contains(gender);
    controller.updateGender(value: isGender? gender ?? "" : "");
    address = TextEditingController(text: controller.profile.value.data?.address ?? "");
    donationUrl = TextEditingController(text: controller.profile.value.data?.donationLink ?? "");
    dob.value = data?.dateOfBirth != null ? data?.dateOfBirth ?? DateTime(2000) : DateTime(2000);
  }

  @override
  void dispose() {
    name.dispose();
    address.dispose();
    dob.dispose();
    donationUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        final profileImage = controller.profile.value.data?.profileImage ?? "";
                        return Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: controller.pickImage,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: profileImage.isNotEmpty ? null : AppColors.blackColor,
                                border: Border.all(color: AppColors.whiteColor),
                              ),
                              child: controller.selectedImage.value != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                          File(controller.selectedImage.value?.path ?? ""),
                                          fit: BoxFit.cover),
                                    )
                                  : profileImage.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CustomNetworkImage(imageUrl: profileImage),
                                        )
                                      : const Icon(
                                          Iconsax.gallery,
                                          color: AppColors.whiteColor,
                                        ),
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
                      ValueListenableBuilder(
                        valueListenable: dob,
                        builder: (_, date, child) {
                          return GestureDetector(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(1990),
                                maxTime: DateTime.now(),
                                onConfirm: (value) {
                                  dob.value = value;
                                },
                                currentTime: DateTime(2000),
                              );
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.whiteColor),
                              ),
                              child: CustomText(
                                text: DateFormat("dd MMMM yyyy - EEEE").format(date),
                              ),
                            ),
                          );
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
                      FutureBuilder(
                        future: DBHelper().getUserRole(),
                        builder: (context, item){
                          if(item.hasData && item.data != null && item.data!.isNotEmpty && item.data == "creator"){
                            return Column(
                              children: [
                                const Gap(12),
                                const CustomAlignText(text: "Donation URL"),
                                const Gap(8),
                                CustomTextField(
                                  hintText: "Enter Donation URL",
                                  keyboardType: TextInputType.url,
                                  controller: donationUrl,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Donation URL';
                                    }
                                    const urlPattern = r'^(http|https):\/\/[^\s]+$';
                                    if (!RegExp(urlPattern).hasMatch(value)) {
                                      return 'Please Enter Donation URL';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const Gap(12),
                      CustomAlignText(text: "gender".tr),
                      Obx(() {
                        return Row(
                          children: [
                            Radio<String>(
                              value: "Male",
                              groupValue: controller.gender.value,
                              onChanged: (value) {
                                controller.updateGender(value: "Male");
                              },
                              activeColor: AppColors.redColor,
                            ),
                            CustomText(text: "male".tr),
                            const Gap(12),
                            Radio<String>(
                              value: "Female",
                              groupValue: controller.gender.value,
                              onChanged: (value) {
                                controller.updateGender(value: "Female");
                              },
                              activeColor: AppColors.redColor,
                            ),
                            CustomText(text: "female".tr),
                            const Gap(12),
                            Radio<String>(
                              value: "Other",
                              groupValue: controller.gender.value,
                              onChanged: (value) {
                                controller.updateGender(value: "Other");
                              },
                              activeColor: AppColors.redColor,
                            ),
                            CustomText(text: "Other".tr),
                          ],
                        );
                      }),
                      const Gap(24),
                      Obx(() {
                        return CustomButton(
                          text: "update_profile".tr,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              final data = controller.profile.value.data;

                              final String nameValue = name.text.trim();
                              final String genderValue = controller.gender.value.trim();
                              final String addressValue = address.text.trim();
                              final String urlValue = donationUrl.text.trim();
                              final DateTime dobValue = dob.value;

                              final String? oldName = data?.name?.trim();
                              final String? oldGender = data?.gender?.trim();
                              final String? oldAddress = data?.address?.trim();
                              final String? oldDonationUrl = data?.donationLink?.trim();
                              final DateTime? oldDob = data?.dateOfBirth;

                              final Map<String, String?> rawBody = {};

                              if (nameValue.isNotEmpty && nameValue != oldName) {
                                rawBody["name"] = nameValue;
                              }
                              if (genderValue.isNotEmpty && genderValue != oldGender) {
                                rawBody["gender"] = genderValue;
                              }
                              if (addressValue.isNotEmpty && addressValue != oldAddress) {
                                rawBody["address"] = addressValue;
                              }
                              if (urlValue.isNotEmpty && urlValue != oldDonationUrl) {
                                rawBody["donationLink"] = urlValue;
                              }
                              if (oldDob == null || !isSameDate(dobValue, oldDob)) {
                                rawBody["dateOfBirth"] = dobValue.toUtc().toIso8601String();
                              }
                              if (oldDob == null || !isSameDate(dobValue, oldDob)) {
                                rawBody["dateOfBirth"] = dobValue.toUtc().toIso8601String();
                              }

                              final Map<String, String> body = Map.from(rawBody)
                                ..removeWhere(
                                    (key, String? value) => value == null || value.trim().isEmpty);
                              final Map<String, String> finalBody = {
                                "data": jsonEncode(body),
                              };

                              if (controller.selectedImage.value != null ||
                                  controller.selectedCoverImage.value != null) {
                                controller.editProfile(body: finalBody);
                              } else {
                                controller.editProfileOnlyBody(body: finalBody);
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

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
