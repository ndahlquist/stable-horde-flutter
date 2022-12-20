import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/pages/prompt_edit_page.dart';

class DreamTab extends StatefulWidget {
  const DreamTab({super.key});

  @override
  State<DreamTab> createState() => _DreamTabState();
}

class _DreamTabState extends State<DreamTab> {
  String _prompt = "";

  @override
  void initState() {
    super.initState();
    sharedPrefsBloc.getLastPrompt().then((value) {
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
          const SizedBox(height: 16),
          _promptWidget(),
          ElevatedButton(
            onPressed: _attemptToGenerate,
            child: const Text("Generate"),
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
        sharedPrefsBloc.setPrompt(newPrompt);
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
        const SnackBar(
          content: Text("Please enter a prompt first."),
        ),
      );
      return;
    }

    stableHordeBloc.requestDiffusion(_prompt);
    homeController.animateToPage(1);
  }
}
