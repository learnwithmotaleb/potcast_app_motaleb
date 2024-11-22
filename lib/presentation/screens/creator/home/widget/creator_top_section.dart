import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/creator/home/controller/creator_home_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
class CreatorTopSection extends StatelessWidget {
  CreatorTopSection({super.key});
  final controller = Get.find<CreatorHomeController>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Gap(24.h),
          Row(
            children: [
              SizedBox(
                height: 50.w,
                width: 50.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0.r),
                  child: CachedNetworkImage(
                    imageUrl: "https://img.freepik.com/free-photo/female-singer-portrait-isolated-blue-studio-wall-neon-light_155003-29661.jpg",
                    placeholder: (context, data) => const SizedBox(),
                    errorWidget: (context, data, errorWidget) => const Icon(Icons.person),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(8),
              const Flexible(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "My .podcast",fontSize: 15),
                    CustomText(text: "chandrama", fontSize: 12),
                  ],
                ),
              ),
            ],
          ),
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
              itemCount: controller.artistItem.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: ()=>AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: controller.artistItem[index]),
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
                                      child: CachedNetworkImage(
                                        imageUrl: controller.artistItem[index].image,
                                        placeholder: (context, data)=>const SizedBox(),
                                        errorWidget: (context, data, errorWidget)=>const Icon(Icons.person),
                                        fit: BoxFit.cover,
                                      )
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
                      CustomText(text: controller.artistItem[index].artist,fontSize: 8),
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
