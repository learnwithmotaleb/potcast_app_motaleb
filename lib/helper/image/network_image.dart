import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final IconData? errorIcon;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.errorIcon,
    this.boxShape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final String finalUrl = imageUrl ?? "";

    if (imageUrl == null || (imageUrl?.isEmpty ?? true)) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          color: Colors.grey.withValues(alpha: 0.6),
          borderRadius: borderRadius,
          shape: boxShape,
        ),
        child: CachedNetworkImage(
          imageUrl: AppConstants.defaultCoverImage,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: finalUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: backgroundColor,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.withValues(alpha: 0.6),
          highlightColor: Colors.grey.withValues(alpha: 0.3),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              color: Colors.grey.withValues(alpha: 0.6),
              borderRadius: borderRadius,
              shape: boxShape,
            ),
          )),
      errorWidget: (context, url, error) => CustomNetworkImage(
        imageUrl: AppConstants.defaultCoverImage,
        height: height,
        width: width,
      ),
    );
  }
}
