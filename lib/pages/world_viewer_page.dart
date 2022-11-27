import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/model/world.dart';
import 'package:zoomscroller/pages/world_editor_page.dart';
import 'package:zoomscroller/widgets/world_zoom_viewer.dart';

/// Page that lets a user zoom and pan around a world.
class WorldViewerPage extends StatelessWidget {
  final World world;

  const WorldViewerPage({
    super.key,
    required this.world,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF230D49),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: WorldZoomWidget(
                  worldId: world.id,
                  inDrawingMode: false,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<String?>(
                          stream: userBloc.getUsernameForUserId(world.userId),
                          builder: (context, snapshot) {
                            return Text(
                              "@${snapshot.data}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat("MMM d, yyyy").format(world.lastUpdated),
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (userBloc.isAdmin())
                    StreamBuilder<bool>(
                      stream: worldSyncBloc.getApprovalState(world.id),
                      builder: (context, snapshot) {
                        bool approved = snapshot.data ?? false;
                        return IconButton(
                          icon: Icon(
                            approved ? Icons.check : Icons.close,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            worldSyncBloc.setApprovalState(world.id, !approved);
                          },
                        );
                      },
                    ),
                  if (userBloc.isAdmin())
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () async {
                        final newWorldId =
                            await worldSyncBloc.photocopyWorld(world.id);

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) =>
                                WorldEditorPage(worldId: newWorldId),
                          ),
                        );
                      },
                    ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                world.prompt?.trim() ?? "",
                style: TextStyle(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
