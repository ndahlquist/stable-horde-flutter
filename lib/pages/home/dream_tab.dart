import 'package:flutter/material.dart';
import 'package:zoomscroller/blocs/stable_horde_bloc.dart';
import 'package:zoomscroller/pages/prompt_edit_page.dart';
import 'package:zoomscroller/utils/shared_prefs_helper.dart';

class DreamTab extends StatefulWidget {
  @override
  State<DreamTab> createState() => _DreamTabState();
}

class _DreamTabState extends State<DreamTab> {
  String _prompt = "";

  @override
  void initState() {
    super.initState();
    getLastPrompt().then((value) {
      setState(() {
        _prompt = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          _promptWidget(),
          ElevatedButton(
            onPressed: _attemptToGenerate,
            child: Text("Generate"),
          ),
        ],
      ),
    );
  }

  Widget _promptWidget() {
    String promptToShow = _prompt.trim();
    if (promptToShow.isEmpty) {
      promptToShow = "Tap here to describe what we're painting today.";
    }

    return GestureDetector(
      onTap: () async {
        final newPrompt = await Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder: (_) => PromptEditPage(initialText: _prompt),
          ),
        );
        if (newPrompt == null) return;
        setPrompt(newPrompt);
        setState(() {
          _prompt = newPrompt;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                promptToShow,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _prompt.isEmpty ? 16 : 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _attemptToGenerate() async {
    if (_prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a prompt first."),
        ),
      );
      return;
    }

    stableHordeBloc.requestDiffusion(_prompt, .8);
  }
}
