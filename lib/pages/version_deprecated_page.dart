import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoomscroller/colors.dart';
import 'package:zoomscroller/utils/legal_links.dart';
import 'package:zoomscroller/widgets/background_image_grid.dart';

class VersionDeprecatedPage extends StatefulWidget {
  @override
  State<VersionDeprecatedPage> createState() => _DeprecatedPageState();
}

class _DeprecatedPageState extends State<VersionDeprecatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: zoomscrollerPurple,
      body: Stack(
        children: [
          BackgroundImageGrid(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  zoomscrollerPurple.withOpacity(.8),
                  zoomscrollerPurple,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Spacer(),
                Text(
                  'This version of ZoomScroller is no longer supported.\n\nPlease update to the latest version.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _upgrade,
                    child: Text(
                      'Update',
                      style: TextStyle(color: zoomscrollerGrey),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _upgrade() {
    if (Platform.isAndroid) {
      launchUrlInExternalApp(
        'https://play.google.com/store/apps/details?id=com.nicd.zoomscroller',
      );
    } else if (Platform.isIOS) {
      launchUrlInExternalApp(
        'https://testflight.apple.com/join/ZTSann4o',
      );
    } else {
      throw Exception('Unsupported platform: ${Platform.operatingSystem}');
    }
  }
}
