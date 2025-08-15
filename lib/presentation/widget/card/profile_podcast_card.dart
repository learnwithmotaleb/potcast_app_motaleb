import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class ProfilePodcastCard extends StatelessWidget {
  const ProfilePodcastCard({
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
          height: 100,
          width: 140,
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
                if (data.title.isNotEmpty)
                  CustomText(
                    text: data.title,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.visible,
                    color: AppColors.whiteColor.withValues(alpha: 0.7),
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
