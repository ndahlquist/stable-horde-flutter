import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingDiffusionAnimation extends StatefulWidget {
  const OnboardingDiffusionAnimation({super.key});

  @override
  State<OnboardingDiffusionAnimation> createState() =>
      _OnboardingDiffusionAnimationState();
}

class _OnboardingDiffusionAnimationState
    extends State<OnboardingDiffusionAnimation> {
  static const Map<String, String> _prompts = {
    '"A Renaissance portrait of a cat wearing glasses. Highly detailed."':
        'assets/images/cat.jpg',
    '"iOS icon app. Nature. Highly detailed, trending on artstation, IconsMi"':
        'assets/images/ios_icon.jpg',
    '"knollingcase, isometric render, a Greek underwater city with volcano, isometric display case, knolling teardown, transparent data visualization infographic"':
        'assets/images/knollingcase.jpg',
  };

  late Timer _timer;

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 5000), (_) {
      setState(() {
        _index = (_index + 1) % _prompts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 3,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: SizedBox(
                    key: ValueKey(_index),
                    height: 76,
                    child: Center(
                      child: Text(
                        _prompts.keys.elementAt(_index),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: Container(
                    key: ValueKey(_index),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.55),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset:
                              const Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 128,
                        width: 128,
                        child: Image.asset(
                          _prompts.values.elementAt(_index),
                        ),
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
}
