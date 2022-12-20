import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to shared preferences.
class _SharedPrefsBloc {
  static const _promptKey = 'PROMPT_KEY';
  static const _apiKeyKey = 'API_KEY_KEY';

  Future<String> getLastPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_promptKey) ?? "";
  }

  Future<void> setPrompt(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_promptKey, prompt);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  Future<void> setApiKey(String? apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (apiKey != null) {
      await prefs.setString(_apiKeyKey, apiKey);
    } else {
      await prefs.remove(_apiKeyKey);
    }
  }
}

final sharedPrefsBloc = _SharedPrefsBloc();
