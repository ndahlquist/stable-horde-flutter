import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_user_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_user.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

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
              GestureDetector(
                onTap: () {
                  launchUrlInExternalApp(
                    'https://dbzer0.com/blog/the-kudos-based-economy-for-the-koboldai-horde/',
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${NumberFormat.decimalPattern().format(data.kudos)} kudos",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Text(
                      "Kudos represent your contributions to the Stable Horde community. Kudos increase your request priority, speeding up your image generations. Kudos are consumed when generating images, and created by running an worker.",
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "LEARN MORE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "${NumberFormat.decimalPattern().format(data.numRequested)} images generated",
                style: const TextStyle(fontSize: 18),
              ),
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
