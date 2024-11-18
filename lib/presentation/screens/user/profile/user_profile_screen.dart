import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/widget/card/custom_profile_tile.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

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
              Gap(24.h),
              CustomProfileTile(
                text: "personal_information",
                icon: Assets.icons.person.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: (){},
              ),
              const Gap(24),
              CustomProfileTile(
                text: "my_play_list",
                icon: Assets.icons.playList.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: (){},
              ),
              const Gap(24),
              CustomProfileTile(
                text: "settings",
                icon: Assets.icons.settings.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: (){},
              ),
              const Gap(24),
              CustomProfileTile(
                text: "notification",
                icon: Assets.icons.notification.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: (){},
              ),
              const Gap(24),
              CustomProfileTile(
                text: "upgrade",
                icon: Assets.icons.updrade.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                onTap: (){},
              ),
              const Gap(24),
              CustomProfileTile(
                text: "logout",
                icon: Assets.icons.logOut.svg(height: 20, width: 20),
                isLast: true,
                onTap: (){},
              ),
              const Gap(44),
            ],
          ),
        ),
      ),
    );
  }
}
