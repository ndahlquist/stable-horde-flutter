import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// A colored glassmorphic background with subtle animation.
class GlassmorphicBackground extends StatefulWidget {
  const GlassmorphicBackground({super.key});

  @override
  State<GlassmorphicBackground> createState() => _GlassmorphicBackgroundState();
}

class _GlassmorphicBackgroundState extends State<GlassmorphicBackground> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF620000),
                  Color(0xFF003485),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100 + sin(_timer.tick / 100.0) * 50,
            right: 100 + sin(_timer.tick / 121.0) * 50,
            child: _circle(const Color(0xFF812B00), 400),
          ),
          Positioned(
            top: 100 + sin(_timer.tick / 205.0) * 50,
            left: 100 + sin(_timer.tick / 225.0) * 50,
            child: _circle(const Color(0xFF812B00), 200),
          ),
          Positioned(
            top: 100 + sin(_timer.tick / 198.0) * 50,
            left: 100 + sin(_timer.tick / 211.0) * 50,
            child: _circle(const Color(0xFF240050), 800),
          ),
        ],
      ),
    );
  }

  Widget _circle(Color color, double radius) {
    return SizedBox(
      width: radius,
      height: radius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          gradient: RadialGradient(
            // This is roughly a gaussian kernel.
            // (The goal here is to approximate a Gaussian blur,
            // but without actually performing an expensive blur).
            colors: [
              color.withOpacity(0.199 * 5),
              color.withOpacity(0.175 * 5),
              color.withOpacity(0.122 * 5),
              color.withOpacity(0.066 * 5),
              color.withOpacity(0.028 * 5),
              color.withOpacity(0.00),
            ],
            stops: const [
              0.0,
              .2,
              .4,
              .6,
              .8,
              1.0,
            ],
          ),
        ),
      ),
    );
  }
}
