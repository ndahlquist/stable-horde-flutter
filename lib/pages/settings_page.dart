import 'package:flutter/material.dart';
import 'package:zoomscroller/blocs/auth_bloc.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/colors.dart';
import 'package:zoomscroller/pages/auth_page.dart';
import 'package:zoomscroller/pages/tutorial_page.dart';
import 'package:zoomscroller/pages/username_page.dart';
import 'package:zoomscroller/utils/legal_links.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: zoomscrollerGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          StreamBuilder<String?>(
            stream: userBloc.getMyUsernameStream(),
            builder: (context, snapshot) {
              return ListTile(
                title: Text(
                  '@${snapshot.data}',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Edit username',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => UsernamePage(snapshot.data ?? ''),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => AuthPage()),
                (_) => false,
              );

              await authBloc.signOut();
            },
          ),
          ListTile(
            title: Text(
              'Tutorial',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => TutorialPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
            onTap: launchPrivacyPolicy,
          ),
          ListTile(
            title: Text(
              'Terms of Service',
              style: TextStyle(color: Colors.white),
            ),
            onTap: launchTermsOfService,
          ),
        ],
      ),
    );
  }
}
