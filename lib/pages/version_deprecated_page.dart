import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/colors.dart';

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
