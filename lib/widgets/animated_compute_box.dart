import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedComputeBox extends StatefulWidget {
  final num animationOffset;

  const AnimatedComputeBox({super.key, required this.animationOffset});

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
    var animationProgress = (_timer.tick / 2000) + widget.animationOffset;
    animationProgress = animationProgress % 1;
    animationProgress = animationProgress * 3 - 1;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color(0xFFD9D9D9),
            Colors.lightBlue,
            Color(0xFFD9D9D9),
          ],
          stops: [
            animationProgress + .3,
            animationProgress + .5,
            animationProgress + .7,
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
