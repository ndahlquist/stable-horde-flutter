import 'package:shared_preferences/shared_preferences.dart';

const _promptKey = 'PROMPT_KEY';

Future<String> getLastPrompt() async {
  final _prefs = await SharedPreferences.getInstance();
  return _prefs.getString(_promptKey) ?? "";
}

Future<void> setPrompt(String prompt) async {
  final _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(_promptKey, prompt);
}
