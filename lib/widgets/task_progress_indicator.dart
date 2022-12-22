import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/widgets/timed_progress_indicator.dart';

class TaskProgressIndicator extends StatelessWidget {
  final StableHordeTask task;
  final bool showText;

  const TaskProgressIndicator(this.task, {super.key, required this.showText});

  @override
  Widget build(BuildContext context) {
    // Once the task is complete, hide the progress indicator.
    if (task.isComplete()) {
      return const SizedBox.shrink();
    }

    final Widget progressIndicator;
    if (task.estimatedCompletionTime == null) {
      progressIndicator = const Center(child: CircularProgressIndicator());
    } else {
      progressIndicator = Center(
        child: TimedProgressIndicator(
          startTime: task.firstShowProgressIndicatorTime!,
          completionTime: task.estimatedCompletionTime!,
        ),
      );
    }

    if (!showText) {
      return progressIndicator;
    }

    final String loadingMessage;
    if (task.estimatedCompletionTime == null) {
      loadingMessage = 'Loading...';
    } else {
      loadingMessage =
          'Estimated completion time: ${task.estimatedCompletionTime!.difference(DateTime.now()).inSeconds} seconds';
    }

    return Stack(
      children: [
        progressIndicator,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(loadingMessage),
          ),
        ),
      ],
    );
  }
}
