import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/model/world.dart';
import 'package:zoomscroller/pages/world_editor_page.dart';

class DreamTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
            ),
          ),

        ],
      ),
    );
  }

}
