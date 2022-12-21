import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          children: [
            _apiKeyField(),
            const Padding(
              padding: EdgeInsets.only(
                top: 64.0,
                left: 16.0,
                bottom: 16,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Legal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
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
}
