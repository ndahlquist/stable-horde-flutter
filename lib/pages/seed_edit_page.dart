import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';

// Page for editing seed.
class SeedEditPage extends StatefulWidget {
  final int? originalSeed;

  const SeedEditPage(this.originalSeed, {super.key});

  @override
  State<SeedEditPage> createState() => _SeedEditPageState();
}

class _SeedEditPageState extends State<SeedEditPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.originalSeed == null ? "" : widget.originalSeed.toString(),
    );
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
        final seedStr = _controller.text.trim();

        final seed = int.tryParse(seedStr);
        Navigator.pop(context, seed);
        return Future.value(false);
      },
      child: Stack(
        children: [
          const GlassmorphicBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Seed"),
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
                        keyboardType: TextInputType.number,
                        controller: _controller,
                        autofocus: true,
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onEditingComplete: () async {
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
      ),
    );
  }
}
