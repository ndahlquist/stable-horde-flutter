import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
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
    if (widget.task.estimatedCompletionTime == null) {
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
    if (widget.task.estimatedCompletionTime == null) {
      loadingMessageWidget = const Text('Loading...');
    } else {
      final difference = widget.task.estimatedCompletionTime!.difference(
        DateTime.now(),
      );

      loadingMessageWidget = Text('ETA: ${difference.inSeconds}s');
    }

    final Widget callToAction;
    if (sharedPrefsBloc.getApiKey() == null) {
      callToAction = RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(
          text: 'You are currently anonymous.\n',
          style: DefaultTextStyle.of(context).style,
          children: const <TextSpan>[
            TextSpan(text: 'For faster image generations, '),
            TextSpan(
              text: 'create an account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '.'),
          ],
        ),
      );
    } else {
      callToAction = RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(
          text:
              'Stable Horde is a volunteer project! For faster image generations, consider ',
          style: DefaultTextStyle.of(context).style,
          children: const <TextSpan>[
            TextSpan(
              text: 'running a worker',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' or '),
            TextSpan(
              text: 'contributing to our Patreon',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '.',
            ),
          ],
        ),
      );
    }

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
