import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/model/world.dart';
import 'package:zoomscroller/pages/world_viewer_page.dart';

class ModerateTab extends StatefulWidget {
  @override
  State<ModerateTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<ModerateTab>
    with AutomaticKeepAliveClientMixin {
  final _worldsStream = worldSyncBloc.getAllWorlds().asBroadcastStream();

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
            final world = data![index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorldViewerPage(world: world),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: world.imageUrl!,
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
