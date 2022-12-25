import 'package:flutter/material.dart';

class SectionFrame extends StatelessWidget {
  final Widget child;
  final double padding;

  const SectionFrame({super.key, required this.child, this.padding=12});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
