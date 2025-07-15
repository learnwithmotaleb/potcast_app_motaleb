import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_images/app_images.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  ui.Image? _customImage;

  @override
  void initState() {
    super.initState();
    _loadImage(AppImages.rectangle);
  }

  Future<void> _loadImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(context).load(assetPath);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    setState(() {
      _customImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (height / 2) + 100,
                width: width,
                child: Assets.images.startedLogo.image(fit: BoxFit.cover),
              ),
              if (_customImage != null)
                Stack(
                  children: [
                    CustomPaint(
                      size: Size(width, (height / 2) - 100),
                      painter: RectanglePainter(image: _customImage!),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "get_started_intro".tr,
                              fontSize: 20,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w800,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            Gap(22.h),
                            CustomButton(
                              text: "get_started".tr,
                              onTap: () => AppRouter.route.goNamed(RoutePath.loginScreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final ui.Image image;

  RectanglePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      0,
      size.height,
    );
    path.close();

    canvas.drawPath(path, paint);
    canvas.clipPath(path);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
