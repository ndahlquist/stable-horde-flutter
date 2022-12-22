import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/firebase_options.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/pages/version_deprecated_page.dart';

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

late Isar isar;

Future _mainGuarded() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults(const {
    "allow_this_version": true,
  });

  isar = await Isar.open([StableHordeTaskSchema]);

  if (kDebugMode) {
    runApp(const MyApp());
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://6c44c0429f4840c98b244da69daedee6@o4504142397177856.ingest.sentry.io/4504362837082112';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp(const MyApp()),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    stableHordeBloc.resumeIncompleteTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stable Horde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ubuntuTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      home: FutureBuilder(
        future: FirebaseRemoteConfig.instance.fetchAndActivate(),
        builder: (context, snapshot) {
          final config = FirebaseRemoteConfig.instance;
          final versionDeprecated = !config.getBool("allow_this_version");
          if (versionDeprecated) {
            return const VersionDeprecatedPage();
          }

          return const HomePage();
        },
      ),
    );
  }
}
