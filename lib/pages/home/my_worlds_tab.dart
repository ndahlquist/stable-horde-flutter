import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/model/world.dart';
import 'package:zoomscroller/pages/world_editor_page.dart';

class MyWorldsTab extends StatefulWidget {
  @override
  State<MyWorldsTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<MyWorldsTab>
    with AutomaticKeepAliveClientMixin {
  final _worldsStream = worldSyncBloc.getMyWorlds().asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<World>>(
      stream: _worldsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
          itemCount: data.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return IconButton(
                onPressed: _attemptToCreateWorld,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              );
            }
            index -= 1;

            final world = data![index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorldEditorPage(worldId: world.id),
                  ),
                );
              },
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: world.imageUrl!,
                  ),
                  if (world.published)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(.6),
                          ],
                          stops: [0.5, 1],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.public,
                            color: Colors.white.withOpacity(.8),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
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

  Future _attemptToCreateWorld() async {
    final uuid = Uuid().v4();
    await worldSyncBloc.createWorld(uuid);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorldEditorPage(worldId: uuid),
        settings: RouteSettings(name: "/world/$uuid"),
      ),
    );
  }
}
