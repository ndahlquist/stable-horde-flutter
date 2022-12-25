import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';

// Page for fullscreen editing of prompt and negative prompts.
class PromptEditPage extends StatefulWidget {
  final String title;
  final String originalPrompt;

  const PromptEditPage(this.title, this.originalPrompt, {super.key});

  @override
  State<PromptEditPage> createState() => _PromptEditPageState();
}

class _PromptEditPageState extends State<PromptEditPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.originalPrompt);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _controller.text.trim());
        return Future.value(false);
      },
      child: Stack(
        children: [
          const GlassmorphicBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(widget.title),
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
                          Navigator.of(context).pop(_controller.text.trim());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
