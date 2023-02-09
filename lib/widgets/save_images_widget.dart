import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';

class SaveImagesWidget extends StatefulWidget {
  const SaveImagesWidget({super.key});

  @override
  State<SaveImagesWidget> createState() => _SaveImagesWidgetState();
}

class _SaveImagesWidgetState extends State<SaveImagesWidget> {
  bool _saveEnabled = false;

  @override
  void initState() {
    super.initState();

    sharedPrefsBloc.getSaveImageEnabled().then((value) {
      setState(() {
        _saveEnabled = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String externalDirectory;
    if (Platform.isAndroid) {
      externalDirectory = "Pictures";
    } else {
      externalDirectory = "Application Support";
    }

    return SwitchListTile(
      title: const Text('Save images to device'),
      activeTrackColor: Colors.white,
      activeColor: Colors.white,
      value: _saveEnabled,
      onChanged: _onChanged,
      subtitle: Text(
        'Save a copy of each generated image to your phone\'s $externalDirectory directory.',
      ),
    );
  }

  void _onChanged(bool value) async {
    await sharedPrefsBloc.setSaveImageEnabled(value);

    setState(() {
      _saveEnabled = value;
    });
  }
}
