import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';

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
        child: CustomNetworkImage(
          borderRadius: BorderRadius.circular(5.r),
          imageUrl: data.image,
          height: 250,
          width: (width / 3),
        ),
      ),
    );
  }
}
