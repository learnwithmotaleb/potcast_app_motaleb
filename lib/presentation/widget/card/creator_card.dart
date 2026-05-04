import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class CreatorCard extends StatelessWidget {
  const CreatorCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  final AudioPlayerModel data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 200,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
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
    );
  }
}
