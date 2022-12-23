import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/colors.dart';

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
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _pageOne(),
                  _buildPage(
                    'Feedback Needed',
                    'Stable Diffusion is software that generates images from text-- almost like magic!',
                  ),
                  _buildPage(
                    'Sharing is Cool',
                    "Please be encouraged to share your creations and the app (no need for secrecy).\n\nThanks for testing!",
                  ),
                ],
              ),
            ),

            // A button to skip the onboarding.
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_onFirstPage()) {
                        _pageController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
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

  Widget _buildPage(String title, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Text(
            title,
            style: TextStyle(fontSize: 32),
          ),
          SizedBox(height: 16),*/
          Text(
            body,
          ),
        ],
      ),
    );
  }

  Widget _pageOne() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
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
                TextSpan(text: '-- almost like magic!'),
              ],
            ),
          ),

          Spacer(),

          Text('On a PC with a powerful GPU, each image takes a few seconds to generate.'),
        ],
      ),
    );
  }
}
