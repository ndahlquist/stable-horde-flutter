import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';

class LoginDialog extends StatelessWidget {
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
              await sharedPrefsBloc.setApiKey(value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Validate'),
        ),
      ],
    );
  }
}
