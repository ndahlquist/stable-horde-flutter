
import 'package:firebase_analytics/firebase_analytics.dart';

class _ConversionsBloc {

  void tutorialBegin() {
    FirebaseAnalytics.instance.logTutorialBegin();
  }

  void tutorialComplete() {
    FirebaseAnalytics.instance.logTutorialComplete();
  }

  void generateImage() {
    FirebaseAnalytics.instance.logEvent(name: "generate_image");
  }
}

final conversionsBloc = _ConversionsBloc();