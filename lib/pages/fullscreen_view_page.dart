import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/widgets/task_progress_indicator.dart';

class FullScreenViewPage extends StatelessWidget {
  final int initialIndex;

  const FullScreenViewPage({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF230D49),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: StreamBuilder<List<StableHordeTask>>(
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
          return PageView.builder(
            controller: PageController(initialPage: initialIndex),
            scrollDirection: Axis.vertical,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _page(context, task);
            },
          );
        },
      ),
    );
  }

  Widget _page(BuildContext context, StableHordeTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: _imageSection(context, task),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            task.prompt,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _imageSection(BuildContext context, StableHordeTask task) {
    final imagePath = task.imagePath;

    if (imagePath == null) {
      return Stack(
        children: [
          const FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: ColoredBox(color: stableHordeGrey),
          ),
          TaskProgressIndicator(task),
        ],
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
    );
  }
}
