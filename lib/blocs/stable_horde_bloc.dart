import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/main.dart';
import 'package:stable_horde_flutter/model/stable_diffusion_model.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';

class _StableHordeBloc {
  Future requestDiffusion() async {
    final prompt = await sharedPrefsBloc.getPrompt();
    final negativePrompt = await sharedPrefsBloc.getNegativePrompt();

    // Add new task to db.
    final dbId = await isar.writeTxn(() async {
      return isar.stableHordeTasks.put(StableHordeTask(prompt));
    });
    final task = await isar.stableHordeTasks.get(dbId);

    var apiKey = await sharedPrefsBloc.getApiKey();
    apiKey ??= "0000000000"; // Anonymous API key.

    final headers = {
      'Accept': '* / *',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
      "Content-Type": "application/json",
      "apikey": apiKey,
    };

    final json = {
      'prompt': prompt + " ### " + negativePrompt,
      'params': {
        'steps': 30,
        'n': 1,
        'sampler_name': 'k_euler',
        'width': 512,
        'height': 512,
        'cfg_scale': 7,
        'seed_variation': 1000,
        'seed': '',
        'karras': true,
        //'denoising_strength': mutationRate,
        'post_processing': [],
      },
      'nsfw': false,
      'censor_nsfw': false,
      'trusted_workers': false,
      //'source_processing': 'img2img',
      //'source_image': base64.encode(sourceImage.buffer.asUint8List()),
      'models': [
        'stable_diffusion',
      ],
      'r2': true,
    };

    final response = await http.post(
      Uri.parse('https://stablehorde.net/api/v2/generate/async'),
      headers: headers,
      body: jsonEncode(json),
    );

    if (response.statusCode != 202) {
      throw Exception(
        'Failed to request diffusion: '
        '${response.statusCode} ${response.body}',
      );
    }
    final jsonResponse = jsonDecode(response.body);
    final taskId = jsonResponse['id']!;

    for (int i = 0; i < 1000; i++) {
      await Future.delayed(const Duration(seconds: 2));
      print('update $i');
      if (task!.estimatedCompletionTime != null) {
        if (DateTime.now().isBefore(task.estimatedCompletionTime!)) {
          continue;
        }
      }

      final response = await http.get(
        Uri.parse(
          'https://stablehorde.net/api/v2/generate/status/$taskId',
        ),
      );
      if (response.statusCode == 429) {
        print('Rate limit exceeded');
        await Future.delayed(const Duration(seconds: 10));
        return;
      }

      if (response.statusCode != 200) {
        final exception = Exception(
          'Failed to get task status: '
          '${response.statusCode} ${response.body}',
        );
        print(exception);
        Sentry.captureException(exception, stackTrace: StackTrace.current);
        continue;
      }

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      final waitSeconds = jsonResponse['wait_time'];
      final estimatedCompletionTime = DateTime.now().add(
        Duration(seconds: waitSeconds),
      );
      print('Estimated completion time: $estimatedCompletionTime');

      task.firstShowProgressIndicatorTime ??= DateTime.now();
      task.estimatedCompletionTime = estimatedCompletionTime;

      final generations = jsonResponse['generations'] as List;

      if (generations.isEmpty) {
        await isar.writeTxn(() async {
          isar.stableHordeTasks.put(task);
        });
        continue;
      }

      assert(generations.length == 1);

      final generation = generations.first;
      final imageUrl = generation['img'];
      final imageFile = await _downloadImageFromUrl(imageUrl);
      task.imagePath = imageFile.path;
      await isar.writeTxn(() async {
        isar.stableHordeTasks.put(task);
      });

      return;
    }

    throw Exception('Failed to complete task');
  }

  Future<File> _downloadImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download image: '
        '${response.statusCode} ${response.body}',
      );
    }

    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.webp';
    final file = await File(path).create();
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<List<StableHordeTask>> _getTasks() async {
    return await isar.stableHordeTasks.where().findAll();
  }

  Stream<List<StableHordeTask>> getTasksStream() async* {
    final snapshots = isar.stableHordeTasks.watchLazy(fireImmediately: true);
    await for (final _ in snapshots) {
      yield await _getTasks();
    }
  }

  Future<List<StableDiffusionModel>> _getModels() async {
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

    final List<StableDiffusionModel> models = [];
    for (final entry in jsonResponse) {
      final count = entry['count'];
      if (count == 0) continue;
      models.add(
        StableDiffusionModel(
          entry['name'],
          count,
        ),
      );
    }

    return models;
  }

  Future<List<StableDiffusionModel>> _getModelDetails(
      List<StableDiffusionModel> models) async {
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

    final List<StableDiffusionModel> modelsWithDetails = [];
    for (final model in models) {
      final details = jsonResponse[model.name];
      final showcases = details['showcases'];
      if (showcases == null) {
        print('Warning: skipping {model.name} because it has no showcases');
        continue;
      }

      model.previewImageUrl = showcases[0];
      model.description = details['description'];
      modelsWithDetails.add(model);
    }

    return modelsWithDetails;
  }

  Future<List<StableDiffusionModel>> getModels() async {
    final models = await _getModels();

    models.sort((a, b) => b.workerCount.compareTo(a.workerCount));

    return await _getModelDetails(models);
  }
}

final stableHordeBloc = _StableHordeBloc();
