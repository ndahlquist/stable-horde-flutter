import 'package:flutter/material.dart';
import 'package:zoomscroller/colors.dart';
import 'package:zoomscroller/utils/legal_links.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: zoomscrollerGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: Column(
        children: const [
          ListTile(
            title: Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
            onTap: launchPrivacyPolicy,
          ),
          ListTile(
            title: Text(
              'Terms of Service',
              style: TextStyle(color: Colors.white),
            ),
            onTap: launchTermsOfService,
          ),
        ],
      ),
    );
  }
}
