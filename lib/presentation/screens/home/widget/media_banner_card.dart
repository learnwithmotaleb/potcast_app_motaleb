import 'package:flutter/material.dart';
import 'package:podcast/helper/image/network_image.dart';

/// Shared card design used by both [FeatureBox] and [AdvertisingBox]:
///  - Full-width (of [width]) image, 16 : 7 aspect ratio
///  - Semi-transparent [badgeText] badge, top-left
///  - [title] bottom-left  +  white [buttonLabel] pill bottom-right
///
/// Keeping this as one widget guarantees both sections stay pixel-identical
/// in style — only the copy, image, and tap action differ.
class MediaBannerCard extends StatefulWidget {
  const MediaBannerCard({
    super.key,
    required this.imageUrl,
    required this.badgeText,
    required this.title,
    required this.buttonLabel,
    required this.onTap,
    this.width,
    this.margin,
  });

  /// Fixed width for the card. Pass null to let it fill the available width
  /// (used by AdvertisingBox's full-width slider).
  final double? width;
  final EdgeInsetsGeometry? margin;
  final String imageUrl;
  final String badgeText;
  final String title;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  State<MediaBannerCard> createState() => _MediaBannerCardState();
}

class _MediaBannerCardState extends State<MediaBannerCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: SizedBox(
            width: widget.width,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Image + badge overlay ─────────────────────────
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 7,
                        child: CustomNetworkImage(
                          imageUrl: widget.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          backgroundColor: const Color(0xFF2C2C2C),
                          errorIcon: Icons.image_not_supported_outlined,
                        ),
                      ),

                      // Top gradient scrim for badge readability
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 64,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.60),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Badge — top-left corner
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.68),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            widget.badgeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Bottom row: title  +  action pill ────────────
                  ColoredBox(
                    color: const Color(0xFF1A1A1A),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 11),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                widget.buttonLabel,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
