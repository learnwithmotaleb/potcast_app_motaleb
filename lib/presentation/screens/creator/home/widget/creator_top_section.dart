import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/creator/home/controller/creator_home_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:shimmer/shimmer.dart';

class CreatorTopSection extends StatelessWidget {
  CreatorTopSection({super.key});

  final controller = Get.find<CreatorHomeController>();
  final _controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Gap(44.h),
          Obx(()=>_controller.loading.value == Status.completed?Row(
            children: [
              SizedBox(
                height: 50.w,
                width: 50.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0.r),
                  child: CustomNetworkImage(imageUrl: _controller.profile.value.data?.avatar??""),
                ),
              ),
              const Gap(12),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: _controller.profile.value.data?.name??"",fontSize: 15),
                    CustomText(text: _controller.profile.value.data?.address??"", fontSize: 12),
                  ],
                ),
              ),
            ],
          ):MyInfoLoading(isDarkMode: isDarkMode, width: width)),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "continue_listening".tr),
              TextButton(onPressed: (){
                AppRouter.route.pushNamed(RoutePath.seeAllScreen,extra: "continue_listening");
              }, child: Text("see_all".tr,style: TextStyle(color: isDarkMode?AppColors.whiteColor:AppColors.blackColor)))
            ],
          ),
          SizedBox(
            height: 120.h,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 0,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: 0),
                        child: SizedBox(
                          height: 80.w,
                          width: 80.w,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  height: 80.w,
                                  width: 80.w,
                                  padding: EdgeInsets.all(index ==0?3:5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: index ==0?Border.all(color: const Color(0xFFFE7A15),width: 3):Border.all(color: AppColors.whiteColor,width: 1)
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.r),
                                      child: CustomNetworkImage(imageUrl: "")
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index ==0?const Color(0xFFFE7A15):AppColors.whiteColor
                                  ),
                                  child: index==0?Assets.icons.micWhite.svg():Assets.icons.mic.svg(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Gap(5),
                      const CustomText(text: "controller.artistItem[index].artist",fontSize: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "my_podcast".tr),
              TextButton(onPressed: (){
                AppRouter.route.pushNamed(RoutePath.seeAllScreen,extra: "my_podcast");
              }, child: Text("see_all".tr,style: TextStyle(color: isDarkMode?AppColors.whiteColor:AppColors.blackColor)))
            ],
          ),
        ],
      ),
    );
  }
}

class MyInfoLoading extends StatelessWidget {
  const MyInfoLoading({
    super.key,
    required this.isDarkMode,
    required this.width,
  });

  final bool isDarkMode;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDarkMode?AppColors.whiteColor.withOpacity(0.2):AppColors.blackColor.withOpacity(0.2),
      highlightColor: isDarkMode?AppColors.whiteColor.withOpacity(0.5):AppColors.blackColor.withOpacity(0.5),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
          ),
          const Gap(8),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                width: width/3,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8)
                ),
              ),
              const Gap(3),
              Container(
                height: 10,
                width: width/2,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
