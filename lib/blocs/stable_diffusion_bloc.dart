import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image/image.dart' as IMG;

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/model/pending_sd_task.dart';
import 'package:zoomscroller/model/sd_result.dart';

class StableDiffusionBloc {
  Future<String> _encodeAndUploadImage(ui.Image uiImage) async {
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

    final IMG.Image? image = IMG.decodeImage(byteData!.buffer.asUint8List());
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    if (image.width != 512 || image.height != 512) {
      throw Exception(
          'Image must be 512x512 (got ${image.width}x${image.height})');
    }

    final jpgBytes = IMG.encodeJpg(image, quality: 95);

    final uuid = Uuid().v4();

    final storage = FirebaseStorage.instance.ref();
    final ref = storage.child('processing_inputs/$uuid.jpg');
    await ref.putData(Uint8List.fromList(jpgBytes));

    return await ref.getDownloadURL();
  }

  Future requestDiffusion(
    String worldId,
    ui.Image? uiImage,
    String prompt,
    double mutationRate,
    Matrix4 transform, {
    int? numTasksToQueue,
  }) async {
    String? url;
    if (uiImage != null) {
      url = await _encodeAndUploadImage(uiImage);
    }

    await _clearPendingTasks();

    final userId = userBloc.getMyUserId()!;
    final queue = FirebaseFirestore.instance.collection('queued_tasks');

    if (numTasksToQueue == null) {
      final config = FirebaseRemoteConfig.instance;
      numTasksToQueue = config.getInt('num_tasks_to_queue');
    }

    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < numTasksToQueue; i++) {
      batch.set(
        queue.doc(),
        {
          'user_id': userId,
          'world_id': worldId,
          'image_url': url,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending',
          'prompt': prompt,
          'mutation_rate': mutationRate,
          'transform': transform.storage,
          'blend_with_parent': !transform.isIdentity(),
          'experimental_mode': userId == 'L5xmX0dCKZVNAGOj0lXSfgsHf2r1',
        },
      );
    }

    await batch.commit();

    print('done');
  }

  Future _clearPendingTasks() async {
    final userId = userBloc.getMyUserId()!;
    final queue = FirebaseFirestore.instance.collection('queued_tasks');
    final tasks = await queue.where('user_id', isEqualTo: userId).get();

    tasks.docs.forEach((element) {
      if (element.get('status') == 'pending') {
        element.reference.delete();
      }
    });
  }

  Stream<List<PendingSdTask>> getPendingTaskStream(String worldId) async* {
    final userId = userBloc.getMyUserId()!;
    final queue = FirebaseFirestore.instance.collection('queued_tasks');
    final tasks = queue
        .where('user_id', isEqualTo: userId)
        .where('world_id', isEqualTo: worldId);

    final snapshot = tasks.snapshots();

    await for (final event in snapshot) {
      final docs = event.docs;

      final List<PendingSdTask> tasks = [];
      for (final doc in docs) {
        final data = doc.data();
        final status = data['status'];
        final imageUrl = data['image_url'];
        final startTime = data['start_time'] as Timestamp?;
        final estimatedCompletionTime =
            data['estimated_completion_time'] as Timestamp?;
        if (status == 'pending') {
          tasks.add(PendingSdTask(
            imageUrl,
            SdTaskStatus.pending,
            startTime?.toDate(),
            estimatedCompletionTime?.toDate(),
          ));
        } else if (status == 'processing') {
          tasks.add(PendingSdTask(
            imageUrl,
            SdTaskStatus.processing,
            startTime?.toDate(),
            estimatedCompletionTime?.toDate(),
          ));
        }
      }

      tasks.sort((a, b) {
        if (a.status == SdTaskStatus.pending &&
            b.status == SdTaskStatus.processing) {
          return 1;
        } else if (a.status == SdTaskStatus.processing &&
            b.status == SdTaskStatus.pending) {
          return -1;
        } else {
          return 0;
        }
      });
      yield tasks;
    }
  }

  Stream<List<SdResult>> getSdResults(String worldId) async* {
    final snapshots = FirebaseFirestore.instance
        .collection('worlds')
        .doc(worldId)
        .collection('sd_outputs')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots();

    await for (var snapshot in snapshots) {
      final docs = snapshot.docs;
      yield docs.map(SdResult.fromDocument).toList();
    }
  }
}

final stableDiffusionBloc = StableDiffusionBloc();
