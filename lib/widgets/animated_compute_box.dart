import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedComputeBox extends StatefulWidget {
  const AnimatedComputeBox({super.key});

  @override
  State<AnimatedComputeBox> createState() => _AnimatedComputeBoxState();
}

class _AnimatedComputeBoxState extends State<AnimatedComputeBox> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 1), (t) {
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
    var animationProgress = _timer.tick % 1000 / 1000;
    animationProgress = animationProgress * 3 - 1;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.white,
            Colors.lightBlue,
            Colors.white,
          ],
          stops: [
            animationProgress + .2,
            animationProgress + .5,
            animationProgress + .8,
          ],
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
