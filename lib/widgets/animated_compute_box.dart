
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
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.red],
          stops: [(DateTime.now().millisecondsSinceEpoch % 1000) / 1000, (DateTime.now().millisecondsSinceEpoch % 1000) / 1000 + .5],
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