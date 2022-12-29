import 'package:firebase_analytics/firebase_analytics.dart';

class _ConversionsBloc {
  void tutorialBegin() {
    FirebaseAnalytics.instance.logTutorialBegin();
  }

  void tutorialComplete() {
    FirebaseAnalytics.instance.logTutorialComplete();
  }

  void generateImage() {
    _printAndLogEvent(name: "generate_image");
  }

  void beginLogin() {
    _printAndLogEvent(name: "login_begin");
  }

  void completeLogin() {
    FirebaseAnalytics.instance.logLogin();
  }

  void logout() {
    _printAndLogEvent(name: "logout");
  }

  void viewLink(String url) {
    _printAndLogEvent(name: "view_link", parameters: {"url": url});
  }

  void _printAndLogEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) {
    print("Logging event: $name {$parameters}");
    FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
      callOptions: callOptions,
    );
  }
}

final conversionsBloc = _ConversionsBloc();
