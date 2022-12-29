
import 'package:firebase_analytics/firebase_analytics.dart';

class _ConversionsBloc {

  void tutorialBegin() {
    FirebaseAnalytics.instance.logTutorialBegin();
  }

  void tutorialComplete() {
    FirebaseAnalytics.instance.logTutorialComplete();
  }
}

final conversionsBloc = _ConversionsBloc();