import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import '../controller/podcast_play_controller.dart';
import 'glassmorphism_toggle_widget.dart';

class SpotifyStyleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PodcastFeedController feedController;
  final String fallbackTitle;
  final String? fallbackArtist;
  final String? fallbackCategories;
  final bool isCreator;

  const SpotifyStyleAppBar({
    super.key,
    required this.feedController,
    required this.fallbackTitle,
    this.fallbackArtist,
    this.fallbackCategories,
    this.isCreator = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30,),
        onPressed: (){
          if (!feedController.isAudioMode.value) {
            feedController.toggleMode().then((value){
              if(!context.mounted) return;
              if (Navigator.of(context).canPop()) {
                AppRouter.route.pop();
              }
            });
          }else{
            if (Navigator.of(context).canPop()) {
              AppRouter.route.pop();
            }
          }
        },
      ),
      title: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (feedController.currentItem.value?.title ?? fallbackTitle).toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              _getSubtitleText(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        );
      }),
      actions: [
        GlassMorphismToggle(
          feedController: feedController,
        ),
      ],
      centerTitle: true,
    );
  }

  String _getSubtitleText() {
    final creatorName = feedController.currentItem.value?.creatorName;
    final categoryName = feedController.currentItem.value?.categoryName;
    final artist = fallbackArtist;

    if (isCreator) {
      if (artist != null && artist.trim().isNotEmpty) {
        return artist;
      } else if (creatorName != null && creatorName.trim().isNotEmpty) {
        return creatorName;
      } else {
        return "Unknown";
      }
    } else {
      if (artist != null && artist.trim().isNotEmpty) {
        return artist;
      } else if (categoryName != null && categoryName.trim().isNotEmpty) {
        return categoryName;
      } else {
        return "Unknown";
      }
    }
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}