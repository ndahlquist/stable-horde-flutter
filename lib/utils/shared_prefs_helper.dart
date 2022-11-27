import 'package:shared_preferences/shared_preferences.dart';

final _hasSeenTutorialKey = 'has_seen_tutorial';

Future<bool> getHasSeenTutorial() async {
  final _prefs = await SharedPreferences.getInstance();
  return _prefs.getBool(_hasSeenTutorialKey) ?? false;
}

Future<void> setHasSeenTutorial() async {
  final _prefs = await SharedPreferences.getInstance();
  await _prefs.setBool(_hasSeenTutorialKey, true);
}
