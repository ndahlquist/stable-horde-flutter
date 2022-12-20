import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/main.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';

class _StableHordeBloc {
  Future requestDiffusion(
    String prompt,
    double mutationRate,
  ) async {
    final headers = {
      'Accept': '* / *',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
      'apikey': 'oad7PZBRUgwrpucqgEBgEw', // TODO
      "Content-Type": "application/json",
    };

    final json = {
      'prompt': prompt,
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
        'denoising_strength': mutationRate,
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

    // Make a POST request with the json data
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

    final taskId = jsonResponse['id'];
    print(taskId);

    await isar.writeTxn(() async {
      isar.stableHordeTasks.put(StableHordeTask(taskId));
    });

    for (int i = 0; i < 1000; i++) {
      await Future.delayed(const Duration(seconds: 1));
      print('update $i');
      _updateTasks();

      var tasks = await isar.stableHordeTasks.where().findAll();
      final unfinishedTasks = tasks.where((task) => task.imageUrl == null);
      if (unfinishedTasks.isEmpty) {
        break;
      }

      if (i == 999) {
        throw Exception('Failed to complete tasks');
      }
    }
  }

  Future _updateTasks() async {
    final tasks = await isar.stableHordeTasks.where().findAll();
    for (final task in tasks) {
      if (task.imageUrl != null) {
        continue;
      }

      if (task.estimatedCompletionTime != null) {
        if (DateTime.now().isBefore(task.estimatedCompletionTime!)) {
          continue;
        }
      }

      final response = await http.get(
        Uri.parse(
          'https://stablehorde.net/api/v2/generate/status/${task.taskId}',
        ),
      );
      if (response.statusCode == 429) {
        print('Rate limit exceeded');
        print(response);
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
      final estimatedCompletionTime =
          DateTime.now().add(Duration(seconds: waitSeconds),);
      print('Estimated completion time: $estimatedCompletionTime');

      task.firstShowProgressIndicatorTime ??= DateTime.now();
      task.estimatedCompletionTime = estimatedCompletionTime;

      final generations = jsonResponse['generations'] as List;

      if (generations.isEmpty) {
        isar.writeTxn(() async {
          isar.stableHordeTasks.put(task);
        });
        continue;
      }

      assert(generations.length == 1);

      final generation = generations.first;
      final imageUrl = generation['img'];

      // Download imageUrl to file
      final response2 = await http.get(Uri.parse(imageUrl));
      if (response2.statusCode != 200) {
        final exception = Exception(
          'Failed to download image: '
          '${response2.statusCode} ${response2.body}',
        );
        print(exception);
        Sentry.captureException(exception, stackTrace: StackTrace.current);
        continue;
      }

      final file = await _writeFile(response2.bodyBytes);

      task.imageUrl = imageUrl;
      task.imagePath = file.path;
      isar.writeTxn(() async {
        isar.stableHordeTasks.put(task);
      });
    }
  }

  Future<File> _writeFile(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.webp';
    final file = await File(path).create();
    print(file.path);

    // Write image to file
    await file.writeAsBytes(bytes);

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
}

final stableHordeBloc = _StableHordeBloc();
