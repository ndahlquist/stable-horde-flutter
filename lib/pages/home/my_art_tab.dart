import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zoomscroller/blocs/stable_horde_bloc.dart';
import 'package:zoomscroller/model/stable_horde_task.dart';

class MyArtTab extends StatefulWidget {
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
        final tasks = snapshot.data ?? [];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return ListTile(
              title: Text(
                task.taskId,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
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
