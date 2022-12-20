
import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/widgets/timed_progress_indicator.dart';

class TaskProgressIndicator extends StatelessWidget {
  final StableHordeTask task;

  const TaskProgressIndicator(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    // Once the task is complete, hide the progress indicator.
    if (task.isComplete()) {
      return const SizedBox.shrink();
    }

    if (task.estimatedCompletionTime == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: TimedProgressIndicator(
          startTime: task.firstShowProgressIndicatorTime!,
          completionTime: task.estimatedCompletionTime!.add(
            const Duration(seconds: 2),
          ),
        ),
      );
    }
  }

}