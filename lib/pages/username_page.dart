import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/colors.dart';

class UsernamePage extends StatefulWidget {
  final String initialUsername;

  UsernamePage(this.initialUsername);

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialUsername;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: zoomscrollerGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Spacer(),
          Text(
            "Choose a username!",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            "(You can always change it later.)",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(32),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: _attemptToSetUsername,
            child: Text("Confirm"),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Future _attemptToSetUsername() async {
    final username = _controller.text.trim();
    if (username.isEmpty) {
      final snack = SnackBar(content: Text("Username cannot be empty."));
      ScaffoldMessenger.of(context).showSnackBar(snack);

      return;
    }

    // TODO: Verify username is not taken.

    try {
      await userBloc.setMyUsername(username);
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);

      final snack = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snack);
      return;
    }
    Navigator.pop(context);
  }
}
