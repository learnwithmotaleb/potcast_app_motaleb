library;

import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppLogoLoader extends StatefulWidget {
  final double size;
  final Color? ringColor;
  final double ringWidth;
  final double logoSize;

  const AppLogoLoader({
    super.key,
    this.size = 140, // আগে 120 ছিল
    this.ringColor,
    this.ringWidth = 3.5,
    this.logoSize = 80, // আগে 64 ছিল
  });

  @override
  State<AppLogoLoader> createState() => _AppLogoLoaderState();
}

class _AppLogoLoaderState extends State<AppLogoLoader>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Ring Rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // Logo Fade In / Out
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _rotationController,
            child: CustomPaint(
              size: Size.square(widget.size),
            ),
          ),

          // Fade In / Fade Out Logo
          FadeTransition(
            opacity: _fadeAnimation,
            child: RepaintBoundary(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: widget.logoSize,
                  height: widget.logoSize,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}