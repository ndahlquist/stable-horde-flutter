import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
              if (task.imageUrl != null)
                CachedNetworkImage(
                  imageUrl: task.imageUrl!,
                  fit: BoxFit.cover,
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Text(task.taskId),
              ),
            ]);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
