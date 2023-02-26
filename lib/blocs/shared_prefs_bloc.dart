import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to shared preferences.
class _SharedPrefsBloc {
  static const _onboardingKey = 'ONBOARDING_KEY';

  static const _apiKeyKey = 'API_KEY_KEY';

  static const _promptKey = 'PROMPT_KEY';
  static const _negativePromptKey = 'NEGATIVE_PROMPT_KEY';
  static const _modelKey = 'MODEL_KEY';
  static const _seedKey = 'SEED_KEY';
  static const _upscaleKey = 'UPSCALE_KEY';
  static const _codeformersKey = 'CODEFORMERS_KEY';
  static const _img2ImgInputKey = 'IMG2IMG_INPUT_KEY';
  static const _denoisingStrengthKey = 'DENOISING_STRENGTH_KEY';
  static const _donateImageOptionKey = 'DONATE_IMAGE_OPTION_KEY';
  static const _saveImagesOptionKey = 'SAVE_IMAGES_OPTION_KEY';
  static const _controlTypeKey = 'CONTROL_TYPE_KEY';

  static const defaultPrompt =
      "Futuristic spaceship. Rainforest. A painting of a spaceship on a rainforest planet by Caravaggio. Trending on Artstation. chiaroscuro.";
  static const defaultNegativePrompt = "Cropped, framed";

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
    return prefs.getString(_apiKeyKey)?.replaceAll(
          RegExp(r"[^A-Za-z0-9_-]"),
          "",
        );
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

  Future setSeed(int? seed) async {
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

  Future<bool> getUpscaleEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_upscaleKey) ?? false;
  }

  Future setUpscaleEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_upscaleKey, enabled);
  }

  Future<bool> getCodeformersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_codeformersKey) ?? false;
  }

  Future setCodeformersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_codeformersKey, enabled);
  }

  // Note: This is a base64 encoded image- not a filename!
  Future<String?> getImg2ImgInput() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_img2ImgInputKey);
  }

  // Note: This expects a base64 encoded image- not a filename!
  Future setImg2ImgInput(String? encodedFileString) async {
    final prefs = await SharedPreferences.getInstance();
    if (encodedFileString != null) {
      await prefs.setString(_img2ImgInputKey, encodedFileString);
    } else {
      await prefs.remove(_img2ImgInputKey);
    }
  }

  // Returns denoising strength (default is 0.4)
  Future<double> getDenoisingStrength() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_denoisingStrengthKey) ?? .4;
  }

  Future setDenoisingStrength(double? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_denoisingStrengthKey);
    } else {
      await prefs.setDouble(_denoisingStrengthKey, value);
    }
  }

  Future<String> getControlType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_controlTypeKey) ?? 'none';
  }

  Future setControlType(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_controlTypeKey, value);
  }

  // Returns donate image option (default should be true)
  Future<bool> isDonateImageEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_donateImageOptionKey) ?? true;
  }

  Future setDonateImageOption(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_donateImageOptionKey, value);
  }

  Future<bool> getSaveImageEnabled() async {
    // Before Android 10 (API level 30), we require the WRITE_EXTERNAL_STORAGE permission.
    // https://developer.android.com/about/versions/11/privacy/storage
    if (Platform.isAndroid) {
      final version = await DeviceInfoPlugin().androidInfo;
      if (version.version.sdkInt < 30) {
        final status = await Permission.storage.status;
        if (!status.isGranted) {
          return false;
        }
      }
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_saveImagesOptionKey) ?? true;
  }

  Future setSaveImageEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_saveImagesOptionKey, value);
  }
}

final sharedPrefsBloc = _SharedPrefsBloc();
