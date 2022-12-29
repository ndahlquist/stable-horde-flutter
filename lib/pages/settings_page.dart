import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/conversions_bloc.dart';
import 'package:stable_horde_flutter/pages/onboarding_page.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';
import 'package:stable_horde_flutter/widgets/user_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GlassmorphicBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Settings'),
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserWidget(),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 64.0,
                    left: 16.0,
                    bottom: 16,
                  ),
                  child: Text(
                    'Learn More',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                ListTile(
                  title: const Text('StableHorde.net'),
                  onTap: () {
                    launchUrlInExternalApp('https://stablehorde.net');
                  },
                ),
                ListTile(
                  title: const Text('FAQ'),
                  onTap: () {
                    launchUrlInExternalApp(
                      'https://github.com/db0/AI-Horde/blob/main/FAQ.md',
                    );
                  },
                ),
                ListTile(
                  title: const Text('Discord'),
                  onTap: () {
                    launchUrlInExternalApp('https://discord.gg/3DxrhksKzn');
                  },
                ),
                ListTile(
                  title: const Text('Restart Tutorial'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "OnboardingPage"),
                        builder: (_) {
                          conversionsBloc.tutorialBegin();
                          return const OnboardingPage();
                        },
                      ),
                      (route) => false,
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 64.0,
                    left: 16.0,
                    bottom: 16,
                  ),
                  child: Text(
                    'Legal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const ListTile(
                  title: Text('Privacy Policy'),
                  onTap: launchPrivacyPolicy,
                ),
                const ListTile(
                  title: Text('Terms of Service'),
                  onTap: launchTermsOfService,
                ),
                ListTile(
                  title: const Text('Third Party Software'),
                  onTap: () {
                    showLicensePage(context: context);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
