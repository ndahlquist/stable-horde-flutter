import 'package:flutter/material.dart';

class PromptEditPage extends StatefulWidget {
  final String initialText;

  const PromptEditPage({super.key, required this.initialText});

  @override
  State<PromptEditPage> createState() => _PromptEditPageState();
}

class _PromptEditPageState extends State<PromptEditPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_textController.text.isNotEmpty) {
          Navigator.of(context).pop(_textController.text);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF230D49),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            maxLines: 10,
            controller: _textController,
            style: TextStyle(color: Colors.white),
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'What would you like to paint today?',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.multiline,
          ),
        ),
      ),
    );
  }
}
