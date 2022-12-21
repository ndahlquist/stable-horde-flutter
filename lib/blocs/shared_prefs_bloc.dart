import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to shared preferences.
class _SharedPrefsBloc {
  static const _apiKeyKey = 'API_KEY_KEY';

  static const _promptKey = 'PROMPT_KEY';
  static const _negativePromptKey = 'NEGATIVE_PROMPT_KEY';

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  Future<void> setApiKey(String? apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (apiKey != null && apiKey.trim().isEmpty) {
      apiKey = null;
    }
    if (apiKey != null) {
      await prefs.setString(_apiKeyKey, apiKey);
    } else {
      await prefs.remove(_apiKeyKey);
    }
  }

  Future<String> getPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_promptKey) ?? "";
  }

  Future setPrompt(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_promptKey, prompt);
  }

  Future<String> getNegativePrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_negativePromptKey) ?? "";
  }

  Future setNegativePrompt(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_negativePromptKey, prompt);
  }
}

final sharedPrefsBloc = _SharedPrefsBloc();
