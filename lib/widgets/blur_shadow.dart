import 'dart:ui';

import 'package:flutter/material.dart';

class BlurShadow extends StatelessWidget {
  final Widget child;
  final double opacity;

  const BlurShadow({
    super.key,
    required this.child,
    this.opacity = .7,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: const Offset(
              0,
              5,
            ),
            child: Transform.scale(
              scale: .9,
              alignment: Alignment.bottomCenter,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                  tileMode: TileMode.decal,
                ),
                child: _darken(
                  child: child,
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }

  // Applying a slight dark shade to the shadows gives some contrast
  //  for the case that the foreground is very bright.
  Widget _darken({required Widget child}) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.grey[300]!,
        BlendMode.modulate,
      ),
      child: child,
    );
  }
}
