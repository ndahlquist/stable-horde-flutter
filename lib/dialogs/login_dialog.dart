
import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';

class LoginDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('API Key'),
      content: TextField(
        onChanged: (value) async {
          await sharedPrefsBloc.setApiKey(value);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }

}