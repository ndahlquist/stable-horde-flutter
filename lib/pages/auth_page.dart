import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zoomscroller/blocs/auth_bloc.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/colors.dart';
import 'package:zoomscroller/pages/beta_onboarding_page.dart';
import 'package:zoomscroller/pages/join_waitlist_page.dart';
import 'package:zoomscroller/pages/tutorial_page.dart';
import 'package:zoomscroller/pages/username_page.dart';
import 'package:zoomscroller/pages/world_chooser_page.dart';
import 'package:zoomscroller/utils/legal_links.dart';
import 'package:zoomscroller/widgets/background_image_grid.dart';

import 'package:google_fonts/google_fonts.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF230D49),
      body: Stack(
        children: [
          BackgroundImageGrid(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  zoomscrollerPurple,
                  zoomscrollerPurple.withOpacity(.5),
                  zoomscrollerPurple,
                ],
                stops: [.1, .6, .8],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 136),
                Center(
                  child: Text(
                    "ZoomScroller Beta",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    "( zoom / enhance )",
                    style: GoogleFonts.nunitoSans().copyWith(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 22,
                      fontWeight: FontWeight.w100,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(flex: 3),
                _legalDisclaimer(),
                SizedBox(height: 16),
                if (Platform.isIOS)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: zoomscrollerGrey,
                    ),
                    onPressed: () async {
                      final success = await authBloc.signInWithApple();
                      if (success) await _continueLogin();
                    },
                    child: Text("Continue with Apple"),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: zoomscrollerGrey,
                  ),
                  onPressed: () async {
                    final success = await authBloc.signInWithGoogle();

                    if (!mounted) return;

                    if (success) await _continueLogin();
                  },
                  child: Text("Continue with Google"),
                ),
                SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legalDisclaimer() {
    final textStyle = TextStyle(
      fontSize: 12,
      color: Colors.white.withOpacity(.6),
      height: 1.6,
    );

    final linkStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle,
        children: [
          const TextSpan(
            text: "By using our app, you agree to our ",
          ),
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = launchTermsOfService,
          ),
          const TextSpan(text: ' and acknowledge our '),
          TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = launchPrivacyPolicy,
          ),
          const TextSpan(
            text: ".",
          ),
        ],
      ),
    );
  }

  Future _continueLogin() async {
    userBloc.refreshFcmToken();

    final approvedForBeta = await userBloc.isApprovedForBeta();
    if (!approvedForBeta) {
      try {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => JoinWaitlistPage(),
            settings: RouteSettings(name: "/join-waitlist"),
          ),
        );
      } finally {
        await authBloc.signOut();
      }
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (c) => HomePage(),
      ),
      (r) => false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TutorialPage(),
      ),
    );

    // Have the user set a username, if not yet set.
    final username = await userBloc.getMyUsername();
    if (username == null) {
      final user = FirebaseAuth.instance.currentUser;
      var initialName = user?.displayName ?? "";
      initialName = initialName.replaceAll(" ", "");

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UsernamePage(initialName),
        ),
      );
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BetaOnboardingPage(),
      ),
    );
  }
}
