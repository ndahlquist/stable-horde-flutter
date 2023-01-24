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
    getDenoisingStrength();
    super.initState();
  }

  void getDenoisingStrength() async {
    double? denoisingStrength = await sharedPrefsBloc.getDenoisingStrength();
    setState(() {
      _denoisingStrength = denoisingStrength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 4,
                top: 4,
                bottom: 4,
                right: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Denoising strength '),
                  SizedBox(height: 8),
                ],
              ),
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
              max: 1,
              divisions: 10,
              label: _denoisingStrength.toString(),
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
