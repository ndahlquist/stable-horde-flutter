import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';
import 'package:stable_horde_flutter/widgets/user_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: stableHordeGrey,
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
    );
  }
}
