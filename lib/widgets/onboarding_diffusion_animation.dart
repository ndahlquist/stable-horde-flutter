import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingDiffusionAnimation extends StatefulWidget {
  const OnboardingDiffusionAnimation({super.key});

  static const Map<String, String> _prompts = {
    'A Renaissance portrait of a cat wearing glasses. Highly detailed.': 'assets/images/cat.jpg',
    'iOS icon app. Nature. Highly detailed, trending on artstation, IconsMi': 'assets/images/ios_icon.jpg',
    'knollingcase, isometric render, a Greek underwater city with volcano, isometric display case, knolling teardown, transparent data visualization infographic': 'assets/images/knollingcase.jpg',
  };

  @override
  State<OnboardingDiffusionAnimation> createState() => _OnboardingDiffusionAnimationState();
}

class _OnboardingDiffusionAnimationState extends State<OnboardingDiffusionAnimation> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 3,
                ),
                const Text(
                  '"A Renaissance painting of a robotic cat. Highly detailed."',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_downward_rounded,
                  size: 32,
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/vector_drawables/box.svg',
                  width: 64,
                  height: 64,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_downward_rounded,
                  size: 32,
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.55),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 128,
                      width: 128,
                      child: Image.asset(
                        'assets/images/ios_icon.jpg',
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Run setstate() periodically, every millisecond
    Timer.periodic(const Duration(milliseconds: 1), (_) {
      setState(() {});
    });

  }
}
