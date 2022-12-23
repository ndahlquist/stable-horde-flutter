
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingDiffusionAnimation extends StatelessWidget {
  const OnboardingDiffusionAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          SvgPicture.asset(
            'assets/vector_drawables/box.svg',
            width: 64, height: 64,
          ),
          Spacer(),
        ],
      ),
    );
  }

}
