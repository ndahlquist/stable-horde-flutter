import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/widgets/timed_progress_indicator.dart';

class MyArtTab extends StatefulWidget {
  const MyArtTab({super.key});

  @override
  State<MyArtTab> createState() => _MyArtTabState();
}

class _MyArtTabState extends State<MyArtTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<StableHordeTask>>(
      stream: stableHordeBloc.getTasksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);

          Sentry.captureException(
            snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }
        var tasks = snapshot.data ?? [];

        tasks = tasks.reversed.toList();

        return GridView.builder(
          itemCount: tasks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final task = tasks[index];

            return Stack(children: [
              if (task.imagePath != null)
                Image.file(File(task.imagePath!),
                  fit: BoxFit.cover,
                ),
              _progressIndicator(task),
            ]);
          },
        );
      },
    );
  }

  Widget _progressIndicator(StableHordeTask task) {
    // Once the task is complete, hide the progress indicator.
    if (task.imageUrl != null) {
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

  @override
  bool get wantKeepAlive => true;
}
