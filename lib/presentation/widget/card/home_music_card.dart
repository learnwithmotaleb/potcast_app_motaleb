import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class HomeMusicCard extends StatelessWidget {
  const HomeMusicCard({
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
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          height: 200,
          width: (width / 2) - 50,
          child: Padding(
            padding: EdgeInsets.only(bottom: bgColor != null ? 12.0 : 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              color: bgColor ?? Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomNetworkImage(
                      imageUrl: data.image,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Gap(8),
                  if (data.title.isNotEmpty)
                    CustomText(
                      text: data.title,
                      fontSize: 14,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
