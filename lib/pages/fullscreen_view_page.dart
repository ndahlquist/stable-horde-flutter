import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/image_transcode_bloc.dart';
import 'package:stable_horde_flutter/blocs/tasks_bloc.dart';
import 'package:stable_horde_flutter/main.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/widgets/task_image.dart';
import 'package:stable_horde_flutter/widgets/task_progress_indicator.dart';

import 'package:share_plus/share_plus.dart';

class FullScreenViewPage extends StatefulWidget {
  final int initialIndex;

  const FullScreenViewPage({super.key, required this.initialIndex});

  @override
  State<FullScreenViewPage> createState() => _FullScreenViewPageState();
}

class _FullScreenViewPageState extends State<FullScreenViewPage> {
  late PageController pageController;
  late List<StableHordeTask> tasks;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Stable Horde'),
        elevation: 0,
        actions: [
          _deleteButton(),
        ],
      ),
      body: StreamBuilder<List<StableHordeTask>>(
        stream: tasksBloc.getTasksStream(),
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
          tasks = snapshot.data?.reversed.toList() ?? [];

          return PageView.builder(
            controller: pageController,
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

  Widget _deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        final task = tasks[pageController.page!.toInt()];
        isar.writeTxn(() async {
          return isar.stableHordeTasks.delete(task.dbId);
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget _shareButton(StableHordeTask task) {
    if (!task.isComplete()) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(Icons.adaptive.share),
      onPressed: () async {
        final outputFile = await imageTranscodeBloc.transcodeImageToJpg(task);

        await Share.shareXFiles([XFile(outputFile.path)]);
      },
    );
  }

  Widget _page(BuildContext context, StableHordeTask task) {
    return ClipRect(
      child: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 64,
                sigmaY: 64,
                tileMode: TileMode.clamp,
              ),
              child: _darken(
                child: TaskImage(task: task),
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TaskImage(task: task),
                        ),
                        if (!task.isComplete())
                          TaskProgressIndicator(
                            task,
                            showText: true,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"${task.prompt}"',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (task.negativePrompt.isNotEmpty)
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        text: "Negative Prompt: ",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: '"${task.negativePrompt}"',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    "Model: ${task.model}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (task.seed != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        "Seed: ${task.seed}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  const Spacer(),
                  _shareButton(task),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Applying a slight dark shade to the shadows gives some contrast
  //  for the case that the foreground is very bright.
  Widget _darken({required Widget child}) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.grey[600]!,
        BlendMode.modulate,
      ),
      child: child,
    );
  }
}
