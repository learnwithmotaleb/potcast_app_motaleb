import 'package:flutter/material.dart';

class CenterOutBufferBar extends StatefulWidget {
  const CenterOutBufferBar({super.key});

  @override
  State<CenterOutBufferBar> createState() => _CenterOutBufferBarState();
}

class _CenterOutBufferBarState extends State<CenterOutBufferBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return FractionallySizedBox(
            widthFactor: _animation.value,
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}