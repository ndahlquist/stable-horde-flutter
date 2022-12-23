import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
          Sentry.captureException(
            snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }

        var data = snapshot.data;
        if (data == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "${NumberFormat.decimalPattern().format(data.kudos)} kudos",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                "${NumberFormat.decimalPattern().format(data.numRequested)} images generated",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "${NumberFormat.decimalPattern().format(data.numInferences)} images contributed",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
