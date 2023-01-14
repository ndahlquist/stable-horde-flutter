import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/image_transcode_bloc.dart';
import 'package:stable_horde_flutter/blocs/models_bloc.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/main.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';
import 'package:stable_horde_flutter/utils/http_wrapper.dart';

class _TasksBloc {
  Future requestDiffusion() async {
    final prompt = await sharedPrefsBloc.getPrompt();
    final negativePrompt = await sharedPrefsBloc.getNegativePrompt();
    final modelName = await sharedPrefsBloc.getModel();
    final seed = await sharedPrefsBloc.getSeed();

    final List<String> postProcessors = [];

    if (await sharedPrefsBloc.getUpscaleEnabled()) {
      postProcessors.add("RealESRGAN_x4plus");
    }

    if (await sharedPrefsBloc.getCodeformersEnabled()) {
      postProcessors.add("CodeFormers");
    }

    // Add new task to db.
    final dbId = await isar.writeTxn(() async {
      final task = StableHordeTask(prompt, negativePrompt, modelName);
      if (seed != null) {
        task.seed = seed;
      }

      return isar.stableHordeTasks.put(task);
    });
    final task = await isar.stableHordeTasks.get(dbId);
    task!;

    try {
      var apiKey = await sharedPrefsBloc.getApiKey();
      apiKey ??= "0000000000"; // Anonymous API key.

      final headers = await getHttpHeaders(apiKey);

      final model = await modelsBloc.getModel(modelName);
      print("template: ${model.promptTemplate}");
      final formattedPrompt = model.promptTemplate
          .replaceAll('{p}', prompt)
          .replaceAll('{np}', ' ### $negativePrompt');
      print(formattedPrompt);

      final json = {
        'prompt': formattedPrompt,
        'params': {
          'steps': 30,
          'n': 1,
          'sampler_name': 'k_euler',
          'width': 512,
          'height': 512,
          'cfg_scale': 7,
          'seed_variation': 1000,
          'seed': seed == null ? '' : '$seed',
          'karras': true,
          //'denoising_strength': mutationRate,
          'post_processing': postProcessors,
        },
        'nsfw': false,
        'censor_nsfw': false,
        'trusted_workers': false,
        //'source_processing': 'img2img',
        //'source_image': base64.encode(sourceImage.buffer.asUint8List()),
        'models': [modelName],
        'r2': true,
      };

      final response = await httpPost(
        'https://stablehorde.net/api/v2/generate/async',
        headers: headers,
        body: jsonEncode(json),
      );

      if (response == null) {
        throw Exception(
          'Failed to request diffusion due to internet connection',
        );
      }

      if (response.statusCode != 202) {
        throw Exception(
          'Failed to request diffusion: '
          '${response.statusCode} ${response.body} ${jsonEncode(json)}',
        );
      }
      final jsonResponse = jsonDecode(response.body);

      task.stableHordeId = jsonResponse['id']!;
      await isar.writeTxn(() async {
        isar.stableHordeTasks.put(task);
      });
    } on Exception catch (_) {
      task.failed = true;
      await isar.writeTxn(() async {
        isar.stableHordeTasks.put(task);
      });

      rethrow;
    }

    _waitOnTask(task);
  }

  Future<bool> _checkTaskCompletion(StableHordeTask task) async {
    if (task.failed) return true;

    final url =
        'https://stablehorde.net/api/v2/generate/check/${task.stableHordeId!}';
    final response = await httpGet(url);
    if (response == null) return false;

    if (response.statusCode == 404) {
      print(response);
      await isar.writeTxn(() async {
        task.failed = true;
        isar.stableHordeTasks.put(task);
      });
      return false;
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get task status: '
        '${response.statusCode} ${response.body}',
      );
    }

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    final waitSeconds = jsonResponse['wait_time'];
    final estimatedCompletionTime = DateTime.now().add(
      Duration(seconds: waitSeconds),
    );
    print('Estimated completion time: $estimatedCompletionTime');

    task.firstShowProgressIndicatorTime ??= DateTime.now();
    task.estimatedCompletionTime = estimatedCompletionTime.add(
      const Duration(seconds: 2),
    );

    await isar.writeTxn(() async {
      isar.stableHordeTasks.put(task);
    });

    return jsonResponse['done'];
  }

  Future<bool> _retrieveTaskResult(StableHordeTask task) async {
    final url =
        'https://stablehorde.net/api/v2/generate/status/${task.stableHordeId!}';

    final response = await httpGet(url);
    if (response == null) return false;

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get task status: '
        '${response.statusCode} ${response.body}',
      );
    }

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    final generations = jsonResponse['generations'] as List;
    if (generations.isEmpty) {
      return false;
    }

    if (generations.length != 1) {
      throw Exception(
        "Unexpected number of generations: ${generations.length}",
      );
    }

    final generation = generations.first;
    final imageUrl = generation['img'];
    task.imageFilename = await _downloadImageFromUrl(imageUrl);
    task.seed = int.tryParse(generation['seed']);
    await isar.writeTxn(() async {
      isar.stableHordeTasks.put(task);
    });

    // This feature transcodes the image to jpg for convenience,
    // and saves it to a user-accessible directory.
    // On Android, this is the Pictures directory.
    imageTranscodeBloc.transcodeImageToJpg(task).then((jpegFile) async {
      final Directory externalDirectory;
      if (Platform.isAndroid) {
        externalDirectory = Directory("/sdcard/Pictures/stable-diffusion");
      } else {
        externalDirectory = await getApplicationDocumentsDirectory();
      }
      final outFilename = task.imageFilename!.replaceAll('.webp', '.jpg');

      await externalDirectory.create();

      await jpegFile.copy('${externalDirectory.path}/$outFilename');
      print('transcoded to ${externalDirectory.path}/$outFilename');
    });

    return true;
  }

  Future _waitOnTask(StableHordeTask task) async {
    for (int i = 0; i < 10000; i++) {
      await Future.delayed(const Duration(seconds: 7));
      print('update ${task.dbId} -- $i');
      try {
        bool complete = await _checkTaskCompletion(task);
        if (!complete) continue;
      } catch (e, stackTrace) {
        print(e);
        print(stackTrace);
        Sentry.captureException(e, stackTrace: stackTrace);
        continue;
      }

      try {
        bool success = await _retrieveTaskResult(task);
        if (success) return;
      } catch (e, stackTrace) {
        print(e);
        print(stackTrace);

        task.failed = true;
        await isar.writeTxn(() async {
          isar.stableHordeTasks.put(task);
        });
        rethrow;
      }
    }

    throw Exception('Failed to complete task');
  }

  Future<String> _downloadImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download image: '
        '${response.statusCode} ${response.body}',
      );
    }

    final directory = await getApplicationSupportDirectory();

    final filename = '${DateTime.now().millisecondsSinceEpoch}.webp';

    final path = '${directory.path}/$filename';
    final file = await File(path).create();
    await file.writeAsBytes(response.bodyBytes);

    return filename;
  }

  Future<List<StableHordeTask>> _getTasks() async {
    return await isar.stableHordeTasks.where().findAll();
  }

  Future resumeIncompleteTasks() async {
    final tasks = await _getTasks();

    for (final task in tasks) {
      if (task.isComplete()) {
        continue;
      }

      if (task.failed) {
        continue;
      }

      _waitOnTask(task);
    }
  }

  Stream<List<StableHordeTask>> getTasksStream() async* {
    final snapshots = isar.stableHordeTasks.watchLazy(fireImmediately: true);
    await for (final _ in snapshots) {
      yield await _getTasks();
    }
  }
}

final tasksBloc = _TasksBloc();
