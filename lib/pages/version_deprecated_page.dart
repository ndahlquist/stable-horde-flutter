import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/colors.dart';

class VersionDeprecatedPage extends StatefulWidget {
  const VersionDeprecatedPage({super.key});

  @override
  State<VersionDeprecatedPage> createState() => _DeprecatedPageState();
}

class _DeprecatedPageState extends State<VersionDeprecatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: stableHordePurple,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  stableHordePurple.withOpacity(.8),
                  stableHordePurple,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const [
                Spacer(),
                Text(
                  'This version of Stable Horde is no longer supported.\n\nPlease update to the latest version.',
                  style: TextStyle(fontSize: 18),
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
