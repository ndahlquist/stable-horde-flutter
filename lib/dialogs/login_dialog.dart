import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_user_bloc.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  bool _validating = false;
  String _apiKey = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              launchUrlInExternalApp('https://stablehorde.net/register');
            },
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text:
                    'Enter your Stable Horde API key to login. You can get one at\n',
                style: DefaultTextStyle.of(context).style,
                children: const <TextSpan>[
                  TextSpan(
                      text: 'https://stablehorde.net/register',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'API Key',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) async {
              _apiKey = value;
            },
          ),
        ],
      ),
      actions: [
        if (_validating)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (!_validating)
          TextButton(
            onPressed: () async {
              setState(() {
                _validating = true;
              });

              try {
                final user = await stableHordeUserBloc.lookupUser(_apiKey);

                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid API key'),
                    ),
                  );
                } else {
                  await sharedPrefsBloc.setApiKey(_apiKey);
                  Navigator.of(context).pop();
                }
              } finally {
                setState(() {
                  _validating = false;
                });
              }
            },
            child: const Text('Validate'),
          ),
      ],
    );
  }
}
