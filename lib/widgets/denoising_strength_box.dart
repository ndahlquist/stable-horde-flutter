import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';

class DenoisingStrengthBox extends StatefulWidget {
  const DenoisingStrengthBox({super.key});

  @override
  State<DenoisingStrengthBox> createState() => _DenoisingStrengthBoxState();
}

class _DenoisingStrengthBoxState extends State<DenoisingStrengthBox> {
  double _denoisingStrength = .4;

  @override
  void initState() {
    _updateDenoisingStrength();
    super.initState();
  }

  void _updateDenoisingStrength() async {
    double? denoisingStrength = await sharedPrefsBloc.getDenoisingStrength();
    if (!mounted) return;
    setState(() {
      _denoisingStrength = denoisingStrength;
    });
  }

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
                Text('Denoising strength'),
                SizedBox(height: 4),
                Text(
                  'Smaller values make the result similar to the input image. Larger values create more variation.',
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
              value: _denoisingStrength,
              min: .2,
              max: 1,
              divisions: 8,
              label: "${(_denoisingStrength * 100).toInt()}%",
              onChanged: (double value) async {
                await sharedPrefsBloc.setDenoisingStrength(value);
                setState(() {
                  _denoisingStrength = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
