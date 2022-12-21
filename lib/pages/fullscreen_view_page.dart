import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/main.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/widgets/task_progress_indicator.dart';

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

  void _saveImage() {}

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: () async {
        final task = tasks[pageController.page!.toInt()];
        final path = task.imagePath!;

        // TODO: Move to isolate.
        final image = img.decodeWebP(File(path).readAsBytesSync())!;

        final downloadDir;
        if (Platform.isAndroid) {
          downloadDir = "/storage/emulated/0/Download/";
        } else if (Platform.isIOS) {
          downloadDir = (await getApplicationDocumentsDirectory()).path;
        } else {
          throw Exception("Unsupported platform");
        }

        final outFile = "$downloadDir${task.id}.jpg";

        File(outFile).writeAsBytesSync(img.encodeJpg(image));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Saved to $outFile"),
          ),
        );
      },
    );
  }

  Widget _page(BuildContext context, StableHordeTask task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: _imageSection(context, task),
          ),
          const SizedBox(height: 12),
          Text(task.prompt),
          const SizedBox(height: 12),
          if (task.negativePrompt.isNotEmpty) ...[
            Text("Negative prompt: ${task.negativePrompt}"),
          ],
          const SizedBox(height: 12),
          Text(task.model),
          Spacer(),
          _saveButton(),
          const SizedBox(height: 12),
        ],
      ),
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
