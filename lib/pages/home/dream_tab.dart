import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/pages/prompt_edit_page.dart';
import 'package:stable_horde_flutter/widgets/model_button.dart';

class DreamTab extends StatefulWidget {
  const DreamTab({super.key});

  @override
  State<DreamTab> createState() => _DreamTabState();
}

class _DreamTabState extends State<DreamTab> {
  @override
  void initState() {
    super.initState();

    // Run this proactively to avoid loading on the model page.
    stableHordeBloc.getModels();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            const SizedBox(height: 16),
            _promptWidget(),
            const SizedBox(height: 36),
            ExpandablePanel(
              header: const Text(
                "Advanced Options",
                style: TextStyle(fontSize: 18),
              ),
              collapsed: const SizedBox.shrink(),
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
                child: const Text(
                  "Generate",
                  style: TextStyle(color: Colors.black87),
                ),
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
        FutureBuilder<String>(
          future: sharedPrefsBloc.getNegativePrompt(),
          builder: (context, snapshot) {
            final negativePrompt = snapshot.data ?? "";

            return TextField(
              controller: TextEditingController(text: negativePrompt),
              decoration: _inputDecoration('Negative Prompt'),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (negativePrompt) {
                sharedPrefsBloc.setNegativePrompt(negativePrompt);
              },
            );
          },
        ),
        const SizedBox(height: 16),
        const FractionallySizedBox(widthFactor: 1, child: ModelButton()),
      ],
    );
  }

  Widget _promptWidget() {
    return FutureBuilder<String>(
      future: sharedPrefsBloc.getPrompt(),
      builder: (context, snapshot) {
        final prompt = snapshot.data ?? "";

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PromptEditPage(prompt),
              ),
            );

            // Rebuild to update the prompt.
            setState(() {});
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '"$prompt"',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  const Icon(Icons.edit_outlined),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  Future _attemptToGenerate() async {
    final prompt = await sharedPrefsBloc.getPrompt();
    if (prompt.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a prompt first."),
        ),
      );
      return;
    }

    stableHordeBloc.requestDiffusion();
    homeController.animateToPage(1);
  }
}
