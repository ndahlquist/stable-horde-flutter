import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingDiffusionAnimation extends StatelessWidget {
  const OnboardingDiffusionAnimation({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 3,
              ),
              const Text(
                '"A Renaissance painting of a robotic cat. Highly detailed."',
                style: TextStyle(fontSize: 24),
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
    );
  }
}
