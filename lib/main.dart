import 'dart:async';

import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shake/shake.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/colors.dart';
import 'package:zoomscroller/firebase_options.dart';
import 'package:zoomscroller/pages/auth_page.dart';
import 'package:zoomscroller/pages/version_deprecated_page.dart';
import 'package:zoomscroller/pages/world_chooser_page.dart';

Future main() async {
  Future errorHandler(Object error, StackTrace stackTrace) async {
    print(error);
    print(stackTrace);

    if (!kDebugMode) {
      Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  runZonedGuarded(
    _mainGuarded,
    errorHandler,
  );
}

Future _mainGuarded() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults(const {
    "allow_this_version": true,
    "num_tasks_to_queue": 2,
    "waitlist_enabled": false,
  });

  final app = BetterFeedback(child: MyApp());

  if (kDebugMode) {
    runApp(app);
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://3c3a6add932f4b028a0f2f797e4508b0@o4504142397177856.ingest.sentry.io/4504142399012864';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp(app),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    userBloc.refreshFcmToken();
    ShakeDetector.autoStart(
      minimumShakeCount: 2,
      onPhoneShake: () async {
        final username = await userBloc.getMyUsername();

        BetterFeedback.of(context).showAndUploadToSentry(
          name: username,
          email: FirebaseAuth.instance.currentUser?.email,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget initialPage;

    final currentUser = FirebaseAuth.instance.currentUser;
    final loggedIn = currentUser != null && !currentUser.isAnonymous;
    if (loggedIn) {
      initialPage = FutureBuilder<bool>(
        future: userBloc.isApprovedForBeta(),
        builder: (c, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: zoomscrollerPurple,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final approved = snapshot.data!;

          if (approved) {
            return WorldChooserPage();
          } else {
            return AuthPage();
          }
        },
      );
    } else {
      initialPage = AuthPage();
    }

    return MaterialApp(
      title: 'ZoomScroller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ubuntuTextTheme(),
      ),
      home: FutureBuilder(
        future: FirebaseRemoteConfig.instance.fetchAndActivate(),
        builder: (context, snapshot) {
          final config = FirebaseRemoteConfig.instance;
          final versionDeprecated = !config.getBool("allow_this_version");
          if (versionDeprecated) {
            return VersionDeprecatedPage();
          }

          return initialPage;
        },
      ),
    );
  }
}
