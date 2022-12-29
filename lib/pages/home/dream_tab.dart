import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/tasks_bloc.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/pages/prompt_edit_page.dart';
import 'package:stable_horde_flutter/pages/seed_edit_page.dart';
import 'package:stable_horde_flutter/widgets/model_button.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';

class DreamTab extends StatefulWidget {
  const DreamTab({super.key});

  @override
  State<DreamTab> createState() => _DreamTabState();
}

class _DreamTabState extends State<DreamTab> {
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
        const SizedBox(height: 8),
        const ModelButton(),
        const SizedBox(height: 8),
        _seedWidget(),
        const SizedBox(height: 8),
        _upresWidget(),
        const SizedBox(height: 8),
        _fixFaceWidget(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _promptWidget() {
    return FutureBuilder<String>(
      future: sharedPrefsBloc.getPrompt(),
      builder: (context, snapshot) {
        final prompt = snapshot.data ?? "";

        return FractionallySizedBox(
          widthFactor: 1,
          child: GestureDetector(
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
            child: SectionFrame(
              child: Text(
                '"$prompt"',
                style: const TextStyle(fontStyle: FontStyle.italic),
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

        return FractionallySizedBox(
          widthFactor: 1,
          child: GestureDetector(
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
            child: SectionFrame(
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

        return FractionallySizedBox(
          widthFactor: 1,
          child: GestureDetector(
            onTap: () async {
              final int? newSeed = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SeedEditPage(seed),
                ),
              );

              await sharedPrefsBloc.setSeed(newSeed);

              // Rebuild to update the prompt.
              setState(() {});
            },
            child: SectionFrame(
              child: Text(
                "Seed: ${seed ?? "random"}",
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _upresWidget() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: SectionFrame(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Upscale (RealESRGAN_x4plus)"),
                  SizedBox(height: 4),
                  Text(
                    "A post-processor to upscale your image by a factor of 4.",
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "This increases processing time and kudos cost; it's best to experiment with this off, and then activate this only for your final image.",
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            FutureBuilder<bool>(
              future: sharedPrefsBloc.getUpscaleEnabled(),
              builder: (context, snapshot) {
                return Switch.adaptive(
                  value: snapshot.data ?? false,
                  onChanged: (v) async {
                    await sharedPrefsBloc.setUpscaleEnabled(v);
                    setState(() {});
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fixFaceWidget() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: SectionFrame(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Fix faces (CodeFormers)"),
                  SizedBox(height: 4),
                  Text(
                    "A post-processor to fix deformed faces.",
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "This increases processing time and kudos cost; it's best to experiment with this off, and then activate this only for your final image.",
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            FutureBuilder<bool>(
              future: sharedPrefsBloc.getCodeformersEnabled(),
              builder: (context, snapshot) {
                return Switch.adaptive(
                  value: snapshot.data ?? false,
                  onChanged: (v) async {
                    await sharedPrefsBloc.setCodeformersEnabled(v);
                    setState(() {});
                  },
                );
              },
            ),
          ],
        ),
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

    tasksBloc.requestDiffusion().onError((error, stackTrace)  {
      print(error);
      print(stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
    });
    homeController.animateToPage(1);
  }
}
