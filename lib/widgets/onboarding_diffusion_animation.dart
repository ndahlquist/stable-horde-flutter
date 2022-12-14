import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/widgets/animated_compute_box.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';

class OnboardingDiffusionAnimation extends StatefulWidget {
  final bool showHorde;

  const OnboardingDiffusionAnimation({super.key, required this.showHorde});

  @override
  State<OnboardingDiffusionAnimation> createState() =>
      _OnboardingDiffusionAnimationState();
}

class _OnboardingDiffusionAnimationState
    extends State<OnboardingDiffusionAnimation> {
  static const Map<String, String> _prompts = {
    '"A Renaissance portrait of a cat wearing glasses. Highly detailed."':
        'assets/images/cat.jpg',
    '"iOS icon app. Nature. Highly detailed, trending on artstation"':
        'assets/images/ios_icon.jpg',
    '"A Greek underwater city with volcano, isometric display case, data visualization"':
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
    return FractionallySizedBox(
      widthFactor: 1,
      child: SectionFrame(
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
              child: Text(
                key: ValueKey(_index),
                '${_prompts.keys.elementAt(_index)}\n\n',
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_downward_rounded,
              size: 32,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < (widget.showHorde ? 4 : 1); i++)
                  AnimatedComputeBox(animationOffset: 1 - i / 4),
              ],
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
    );
  }
}
