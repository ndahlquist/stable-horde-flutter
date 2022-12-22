import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';

class TaskImage extends StatelessWidget {
  final StableHordeTask task;

  const TaskImage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Directory>(
      future: getApplicationDocumentsDirectory(),
      builder: (context, snapshot) {
        final filename = task.imageFilename;

        final directory = snapshot.data;

        final Widget child;

        if (directory == null || filename == null) {
          // Choose a pseudo-random color gradient for the background
          final random = Random(task.dbId);
          final color1 = Colors
              .primaries[random.nextInt(Colors.primaries.length)].shade500;
          final color2 = Colors
              .primaries[random.nextInt(Colors.primaries.length)].shade900;

          child = FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            key: const ValueKey('colored box'),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [color1, color2],
                ),
              ),
            ),
          );
        } else {
          child = FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            key: ValueKey(filename),
            child: Image.file(
              File(directory.path + '/' + filename),
              fit: BoxFit.cover,
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: child,
        );
      },
    );
  }
}
