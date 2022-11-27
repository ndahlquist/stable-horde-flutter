import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/model/world.dart';

// TODO: Make this slowly scroll through the images.
class BackgroundImageGrid extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<World>>(
      stream: worldSyncBloc.getWorldsForDiscover(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
        }

        var data = snapshot.data;
        if (data == null) {
          return SizedBox.shrink();
        }

        data = data.where((element) => element.imageUrl != null).toList();

        return GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final world = data![index];

            return CachedNetworkImage(
              imageUrl: world.imageUrl!,
            );
          },
        );
      },
    );
  }
}
