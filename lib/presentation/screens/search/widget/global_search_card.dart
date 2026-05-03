import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class GlobalSearchCard extends StatelessWidget {
  final String title;
  final String image;
  final String type;
  final VoidCallback onTap;

  const GlobalSearchCard({
    super.key,
    required this.title,
    required this.image,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isProfile = type.toLowerCase() == "profile" || 
                     type.toLowerCase() == "creator" || 
                     type.toLowerCase() == "user";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1F2026),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: isProfile
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CustomNetworkImage(
                          imageUrl: image,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    )
                  : CustomNetworkImage(
                      imageUrl: image,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),

            // Gradient Overlay for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),

            // Type Badge
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isProfile 
                      ? [Colors.blueAccent, Colors.cyan] 
                      : [Colors.orangeAccent, Colors.redAccent],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (isProfile ? Colors.blueAccent : Colors.redAccent).withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  isProfile ? "Profile" : "Podcast",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Bottom Info with Glassmorphism
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: CustomText(
                      text: title,
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
