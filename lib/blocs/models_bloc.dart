import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stable_horde_flutter/model/stable_horde_model.dart';

class _ModelsBloc {
  List<StableHordeModel>? _cachedModels;

  Future<List<StableHordeModel>> getModels() async {
    if (_cachedModels != null) {
      return _cachedModels!;
    }

    final start = DateTime.now();

    final results = await Future.wait([
      _getModels(),
      _getModelDetails(),
      _getStyles(),
    ]);

    final models = results[0] as List<StableHordeBaseModel>;
    final modelDetails = results[1] as Map<String, StableHordeModelDetails>;
    final styles = results[2] as Map<String, String>;

    models.sort((a, b) => b.workerCount.compareTo(a.workerCount));

    final end = DateTime.now();

    print("Models loaded in ${end.difference(start).inMilliseconds}ms");

    List<StableHordeModel> outputModels = [];

    for (final model in models) {
      final modelDetail = modelDetails[model.name];
      if (modelDetail == null) {
        print('skipping model ${model.name} because it has no details');
        continue;
      }

      outputModels.add(
        StableHordeModel(
          model.name,
          model.workerCount,
          modelDetails[model.name]!.description,
          modelDetails[model.name]!.previewImageUrl,
          styles[model.name] ?? "{p} {np}",
        ),
      );
    }

    _cachedModels = outputModels;

    return _cachedModels!;
  }

  Future<StableHordeModel> getModel(String modelName) async {
    final models = await getModels();
    try {
      return models.firstWhere((element) => element.name == modelName);
    } catch (e) {
      print(e);
      print("Models length: ${models.length}");
      throw Exception("Model $modelName not found");
    }
  }

  Future<List<StableHordeBaseModel>> _getModels() async {
    final response = await http.get(
      Uri.parse(
        'https://stablehorde.net/api/v2/status/models',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get models: '
        '${response.statusCode} ${response.body}',
      );
    }

    final jsonResponse = jsonDecode(response.body) as List;

    final List<StableHordeBaseModel> models = [];
    for (final entry in jsonResponse) {
      final count = entry['count'];
      if (count == 0) continue;
      models.add(
        StableHordeBaseModel(
          entry['name'],
          count,
        ),
      );
    }

    return models;
  }

  // Returns a mapping of model name to model style strings.
  // This is necessary to get the trigger keyword for each model.
  Future<Map<String, String>> _getStyles() async {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/db0/Stable-Horde-Styles/main/styles.json',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get styles: '
        '${response.statusCode} ${response.body}',
      );
    }

    final jsonResponse = jsonDecode(response.body) as Map;
    print(jsonResponse);

    final Map<String, String> styles = {};
    for (final rawStyle in jsonResponse.values) {
      final modelName = rawStyle['model'];
      final prompt = rawStyle['prompt'] as String;
      if (!prompt.contains('{p}') || !prompt.contains('{np}')) {
        continue;
      }

      if (!styles.containsKey(modelName)) {
        styles[modelName] = prompt;
      } else if (styles[modelName]!.length > prompt.length) {
        styles[modelName] = prompt;
      }
    }

    return styles;
  }

  Future<Map<String, StableHordeModelDetails>> _getModelDetails() async {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/Sygil-Dev/nataili-model-reference/main/db.json',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get models: '
        '${response.statusCode} ${response.body}',
      );
    }

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

    final Map<String, StableHordeModelDetails> modelDetails = {};
    for (final modelName in jsonResponse.keys) {
      final details = jsonResponse[modelName];
      final showcases = details['showcases'];
      if (showcases == null || showcases.isEmpty) {
        continue;
      }

      modelDetails[modelName] = StableHordeModelDetails(
        details['description'],
        showcases[0],
      );
    }

    return modelDetails;
  }
}

final modelsBloc = _ModelsBloc();
