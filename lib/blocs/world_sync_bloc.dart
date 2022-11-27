import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/model/image_layer.dart';
import 'package:zoomscroller/model/sd_parameters.dart';
import 'package:zoomscroller/model/world.dart';
import 'dart:ui' as ui;

import 'package:image/image.dart' as IMG;

class WorldSyncBloc {
  Stream<List<World>> getAllWorlds() async* {
    final snapshots = FirebaseFirestore.instance
        .collection('worlds')
        .where('publish', isEqualTo: true)
        .orderBy('last_updated', descending: true)
        .snapshots();

    await for (final snapshot in snapshots) {
      final List<World> worlds = [];
      for (final doc in snapshot.docs) {
        final layer = World.fromDocument(doc);
        worlds.add(layer);
      }

      yield worlds;
    }
  }

  Stream<List<World>> getWorldsForDiscover() async* {
    final snapshots = FirebaseFirestore.instance
        .collection('worlds')
        .where('publish', isEqualTo: true)
        .where('approval_status', isEqualTo: 'approved')
        .orderBy('last_updated', descending: true)
        .snapshots();

    await for (final snapshot in snapshots) {
      final List<World> worlds = [];
      for (final doc in snapshot.docs) {
        final layer = World.fromDocument(doc);
        worlds.add(layer);
      }

      yield worlds;
    }
  }

  Stream<List<World>> getMyWorlds() async* {
    final userId = userBloc.getMyUserId()!;

    final snapshots = FirebaseFirestore.instance
        .collection('worlds')
        .where('user_id', isEqualTo: userId)
        .where('deleted', isEqualTo: false)
        .orderBy('last_updated', descending: true)
        .snapshots();

    await for (final snapshot in snapshots) {
      final List<World> worlds = [];
      for (final doc in snapshot.docs) {
        final layer = World.fromDocument(doc);
        worlds.add(layer);
      }

      yield worlds;
    }
  }

  Future<SdParameters?> retrieveSdParameters(String worldId) async {
    final world = await _getWorldDoc(worldId).get();

    if (!world.exists) return null;

    return SdParameters.fromDocument(world);
  }

  DocumentReference<Map<String, dynamic>> _getWorldDoc(worldId) {
    return FirebaseFirestore.instance.collection('worlds').doc(worldId);
  }

  Future updateSdParameters(
    String worldId,
    String prompt,
    double mutationRate,
  ) async {
    _getWorldDoc(worldId).set(
      {
        'prompt': prompt,
        'mutation_rate': mutationRate,
      },
      SetOptions(merge: true),
    );
  }

  Future setPublished(
    String worldId,
    bool publish,
  ) async {
    _getWorldDoc(worldId).set(
      {
        'publish': publish,
      },
      SetOptions(merge: true),
    );
  }

  Stream<bool> getPublished(
    String worldId,
  ) {
    return _getWorldDoc(worldId).snapshots().map((event) {
      return event.data()?['publish'] ?? false;
    });
  }

  Future setApprovalState(
    String worldId,
    bool approved,
  ) async {
    _getWorldDoc(worldId).set(
      {
        'approval_status': approved ? "approved" : "denied",
      },
      SetOptions(merge: true),
    );
  }

  Stream<bool> getApprovalState(
    String worldId,
  ) async* {
    final snapshots = _getWorldDoc(worldId).snapshots();

    await for (final snapshot in snapshots) {
      final approvalStatus = snapshot.get('approval_status');
      yield approvalStatus == "approved";
    }
  }

  Future deleteWorld(String worldId) async {
    await _getWorldDoc(worldId).update({
      'deleted': true,
      'publish': false,
    });
  }

  Future<String> _uploadImage(ui.Image uiImage) async {
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

    final IMG.Image? image = IMG.decodeImage(byteData!.buffer.asUint8List());

    final resized = IMG.copyResize(
      image!,
      width: 512,
      height: 512,
      interpolation: IMG.Interpolation.average,
    );

    final jpgBytes = IMG.encodePng(resized);

    final uuid = Uuid().v4();

    final storage = FirebaseStorage.instance.ref();
    final ref = storage.child('user_drawn/$uuid.png');
    await ref.putData(Uint8List.fromList(jpgBytes));

    return ref.getDownloadURL();
  }

  Future addLayerToWorldFromImage(
    String worldId,
    ui.Image uiImage,
    Matrix4 transform,
  ) async {
    final imageUrl = await _uploadImage(uiImage);
    final imageLayer = ImageLayer(transform, imageUrl: imageUrl);
    await addLayerToWorld(worldId, imageLayer);
  }

  Future createWorld(String worldId) async {
    final world = _getWorldDoc(worldId);

    await world.set({
      'last_updated': DateTime.now(),
      'user_id': userBloc.getMyUserId()!,
      'publish': false,
      'deleted': false,
      'approval_status': 'pending',
    }, SetOptions(merge: true));
  }

  Future<String> photocopyWorld(String worldId, {bool tutorial = false}) async {
    final batch = FirebaseFirestore.instance.batch();

    final newWorldId = Uuid().v4();
    final newWorld = _getWorldDoc(newWorldId);

    final oldWorld = _getWorldDoc(worldId);
    final worldData = (await oldWorld.get()).data()!;
    if (!tutorial) {
      worldData['original_user_id'] = worldData['user_id'];
    }
    worldData['user_id'] = userBloc.getMyUserId()!;
    worldData['publish'] = false;
    worldData['deleted'] = false;
    worldData['approval_status'] = 'pending';
    worldData['last_updated'] = DateTime.now();

    batch.set(newWorld, worldData);

    final layers =
        await oldWorld.collection('layers').orderBy('timestamp').get();

    for (final layer in layers.docs) {
      final newLayer = newWorld.collection('layers').doc();
      batch.set(newLayer, layer.data());
    }

    await batch.commit();

    return newWorldId;
  }

  Future<String?> getOriginalAuthorForWorld(String worldId) async {
    final world = _getWorldDoc(worldId);
    final worldData = (await world.get()).data()!;
    final userId = worldData['original_user_id'] ?? worldData['user_id'];

    if (userId == userBloc.getMyUserId()) return null;

    return userBloc.getUsernameForUserId(userId).first;
  }

  Future addLayerToWorld(String worldId, ImageLayer layer) async {
    final world = _getWorldDoc(worldId);

    final layers = world.collection('layers');

    await layers.add(layer.toMapForFirestore());

    world.set({
      'last_updated': DateTime.now(),
    }, SetOptions(merge: true));
  }

  Future updateThumbnailFromImage(String worldId, ui.Image uiImage) async {
    final imageUrl = await _uploadImage(uiImage);

    await updateThumbnailFromImageUrl(worldId, imageUrl);
  }

  Future updateThumbnailFromImageUrl(String worldId, String imageUrl) async {
    final world = _getWorldDoc(worldId);
    world.set({
      'image_url': imageUrl,
    }, SetOptions(merge: true));
  }

  Future popTopLayerFromWorld(String worldId) async {
    final layers = await _getWorldDoc(worldId)
        .collection('layers')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    for (final layer in layers.docs) {
      await layer.reference.delete();
    }
  }

  Stream<List<ImageLayer>> getLayersForWorld(String worldId) async* {
    final snapshots = _getWorldDoc(worldId)
        .collection('layers')
        .orderBy('timestamp')
        .snapshots();

    await for (final snapshot in snapshots) {
      final List<ImageLayer> imageLayers = [];
      for (final doc in snapshot.docs) {
        final layer = ImageLayer.fromDocument(doc);
        imageLayers.add(layer);
      }

      yield imageLayers;

      // Note: This could be done in parallel for better performance.
      for (final imageLayer in imageLayers) {
        await imageLayer.loadImageFromUrl();
        yield imageLayers;
      }
    }
  }
}

final worldSyncBloc = WorldSyncBloc();
