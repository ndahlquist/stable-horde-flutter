import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/pages/settings_page.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';
import 'package:stable_horde_flutter/widgets/timed_progress_indicator.dart';

class TaskProgressIndicator extends StatefulWidget {
  final StableHordeTask task;
  final bool showText;

  const TaskProgressIndicator(this.task, {super.key, required this.showText});

  @override
  State<TaskProgressIndicator> createState() => _TaskProgressIndicatorState();
}

class _TaskProgressIndicatorState extends State<TaskProgressIndicator> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Set state every second to update the progress indicator.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
      if (widget.task.isComplete()) {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Once the task is complete, hide the progress indicator.
    if (widget.task.isComplete()) {
      return const SizedBox.shrink();
    }

    final Widget progressIndicator;
    if (widget.task.failed) {
      progressIndicator = const Center(
        child: Icon(
          Icons.error,
          size: 48,
        ),
      );
    } else if (widget.task.estimatedCompletionTime == null) {
      progressIndicator = const Center(child: CircularProgressIndicator());
    } else {
      progressIndicator = Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: TimedProgressIndicator(
            key: ValueKey(widget.task.estimatedCompletionTime),
            startTime: widget.task.firstShowProgressIndicatorTime!,
            completionTime: widget.task.estimatedCompletionTime!,
          ),
        ),
      );
    }

    if (!widget.showText) {
      return progressIndicator;
    }

    Widget loadingMessageWidget;
    if (widget.task.failed) {
      loadingMessageWidget = const Text('Error generating image.');
    }else if (widget.task.estimatedCompletionTime == null) {
      loadingMessageWidget = const Text('Loading...');
    } else {
      final difference = widget.task.estimatedCompletionTime!.difference(
        DateTime.now(),
      );
      var secondsLeft = difference.inSeconds;
      if (secondsLeft < 0) secondsLeft = 0;
      loadingMessageWidget = Text('ETA: ${secondsLeft}s');
    }

    final Widget callToAction = FutureBuilder<String?>(
      future: sharedPrefsBloc.getApiKey(),
      builder: (context, snapshot) {
        final apiKey = snapshot.data;

        if (widget.task.failed) return const SizedBox.shrink();

        if (apiKey == null) {
          return RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: 'You are currently anonymous.\n',
              style: DefaultTextStyle.of(context).style,
              children: [
                const TextSpan(text: 'For faster image generations, '),
                TextSpan(
                  text: 'create an account',
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "SettingsPage"),
                          builder: (c) => const SettingsPage(),
                        ),
                      );
                    },
                ),
                const TextSpan(text: '.'),
              ],
            ),
          );
        } else {
          return RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text:
                  'Stable Horde is a volunteer project! For faster image generations, consider ',
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: 'running a worker',
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlInExternalApp(
                        'https://github.com/db0/AI-Horde/blob/main/README_StableHorde.md#joining-the-horde',
                      );
                    },
                ),
                const TextSpan(text: ' or '),
                TextSpan(
                  text: 'supporting us on Patreon',
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlInExternalApp(
                        'https://www.patreon.com/db0',
                      );
                    },
                ),
                const TextSpan(
                  text: '.',
                ),
              ],
            ),
          );
        }
      },
    );

    return Stack(
      children: [
        progressIndicator,
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              loadingMessageWidget,
              const SizedBox(height: 8),
              callToAction,
            ],
          ),
        ),
      ],
    );
  }
}
