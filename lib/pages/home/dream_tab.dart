import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';

class DreamTab extends StatefulWidget {
  const DreamTab({super.key});

  @override
  State<DreamTab> createState() => _DreamTabState();
}

class _DreamTabState extends State<DreamTab> {
  String _prompt = "";

  final _negativePromptController = TextEditingController();

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _promptWidget(),
            const SizedBox(height: 16),
            ExpandablePanel(
              header: Text(
                "Advanced Options",
                style: TextStyle(fontSize: 24),
              ),
              collapsed: SizedBox.shrink(),
              expanded: _advancedOptions(),
              theme: const ExpandableThemeData(
                iconColor: Colors.white,
              ),
            ),
            const SizedBox(height: 64),
            FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                onPressed: _attemptToGenerate,
                child: const Text("Generate"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _advancedOptions() {
    return Column(
      children: [
        TextField(
          controller: _negativePromptController,
          decoration: const InputDecoration(
            labelText: 'Negative Prompt',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            //sharedPrefsBloc.setApiKey(value);
          },
        ),
      ],
    );
  }

  Widget _promptWidget() {

    return TextField(
      controller: TextEditingController(text: _prompt),
      decoration: const InputDecoration(
        labelText: 'Prompt',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (prompt) {
        sharedPrefsBloc.setPrompt(prompt);
      },
    );
  }

  Future _attemptToGenerate() async {
    if (_prompt.trim().isEmpty) {
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
