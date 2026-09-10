import 'package:flutter/material.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

/// Poster-style card used by the Home "Series" section.
/// Shows the cover image with the title overlaid at the bottom
/// (Netflix/poster style), same visual language as the reel cards.
class HomeSeriesCard extends StatelessWidget {
  const HomeSeriesCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
    required this.width,
    this.height = 250,
  });

  final String imageUrl;
  final String title;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: CustomNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.85),
                  Colors.transparent,
                ],
                stops: const [0, 0.65],
              ),
            ),
            child: CustomText(
              text: title,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
