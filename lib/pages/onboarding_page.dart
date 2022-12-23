import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/widgets/onboarding_diffusion_animation.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: stableHordePurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Stable Horde"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _pageOne(),
                  _pageTwo(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_onFirstPage()) {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (c) => const HomePage(),
                          ),
                        );
                        sharedPrefsBloc.setHasSeenOnboarding();
                      }
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onFirstPage() => _pageController.page == 0;

  Widget _pageOne() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: const TextSpan(
                text: '',
                children: [
                  TextSpan(
                    text: 'Stable Diffusion',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' is software that '),
                  TextSpan(
                    text: 'generates images from text',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(text: '— almost like magic!'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 400,
              child: OnboardingDiffusionAnimation(showHorde: false),
            ),
            const SizedBox(height: 16),
            const Text(
                'On a PC with a powerful GPU, each image takes a few seconds to generate.'),
            const SizedBox(height: 16),
            const Text("...But what if you don't have a powerful PC?"),
          ],
        ),
      ),
    );
  }

  Widget _pageTwo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: const TextSpan(
                text: 'The ',
                children: [
                  TextSpan(
                    text: 'Stable Horde',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        " is a network of volunteers who pool their computing power. When you request an image, it gets assigned to a volunteer's machine to generate it.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 400,
              child: OnboardingDiffusionAnimation(showHorde: true),
            ),
            const SizedBox(height: 16),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: const TextSpan(
                text: 'Since this is ',
                children: [
                  TextSpan(
                    text: 'free and community-driven',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ", please:"),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Text(" - Be patient while your image is being generated."),
            const SizedBox(height: 4),
            const Text(" - Try not to request more images than you need."),
            const SizedBox(height: 4),
            const Text(
              " - Consider contributing back to the community by running your own worker!",
            ),
          ],
        ),
      ),
    );
  }
}
