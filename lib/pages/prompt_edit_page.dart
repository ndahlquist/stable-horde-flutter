import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';

class PromptEditPage extends StatefulWidget {
  final String prompt;

  const PromptEditPage(this.prompt, {super.key});

  @override
  State<PromptEditPage> createState() => _PromptEditPageState();
}

class _PromptEditPageState extends State<PromptEditPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.prompt);
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onEditingComplete: () async {
                        await sharedPrefsBloc
                            .setPrompt(_controller.text.trim());
                        if (!mounted) return;

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
