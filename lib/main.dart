import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zoomscroller/firebase_options.dart';
import 'package:zoomscroller/pages/home_page.dart';
import 'package:zoomscroller/pages/version_deprecated_page.dart';

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
  });

  if (kDebugMode) {
    runApp(MyApp());
  } else {
    // todo / Stopship
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://3c3a6add932f4b028a0f2f797e4508b0@o4504142397177856.ingest.sentry.io/4504142399012864';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
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

          return HomePage();
        },
      ),
    );
  }
}
