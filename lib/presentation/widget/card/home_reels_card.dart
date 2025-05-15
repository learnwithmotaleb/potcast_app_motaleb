import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class HomeReelsCard extends StatelessWidget {
  const HomeReelsCard({
    super.key,
    required this.data,
    required this.onTap,
    this.onLongPress,
    this.bgColor,
  });

  final AudioPlayerModel data;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          height: 250,
          width: (width/3)-10,
          child: Padding(
            padding: EdgeInsets.only(bottom: bgColor != null?5.0:0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              color: bgColor??Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomNetworkImage(
                      borderRadius: BorderRadius.circular(5.r),
                      imageUrl: data.image??"",
                    ),
                  ),
                  const Gap(8),
                  CustomText(text: data.title??"",fontSize: 16,fontWeight: FontWeight.w800),
                  CustomText(text: data.categories??""),
                  // CustomText(text: data.duration??""),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
