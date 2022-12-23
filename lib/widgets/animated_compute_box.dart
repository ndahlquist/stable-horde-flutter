
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedComputeBox extends StatelessWidget {
  const AnimatedComputeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.red],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: SvgPicture.asset(
        'assets/vector_drawables/box.svg',
        width: 64,
        height: 64,
      ),
    );
  }
  
}