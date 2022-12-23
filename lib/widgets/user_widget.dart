import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_user_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_user.dart';

class UserWidget extends StatelessWidget {
  //final StableHordeUser user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StableHordeUser?>(
      future: stableHordeUserBloc.lookupUser(null),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
        }

        var data = snapshot.data;
        if (data == null) {
          return SizedBox.shrink();
        }

        return Text(data.username);
      },
    );
  }
}
