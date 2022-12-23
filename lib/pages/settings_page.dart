import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_user_bloc.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';
import 'package:stable_horde_flutter/widgets/user_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: stableHordeGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserWidget(),
            _apiKeyField(),
            const Padding(
              padding: EdgeInsets.only(
                top: 64.0,
                left: 16.0,
                bottom: 16,
              ),
              child: Text(
                'Legal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const ListTile(
              title: Text('Privacy Policy'),
              onTap: launchPrivacyPolicy,
            ),
            const ListTile(
              title: Text('Terms of Service'),
              onTap: launchTermsOfService,
            ),
          ],
        ),
      ),
    );
  }

  Widget _apiKeyField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FutureBuilder<String?>(
        future: sharedPrefsBloc.getApiKey(),
        builder: (context, snapshot) {
          final apiKey = snapshot.data ?? '';

          return TextField(
            controller: TextEditingController(text: apiKey),
            decoration: const InputDecoration(
              labelText: 'API Key',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              sharedPrefsBloc.setApiKey(value);
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    sharedPrefsBloc.getApiKey().then((value) {
      if (value != null) {
        stableHordeUserBloc.lookupUser(value).then((value) => print);
      }
    });
  }
}
