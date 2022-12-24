import 'dart:ui';

import 'package:flutter/material.dart';

class GlassmorphicBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 100,
        sigmaY: 100,
        tileMode: TileMode.clamp,
      ),
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
            top: 100,
            left: 100,
            child: _circle(const Color(0xFF005F7C), 400),
          ),
          Positioned(
            bottom: 100,
            right: 100,
            child: _circle(const Color(0xFFA63802 ), 200),
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
          color: color,
        ),
      ),
    );
  }
}
