import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/conversions_bloc.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_user_bloc.dart';
import 'package:stable_horde_flutter/dialogs/login_dialog.dart';
import 'package:stable_horde_flutter/model/stable_horde_user.dart';
import 'package:stable_horde_flutter/utils/legal_links.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
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

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(left: 12),
            child: CircularProgressIndicator(),
          );
        }

        var user = snapshot.data;
        if (user == null) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You are currently anonymous. For faster image generation, login to a Stable Horde account.",
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    conversionsBloc.beginLogin();

                    await showDialog(
                      context: context,
                      builder: (_) {
                        return const LoginDialog();
                      },
                    );

                    // Refresh user UI.
                    setState(() {});
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loggedInUserWidget(user),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    conversionsBloc.logout();
                    await sharedPrefsBloc.setApiKey(null);
                    await sharedPrefsBloc.setImg2ImgInput(null);
                    await sharedPrefsBloc.setDonateImageOption(true);
                    Sentry.configureScope((scope) {
                      scope.setUser(null);
                    });
                    setState(() {});
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _loggedInUserWidget(StableHordeUser user) {
    return SectionFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.username,
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
                  "${NumberFormat.decimalPattern().format(user.kudos)} kudos",
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
            "${NumberFormat.decimalPattern().format(user.numRequested)} images generated",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "${NumberFormat.decimalPattern().format(user.numInferences)} images contributed",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
