
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedComputeBox extends StatelessWidget {
  const AnimatedComputeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/vector_drawables/box.svg',
      width: 64,
      height: 64,
    );
  }
  
}