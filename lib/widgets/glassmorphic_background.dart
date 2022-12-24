import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

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
    _timer = Timer.periodic( const Duration(milliseconds: 32), (timer) {
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
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 97,
        sigmaY: 97,
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
            top: 100 + sin(_timer.tick / 198.0) * 50,
            left: 100 + sin(_timer.tick / 211.0) * 50,
            child: _circle(const Color(0xFF005F7C), 400),
          ),
          Positioned(
            bottom: 100 + sin(_timer.tick / 100.0) * 50,
            right: 100 + sin(_timer.tick / 121.0) * 50,
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
