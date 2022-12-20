import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';

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
    final imagePath = task.imagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: imagePath == null
              ? const ColoredBox(color: stableHordeGrey)
              : Image.file(
                  File(imagePath),
                ),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'lorem ipsum',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
