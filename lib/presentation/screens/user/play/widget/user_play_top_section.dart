import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/user/play/controller/user_play_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserPlayTopSection extends StatefulWidget {
  const UserPlayTopSection({super.key, required this.model});
  final AudioPlayerModel model;

  @override
  State<UserPlayTopSection> createState() => _UserPlayTopSectionState();
}

class _UserPlayTopSectionState extends State<UserPlayTopSection> {
  final controller = Get.find<UserPlayController>();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(24.h),
        GestureDetector(
          onTap: ()=>AppRouter.route.goNamed(RoutePath.userNavScreen),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.splashLogo.image(height: 60.h, width: 100.w, fit: BoxFit.cover, color: isDarkMode ? null : AppColors.blackColor),
              const Gap(8),
              CustomText(text: "listen_and_be_happy".tr, family: "Bold", fontSize: 24.sp, fontWeight: FontWeight.w800)
            ],
          ),
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GestureDetector(
            onTap: ()=>AppRouter.route.pushNamed(RoutePath.searchScreen,extra: "all"),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.searchBoxColor,
                  borderRadius: BorderRadius.circular(8.r)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.search.svg(height: 22, width: 22),
                  const Gap(8),
                  CustomText(text: "what_would_you_like_to_listen".tr,
                      color: AppColors.blackColor,
                      fontSize: 16),
                ],
              ),
            ),
          ),
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomText(text: "for_you".tr,fontSize: 16,),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: "genres_podcast_only"),
                  child: Container(
                    height: 60.h,
                    padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4849),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(text: "genres_podcast".tr,
                              color: AppColors.whiteColor,
                              maxLines: 2,
                              textAlign: TextAlign.start),
                        ),
                        SizedBox(
                          height: 60.h,
                          width: ((width / 3) - 40) / 2,
                          child: Assets.images.genres.image(fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: "classical_audio"),
                  child: Container(
                    height: 60.h,
                    padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF03346E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(text: "classical_audio".tr,
                              color: AppColors.whiteColor,
                              maxLines: 2,
                              textAlign: TextAlign.start),
                        ),
                        SizedBox(
                          height: 60.h,
                          width: ((width / 3) - 40) / 2,
                          child: Assets.images.classical.image(fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen,extra: "millennial_podcast"),
                  child: Container(
                    height: 60.h,
                    padding: const EdgeInsets.only(top: 8, right: 0, left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF016450),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(text: "millennial_podcast".tr,
                              color: AppColors.whiteColor,
                              maxLines: 2,
                              textAlign: TextAlign.start),
                        ),
                        SizedBox(
                          height: 60.h,
                          width: ((width / 3) - 40) / 2,
                          child: Assets.images.millennial.image(
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomText(text: "new_music".tr),
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SizedBox(
            height: 250.h,
            width: width,
            child: ListView.builder(
              itemCount: controller.newItem.length+1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index){
                if(index ==0){
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 250.h,
                      width: width/2+100.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: CachedNetworkImage(
                            imageUrl: widget.model.image,
                            placeholder: (context, data)=>const SizedBox(),
                            errorWidget: (context, data, errorWidget)=>const Icon(Icons.person),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap:()=>controller.playAudio(controller.newItem[index - 1]),
                      child: SizedBox(
                        height: 250.h,
                        width: width/2+100.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedNetworkImage(
                              imageUrl: controller.newItem[index-1].image,
                              placeholder: (context, data)=>const SizedBox(),
                              errorWidget: (context, data, errorWidget)=>const Icon(Icons.person),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
