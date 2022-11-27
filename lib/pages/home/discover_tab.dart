import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/main.dart';
import 'package:zoomscroller/model/stable_horde_task.dart';
import 'package:zoomscroller/model/world.dart';

class DiscoverTab extends StatefulWidget {
  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: isar.stableHordeTasks.watchLazy(),
      builder: (context, snapshot) {
        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }*/

        if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);

          Sentry.captureException(
            snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }
        final length = isar.stableHordeTasks.getSizeSync();
        return ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            final task = isar.stableHordeTasks.getSync(index);
            if (task == null) return SizedBox.shrink();

            return ListTile(
              title: Text(task!.taskId,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _DiscoverTile extends StatefulWidget {
  final World world;

  const _DiscoverTile({required this.world});

  @override
  State<_DiscoverTile> createState() => _DiscoverTileState();
}

class _DiscoverTileState extends State<_DiscoverTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // TODO
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.world.imageUrl!,
          ),
        ],
      ),
    );
  }
}
