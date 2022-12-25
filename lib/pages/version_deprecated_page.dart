import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';

class VersionDeprecatedPage extends StatefulWidget {
  const VersionDeprecatedPage({super.key});

  @override
  State<VersionDeprecatedPage> createState() => _DeprecatedPageState();
}

class _DeprecatedPageState extends State<VersionDeprecatedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GlassmorphicBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
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
        ),
      ],
    );
  }
}
