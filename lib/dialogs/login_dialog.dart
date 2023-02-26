import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/conversions_bloc.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_user_bloc.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';

class LoginDialog extends StatefulWidget {
  final String? title;
  const LoginDialog({Key? key, this.title}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _apiKeyController = TextEditingController();
  bool _validating = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title != null ? Text(widget.title ?? "Login") : null,
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
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          TextField(
            controller: _apiKeyController,
            decoration: const InputDecoration(
              labelText: 'API Key',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
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

              final _apiKey = _apiKeyController.text.replaceAll(
                RegExp(r"[^A-Za-z0-9_-]"),
                "",
              );

              try {
                final user = await stableHordeUserBloc.lookupUser(_apiKey);

                if (!mounted) return;

                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid API key'),
                    ),
                  );
                } else {
                  conversionsBloc.completeLogin();
                  await sharedPrefsBloc.setApiKey(_apiKey);
                  Sentry.configureScope((scope) {
                    final sentryUser = SentryUser(username: user.username);
                    scope.setUser(sentryUser);
                  });
                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
              } finally {
                // ignore: control_flow_in_finally
                if (!mounted) return;
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
