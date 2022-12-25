import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to shared preferences.
class _SharedPrefsBloc {
  static const _onboardingKey = 'ONBOARDING_KEY';

  static const _apiKeyKey = 'API_KEY_KEY';

  static const _promptKey = 'PROMPT_KEY';
  static const _negativePromptKey = 'NEGATIVE_PROMPT_KEY';
  static const _modelKey = 'MODEL_KEY';
  static const _seedKey = 'SEED_KEY';

  static const defaultPrompt =
      "Futuristic spaceship. Rainforest. A painting of a spaceship on a rainforest planet by Caravaggio. Trending on Artstation. chiaroscuro.";
  static const defaultNegativePrompt = "Cropped.";

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future setHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

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
    return prefs.getString(_promptKey) ?? defaultPrompt;
  }

  Future setPrompt(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_promptKey, prompt);
  }

  Future<String> getNegativePrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_negativePromptKey) ?? defaultNegativePrompt;
  }

  Future setNegativePrompt(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_negativePromptKey, prompt);
  }

  Future<int?> getSeed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_seedKey);
  }

  Future setSeed(int ? seed) async {
    final prefs = await SharedPreferences.getInstance();
    if (seed == null) {
      await prefs.remove(_seedKey);
    } else {
      await prefs.setInt(_seedKey, seed);
    }
  }

  Future<String> getModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_modelKey) ?? "stable_diffusion";
  }

  Future setModel(String modelName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelKey, modelName);
  }
}

final sharedPrefsBloc = _SharedPrefsBloc();
