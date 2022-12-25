import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';

class PromptEditPage extends StatelessWidget {
  final String prompt;

  const PromptEditPage(this.prompt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GlassmorphicBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Prompt'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(text: prompt),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
