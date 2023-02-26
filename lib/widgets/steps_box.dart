import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';

class StepsBox extends StatefulWidget {
  const StepsBox({super.key});

  @override
  State<StepsBox> createState() => _StepsBoxState();
}

class _StepsBoxState extends State<StepsBox> {
  int _steps = 30;

  @override
  void initState() {
    _updateSteps();
    super.initState();
  }

  void _updateSteps() async {
    int steps = await sharedPrefsBloc.getSteps();
    if (!mounted) return;
    setState(() {
      _steps = steps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Steps'),
                SizedBox(height: 4),
                Text(
                  'Higher step count means more detail, but kudos cost will increase too. Default value is 30.',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.white,
              inactiveTickMarkColor: Colors.black.withOpacity(.1),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.black.withOpacity(.2),
            ),
            child: Slider(
              value: _steps.toDouble(),
              min: 5,
              max: 100,
              divisions: 19,
              label: "$_steps",
              onChanged: (double value) async {
                await sharedPrefsBloc.setSteps(value.toInt());
                setState(() {
                  _steps = value.toInt();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
