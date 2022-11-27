import 'package:flutter/material.dart';

class MagicButton extends StatefulWidget {
  static const double magicButtonSize = 72.0;

  final bool inProgress;

  final void Function() onTapped;

  const MagicButton({
    super.key,
    required this.inProgress,
    required this.onTapped,
  });

  @override
  State<MagicButton> createState() => _MagicButtonState();
}

class _MagicButtonState extends State<MagicButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MagicButton.magicButtonSize,
      height: MagicButton.magicButtonSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          child: InkWell(
            onTap: widget.onTapped,
            radius: 12,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF8900B6),
                        const Color(0xFF642604),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: widget.inProgress
                      ? CircularProgressIndicator()
                      : Icon(
                          Icons.auto_fix_high,
                          color: Colors.white.withOpacity(.9),
                          size: 54,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
