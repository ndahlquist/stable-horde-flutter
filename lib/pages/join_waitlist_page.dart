import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/colors.dart';

class JoinWaitlistPage extends StatefulWidget {
  @override
  State<JoinWaitlistPage> createState() => _JoinWaitlistPageState();
}

class _JoinWaitlistPageState extends State<JoinWaitlistPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(minutes: 5), () {
      if (!mounted) return;

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF230D49),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Waitlist'),
      ),
      body: FutureBuilder<bool>(
        future: _needsPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final needsPermission = snapshot.data!;
          if (needsPermission) {
            return _subscribeToNotifsWidget(context);
          } else {
            return Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Our AI servers are currently at capacity.\n\nYou're on the waitlist, and we'll let you know when you can start dreaming with us!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(flex: 2),
                SizedBox(height: 32),
              ],
            );
          }
        },
      ),
    );
  }

  Future<bool> _needsPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    final authStatus = settings.authorizationStatus;
    print(settings.authorizationStatus);
    return authStatus == AuthorizationStatus.notDetermined ||
        authStatus == AuthorizationStatus.denied;
  }

  Widget _subscribeToNotifsWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Spacer(),
            Text(
              "Our AI servers are currently at capacity.\n\nWe've added you to the waitlist— can we send you a notification when we're ready?",
              style: TextStyle(color: Colors.white),
            ),
            Spacer(flex: 2),
            FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: _attemptToSubscribe,
                child: Text(
                  'Notify Me',
                  style: TextStyle(
                    color: zoomscrollerGrey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future _attemptToSubscribe() async {
    final success = await userBloc.setupPushNotifications();

    if (!mounted) return;

    final SnackBar snack;
    if (success) {
      snack = SnackBar(
        content: Text(
          'Thanks! We\'ll be in touch.',
        ),
      );
    } else {
      snack = SnackBar(
        content: Text(
          'Oops! Something went wrong.',
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(snack);

    setState(() {
      // Rebuild.
    });
  }
}
