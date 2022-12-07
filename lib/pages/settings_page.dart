import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: zoomscrollerGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: Column(
        children: [
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
