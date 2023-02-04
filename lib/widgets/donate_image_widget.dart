import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';

class DonateImageWidget extends StatefulWidget {
  const DonateImageWidget({super.key});

  @override
  State<DonateImageWidget> createState() => _DonateImageWidgetState();
}

class _DonateImageWidgetState extends State<DonateImageWidget> {
  late bool _donateImageOptionEnabled;

  @override
  void initState() {
    getDonateImageOption();
    super.initState();
  }

  void getDonateImageOption() async {
    bool isDonateImageOptionEnabled =
        await sharedPrefsBloc.isDonateImageEnabled();
    setState(() {
      _donateImageOptionEnabled = isDonateImageOptionEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Donate generated images'),
      activeTrackColor: Colors.white,
      activeColor: Colors.white,
      value: _donateImageOptionEnabled,
      onChanged: onChangedDonateImageOption,
      subtitle: const Text(
        'Share your prompts and generated images to aid in training future versions of Stable Diffusion.',
      ),
    );
  }

  void onChangedDonateImageOption(bool value) async {
    // Check login state
    var apiKey = await sharedPrefsBloc.getApiKey();
    if (apiKey == null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            'All images from anonymous users are donated. To turn off donation, create a Stable Horde account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    await sharedPrefsBloc.setDonateImageOption(value);

    setState(() {
      _donateImageOptionEnabled = value;
    });
  }
}
