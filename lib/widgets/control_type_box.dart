import 'package:flutter/material.dart';

class ControlTypeBox extends StatefulWidget {
  const ControlTypeBox({super.key});

  @override
  State<ControlTypeBox> createState() => _ControlTypeBoxState();
}

class _ControlTypeBoxState extends State<ControlTypeBox> {
  static const List<String> _controlTypes = <String>[
    "canny",
    "hed",
    "depth",
    "normal",
    "openpose",
    "seg",
    "scribble",
    "fakescribbles",
    "hough"
  ];

  String _controlType = 'normal'; // TODO

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        top: 16,
        bottom: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Control type'),
                SizedBox(height: 4),
                Text(
                  'ControlNet helps keep the output composition similar to the input image.',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.white,
              inactiveTickMarkColor: Colors.black.withOpacity(.1),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.black.withOpacity(.2),
            ),
            child: DropdownButton<String>(
              value: _controlType,
              elevation: 16,
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  _controlType = value!;
                });
              },
              items:
                  _controlTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
