import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/align/custom_align_text.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration:  BoxDecoration(
                  color: isDarkMode?AppColors.whiteColor: const Color(0xFFB6B4B4),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    CustomText(text: "profile",fontSize: 18,fontWeight: FontWeight.w700,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                    Gap(12.h),
                    SizedBox(
                      height: 100.h,
                      width: 100.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0.r),
                        child: CachedNetworkImage(
                          imageUrl: "https://img.freepik.com/free-photo/female-singer-portrait-isolated-blue-studio-wall-neon-light_155003-29661.jpg",
                          placeholder: (context, data) => const SizedBox(),
                          errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Gap(8.h),
                    CustomText(text: "Chris Tomlin",fontSize: 16,fontWeight: FontWeight.w700,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                    const Gap(2),
                    CustomText(text: "chris@gmail.com",fontSize: 12,fontWeight: FontWeight.w100,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                    const Gap(2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: "birthday",fontWeight: FontWeight.w800,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                        CustomText(text: " 20-11-2001",fontWeight: FontWeight.w100,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                      ],
                    ),
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
                    ),
                    const Gap(12),
                    CustomAlignText(text: "date_of_birth".tr),
                    const Gap(8),
                    CustomTextField(
                      hintText: "dd-mm-yyy".tr,
                      keyboardType: TextInputType.name,
                    ),
                    const Gap(12),
                    CustomAlignText(text: "address".tr),
                    const Gap(8),
                    CustomTextField(
                      hintText: "enter_your_address".tr,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const Gap(12),
                    CustomAlignText(text: "gender".tr),
                    Row(
                      children: [
                        Radio(value: 1, groupValue: 1, onChanged: (value){},activeColor: AppColors.redColor,),
                        CustomText(text: "male".tr),
                        const Gap(12),
                        Radio(value: 2, groupValue: 1, onChanged: (value){},activeColor: AppColors.redColor,),
                        CustomText(text: "female".tr),
                      ],
                    ),
                    const Gap(24),
                    CustomButton(text: "update_profile".tr,onTap: ()=>AppRouter.route.pop()),
                    const Gap(24),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
