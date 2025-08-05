import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class MusicCard extends StatelessWidget {
  const MusicCard({
    super.key,
    required this.data,
    required this.onTap,
    this.bgColor,
    this.onLongPress,
  });

  final AudioPlayerModel data;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final displayTitle = data.title?.trim().isNotEmpty == true ? data.title! : "Unknown";
    final categoryCheck = data.categories?.trim().isNotEmpty == true;
    final artistCheck = data.artist?.trim().isNotEmpty == true;
    final displayCategory = categoryCheck ? data.categories!
        : artistCheck ? data.artist! : "Uncategorized";
    final durationCheck = data.duration?.trim().isNotEmpty == true;
    final displayDuration = durationCheck ? data.duration! : "0:00";
    final imageCheck = data.image?.trim().isNotEmpty == true;
    final displayImage = imageCheck ? data.image! : AppConstants.defaultCoverImage;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor ?? (isDark ? const Color(0xFF1F1F26) : Colors.white),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.grey.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomNetworkImage(
                    borderRadius: BorderRadius.circular(6),
                    imageUrl: displayImage,
                    width: 90,
                    height: 90,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: Assets.icons.play.svg(
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(14),
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: displayTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      CustomText(
                        text: displayCategory,
                        fontSize: 12,
                        color: AppColors.searchBoxColor,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 14, color: AppColors.searchBoxColor),
                          const Gap(5),
                          CustomText(
                            text: _formatDuration(displayDuration),
                            fontSize: 12,
                            color: AppColors.searchBoxColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(String rawDuration) {
    final int totalSeconds = int.tryParse(rawDuration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;

    final String formattedSeconds = seconds.toString().padLeft(2, '0');
    return "$minutes:$formattedSeconds";
  }
}
