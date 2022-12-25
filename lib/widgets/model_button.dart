import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/pages/model_chooser_page.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';

class ModelButton extends StatefulWidget {
  const ModelButton({super.key});

  @override
  State<ModelButton> createState() => _ModelButtonState();
}

class _ModelButtonState extends State<ModelButton> {
  String currentModel = "stable_diffusion";

  @override
  void initState() {
    super.initState();
    sharedPrefsBloc.getModel().then((model) {
      setState(() {
        currentModel = model;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ModelChooserPage(),
          ),
        );

        sharedPrefsBloc.getModel().then((model) {
          setState(() {
            currentModel = model;
          });
        });
      },
      child: SectionFrame(
        child: Text(
          "Model: $currentModel",
        ),
      ),
    );
  }
}
