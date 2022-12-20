import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
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

    for (int i = 0; i < 30; i++) {
      await Future.delayed(Duration(seconds: 6));
      _updateTasks();
    }
  }

  Future _updateTasks() async {
    final tasks = await isar.stableHordeTasks.where().findAll();
    for (final task in tasks) {
      if (task.imageUrl != null) {
        continue;
      }

      final response = await http.get(
        Uri.parse(
            'https://stablehorde.net/api/v2/generate/status/${task.taskId}'),
      );
      if (response.statusCode != 200) {
        // TODO: handle error

        print('Failed to get task status: '
            '${response.statusCode} ${response.body}');

        // Delete task
        /*isar.writeTxn(() async {
          isar.stableHordeTasks.delete(task.id);
        });*/
        continue;
      }

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      final generations = jsonResponse['generations'] as List;

      if (generations.isEmpty) {
        continue;
      }

      assert(generations.length == 1);

      final generation = generations.first;
      final imageUrl = generation['img'];

      task.imageUrl = imageUrl;
      isar.writeTxn(() async {
        isar.stableHordeTasks.put(task);
      });
    }
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
