import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/card/custom_profile_tile.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Obx(
            () {
          switch (_controller.loading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(onTap: (){
                _controller.getProfile();
              });
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: (){
                _controller.getProfile();
              });

            case Status.completed:
              return SafeArea(
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
                            Container(
                              height: 100.h,
                              width: 100.h,
                              decoration: BoxDecoration(
                                color: _controller.profile.value.data?.avatar != null?null:AppColors.blackColor,
                                borderRadius: BorderRadius.circular(50.0.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0.r),
                                child: _controller.profile.value.data?.avatar != null?CustomNetworkImage(imageUrl: _controller.profile.value.data?.avatar??""):const Center(child: Icon(Icons.person,color: AppColors.whiteColor)),
                              ),
                            ),
                            Gap(8.h),
                            CustomText(text: _controller.profile.value.data?.name??"",fontSize: 16,fontWeight: FontWeight.w700,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                            const Gap(2),
                            CustomText(text: _controller.profile.value.data?.email??"",fontSize: 12,fontWeight: FontWeight.w100,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                            const Gap(2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(text: "birthday",fontWeight: FontWeight.w800,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                                CustomText(text: " ${_controller.profile.value.data?.dateOfBirth}",fontWeight: FontWeight.w100,color: isDarkMode?AppColors.blackColor:AppColors.blackColor,),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(44.h),
                      CustomProfileTile(
                        text: _controller.profile.value.data?.name??"",
                        icon: Assets.icons.person.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: (){},
                      ),
                      const Gap(24),
                      CustomProfileTile(
                        text: _controller.profile.value.data?.dateOfBirth??"",
                        icon: Assets.icons.birthday.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: (){},
                      ),
                      const Gap(24),
                      CustomProfileTile(
                        text: _controller.profile.value.data?.gender??"",
                        icon: Assets.icons.gender.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: (){},
                      ),
                      const Gap(24),
                      CustomProfileTile(
                        text: _controller.profile.value.data?.contact??"",
                        icon: Assets.icons.phone.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: (){},
                      ),
                      const Gap(24),
                      CustomProfileTile(
                        text: _controller.profile.value.data?.address??"",
                        icon: Assets.icons.homeWhite.svg(height: 20, width: 20,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: (){},
                      ),
                      const Gap(24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomButton(text: "edit_profile".tr,onTap: ()=>AppRouter.route.pushNamed(RoutePath.editProfileScreen)),
                      ),
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
