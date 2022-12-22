import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/image_transcode_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/main.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
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
      backgroundColor: const Color(0xFF230D49),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _deleteButton(),
        ],
      ),
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
          return isar.stableHordeTasks.delete(task.id);
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

        Share.shareXFiles([XFile(outputFile.path)]);
      },
    );
  }

  Widget _page(BuildContext context, StableHordeTask task) {
    return SafeArea(
      left: false,
      top: false,
      right: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: _imageSection(context, task),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(task.prompt),
            const SizedBox(height: 12),
            if (task.negativePrompt.isNotEmpty) ...[
              Text("Negative prompt: ${task.negativePrompt}"),
            ],
            const SizedBox(height: 12),
            Text(task.model),
            const Spacer(),
            _shareButton(task),
          ],
        ),
      ),
    );
  }

  Widget _imageSection(BuildContext context, StableHordeTask task) {
    final filename = task.imageFilename;

    if (filename == null) {
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

    return FutureBuilder<Directory>(
      future: getApplicationDocumentsDirectory(),
      builder: (context, snapshot) {
        final directory = snapshot.data;
        if (directory == null) return const SizedBox();

        return Image.file(
          File(directory.path + '/' + filename),
          fit: BoxFit.cover,
        );
      },
    );
  }
}
