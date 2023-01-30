import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/conversions_bloc.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/tasks_bloc.dart';
import 'package:stable_horde_flutter/firebase_options.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/pages/onboarding_page.dart';
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

  _copyFilesFromOldDirectory();

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
        // This enables better HTTP body debugging and IP tracing.
        options.sendDefaultPii;
      },
      appRunner: () => runApp(const MyApp()),
    );
  }
}

// Before v1.0.1 (Jan 2023), we used getApplicationDocumentsDirectory.
// in v1.0.1, we switched to getApplicationSupportDirectory() instead.
// This function copies any .webps from the old directory to the new directory.
Future _copyFilesFromOldDirectory() async {
  final oldDirectory = await getApplicationDocumentsDirectory();
  final newDirectory = await getApplicationSupportDirectory();

  final files = await oldDirectory.list().toList();
  for (var file in files) {
    if (file.path.endsWith(".webp")) {
      final oldFile = File(file.path);
      final newFile = File("${newDirectory.path}/${file.path.split("/").last}");

      if (newFile.existsSync()) continue;

      await newFile.writeAsBytes(await oldFile.readAsBytes());
    }
  }

  print("Copied files from ${oldDirectory.path} to ${newDirectory.path}");
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

    tasksBloc.resumeIncompleteTasks();
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            textStyle: const TextStyle(
              color: Colors.black87,
            ),
          ),
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

          return FutureBuilder<bool>(
            future: sharedPrefsBloc.hasSeenOnboarding(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final hasSeenOnboarding = snapshot.data!;
              if (hasSeenOnboarding) {
                return const HomePage();
              } else {
                conversionsBloc.tutorialBegin();
                return const OnboardingPage();
              }
            },
          );
        },
      ),
    );
  }
}
