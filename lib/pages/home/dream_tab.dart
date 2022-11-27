import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/model/world.dart';
import 'package:zoomscroller/pages/world_editor_page.dart';

class DiscoverTab extends StatefulWidget {
  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab>
    with AutomaticKeepAliveClientMixin {
  final _worldsStream =
      worldSyncBloc.getWorldsForDiscover().asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<World>>(
      stream: _worldsStream,
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

        var data = snapshot.data;
        if (data == null) {
          return const Center(
            child: Text(
              "Error loading; please try again later.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        data = data.where((element) => element.imageUrl != null).toList();

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _DiscoverTile(world: data![index]);
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
  bool _copyInProgress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.world.userId == userBloc.getMyUserId()) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WorldEditorPage(worldId: widget.world.id),
            ),
          );
        } else {
          setState(() {
            _copyInProgress = true;
          });

          try {
            final worldId = await worldSyncBloc.photocopyWorld(widget.world.id);

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WorldEditorPage(worldId: worldId),
              ),
            );

            // Destroy the world if we haven't made any edits.
            final layers = await worldSyncBloc.getLayersForWorld(worldId).first;
            if (layers.last.userId != userBloc.getMyUserId()) {
              await worldSyncBloc.deleteWorld(worldId);
            }
          } finally {
            setState(() {
              _copyInProgress = false;
            });
          }
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.world.imageUrl!,
          ),
          if (_copyInProgress)
            Center(
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
