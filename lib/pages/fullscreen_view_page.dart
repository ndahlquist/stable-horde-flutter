import 'package:flutter/material.dart';

class FullScreenViewPage extends StatelessWidget {
  const FullScreenViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF230D49),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
