import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class PodcastCard extends StatelessWidget {
  const PodcastCard({super.key, required this.data});
  final AudioPlayerModel data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100.w,
            height: 100.h,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: data.image,
                  placeholder: (context, data)=>const SizedBox(),
                  errorWidget: (context, data, errorWidget)=>const Icon(Icons.person),
                  fit: BoxFit.cover,
                )
            ),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: data.title,fontSize: 16,fontWeight: FontWeight.w800),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: data.album),
                        Row(
                          children: [
                            const CustomText(text: "5.50 min"),
                            const Gap(5),
                            const Icon(Icons.location_on,size: 14,color: AppColors.primaryColor),
                            const Gap(3),
                            Assets.icons.favorite.svg(height: 10,width: 10)
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: ()=>AppRouter.route.pushNamed(RoutePath.podcastEditScreen),
                          child: Container(
                            height: 25.h,
                            width: 25.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: const Color(0xFF7D6767)
                            ),
                            child: Assets.icons.edit.svg(height: 17.h,width: 17.h),
                          ),
                        ),
                        Gap(3),
                        Container(
                          height: 25.h,
                          width: 25.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color:  Color(0xFFF90E06)
                          ),
                          child: Assets.icons.delete.svg(height: 17.h,width: 17.h),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
