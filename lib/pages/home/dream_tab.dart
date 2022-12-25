import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/pages/prompt_edit_page.dart';
import 'package:stable_horde_flutter/pages/seed_edit_page.dart';
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
                  "Dream",
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
        _negativePromptWidget(),
        const SizedBox(height: 16),
        _seedWidget(),
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
            final newPrompt = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PromptEditPage("Prompt", prompt),
              ),
            );

            if (newPrompt == null) return;
            await sharedPrefsBloc.setPrompt(newPrompt);

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

  Widget _negativePromptWidget() {
    return FutureBuilder<String>(
      future: sharedPrefsBloc.getNegativePrompt(),
      builder: (context, snapshot) {
        final prompt = snapshot.data ?? "";

        return GestureDetector(
          onTap: () async {
            final newPrompt = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PromptEditPage("Negative Prompt", prompt),
              ),
            );

            if (newPrompt == null) return;
            await sharedPrefsBloc.setNegativePrompt(newPrompt);

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
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Negative Prompt: ",
                          ),
                          TextSpan(
                            text: '"$prompt"',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
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

  Widget _seedWidget() {
    return FutureBuilder<int?>(
      future: sharedPrefsBloc.getSeed(),
      builder: (context, snapshot) {
        final seed = snapshot.data;

        return GestureDetector(
          onTap: () async {
            final int? newSeed = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SeedEditPage(seed
                ),
              ),
            );
            
            await sharedPrefsBloc.setSeed(newSeed);

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
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Seed: ",
                          ),
                          TextSpan(
                            text: seed == null ? "random" : seed.toString(),
                          ),
                        ],
                      ),
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
