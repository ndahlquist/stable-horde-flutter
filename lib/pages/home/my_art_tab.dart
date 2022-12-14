import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/tasks_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/pages/fullscreen_view_page.dart';
import 'package:stable_horde_flutter/pages/home_page.dart';
import 'package:stable_horde_flutter/widgets/task_image.dart';
import 'package:stable_horde_flutter/widgets/task_progress_indicator.dart';

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
        var tasks = snapshot.data ?? [];

        tasks = tasks.reversed.toList();

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              children: [
                const Spacer(),
                const Text('No dreams yet!'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    homeController.animateToPage(0);
                  },
                  child: const Text(
                    'Generate your first image',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }

        return GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: tasks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final task = tasks[index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: const RouteSettings(name: "FullScreenViewPage"),
                    builder: (_) => FullScreenViewPage(initialIndex: index),
                  ),
                );
              },
              child: Stack(
                children: [
                  TaskImage(task: task),
                  TaskProgressIndicator(task, showText: false),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
